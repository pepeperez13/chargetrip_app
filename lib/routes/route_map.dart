import 'dart:async';
import 'dart:ui';

import 'package:chargetrip_app/car_info/car_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:chargetrip_app/routes/locations.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:chargetrip_app/car_info/car.dart';


/// Esta clase contiene toda la visualización y acciones que ocurren en la pantalla del mapa

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> with AutomaticKeepAliveClientMixin {
  // Controladores del mapa y de los textFormField
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  TextEditingController initialLocationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  // Guardan localizaciones inicial y final de la ruta
  Map<String, dynamic> initialLocation = {};
  Map<String, dynamic> destinationLocation = {};

  // Marcadores, lineas y circulos que tendrá el mapa
  Set<Marker> routeMarkers = <Marker>{};
  Set<Polyline> polylines = <Polyline>{};
  Set<Circle> circles = <Circle>{};

  // Necesitamos que esta variable (que se actualiza desde "car_settings" sea estática
  // para que su valor no se pierda al pasar de la página de "car_settings" al propio mapa
  static Car currentcar = CarSettingsState().defaultCar;

  // Funcion que se llama desde car_settings para actualizar el coche actual
  callback(car) {
      currentcar = car;
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  void setMarker (Marker marker) {
    setState(() {
      routeMarkers.add(marker);
    });
  }

  void setPolyline (Polyline polyline) {
    setState(() {
      polylines.add(polyline);
    });
  }

  // Debemos poner future y async ya que debe esperar a obtener los resultados por parte de la API
  Future<void> saveLocations () async {
    initialLocation = await LocationFinder().getPlace(initialLocationController.text);
    destinationLocation = await LocationFinder().getPlace(destinationController.text);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          // Mapa de fondo (stack)
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            markers: routeMarkers,
            polylines: polylines,
            circles: circles,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: findChargers,
          ),

          Column(
            // Columna que contiene los dos TextFormField
            children: [
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child:
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0)
                          ),
                          filled: true,
                          fillColor: Colors.blue[800]?.withOpacity(0.8),
                          hintText: 'Enter your initial location',
                          labelText: 'Initial location',
                          labelStyle: const TextStyle(fontSize: 18, color: Colors.white)
                      ),
                      controller: initialLocationController,
                    ),
                  ),
                  const SizedBox(width: 10)
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child:
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0)
                          ),
                          filled: true,
                          fillColor: Colors.blue[800]?.withOpacity(0.8),
                          hintText: 'Enter your final destination',
                          labelText: 'Final destination',
                          labelStyle: const TextStyle(fontSize: 18, color: Colors.white),

                      ),
                      controller: destinationController,
                    ),
                  ),
                  const SizedBox(width: 10)
                ],
              ),
            ],
          )
        ],
      ),
      // Botón que debe apretarse para trazar una ruta
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Guardamos ubiaciones de inicio y fin y encontramos la ruta
          await saveLocations();
          var route = await LocationFinder().getDirections(initialLocationController.text, destinationController.text);
          goToRoute(route['start_location']['lat'], route['start_location']['lng'], route['polyline_decoded'], route['bounds_ne'], route['bounds_sw']) ;

          // Llamamos al metodo que calcula si hay suficiente rango y mostramos un dialog
          showDialog(context: context, builder: (context) => enoughRange(route));

        },
        label: const Text('Go to destination'),
        icon: const Icon(Icons.electrical_services),
        backgroundColor: Colors.blue[800],
      ),
      //bottomNavigationBar: const NavigatorBar(),
    );


  }

  // Método que pone los marcadores de ruta (inicio y fin)
  void placeMarkers ()  {
    final double latitudI = initialLocation['geometry']['location']['lat'];
    final double longitudI = initialLocation['geometry']['location']['lng'];
    final double latitudD = destinationLocation['geometry']['location']['lat'];
    final double longitudD = destinationLocation['geometry']['location']['lng'];

    Marker markerOrigin = Marker(
        markerId: const MarkerId('Initial Location'),
        position: LatLng(latitudI, longitudI),
        icon: BitmapDescriptor.defaultMarker
    );

    Marker markerDestiny = Marker(
        markerId: const MarkerId('Final Destination'),
        position: LatLng(latitudD, longitudD),
        icon: BitmapDescriptor.defaultMarker
    );

    setMarker(markerOrigin);
    setMarker(markerDestiny);

  }

  // Método que mueve la cámara y dibuja la línea de la ruta especificada
  Future<void> goToRoute(double latitude, double longitude, List<PointLatLng> points, Map<String, dynamic> boundsNe, Map<String, dynamic> boundsSw) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 12)
    ));

    Polyline newPolyline =  Polyline(
      polylineId: PolylineId('route'),
      width: 4,
      color: Colors.lightGreenAccent,
      points: points.map((point) => LatLng(point.latitude, point.longitude)).toList(),

    );

    placeMarkers();
    setPolyline(newPolyline);

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
            northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
          ),
          25),
    );

  }
  
  AlertDialog enoughRange(Map<String, dynamic> route) {
    late AlertDialog alertDialog;
    // Comprobamos si la distancia a recorrer es mayor que el rango del coche
    var distance = route['distance']/1000;
    var range = currentcar.range;
    String difference = (distance-range).toString().split('.')[0];
    // Segun si hay suficiente autonomía o no, se muestra un AlertDialog u otro
     if (range < distance ) {
       alertDialog = AlertDialog(
         title: const Text('Oh no!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
         content: Text('Your current car does not have enough range for this route. Try buying a car that has at least $difference KM of extra range ;)',
                        style: const TextStyle(fontSize: 18),),
         actions: [
           TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('OK', style: TextStyle(fontSize: 20),))
         ],
         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
       );
     }else {
       alertDialog = AlertDialog(
         title: const Text('Congratulations!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
         content: const Text('Your current car has enough range for this route!', style: TextStyle(fontSize: 18),),
         actions: [
           TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('OK', style: TextStyle(fontSize: 20),))
         ],
         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
       );
     }
     return alertDialog;
  }

  // Cuando el usuario aprieta en un lugar del mapa, trazamos un circulo de radio 9000 y mostramos todos los cargadores de EV que haya en el área
  void findChargers (LatLng point) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: point, zoom: 11)
    ));

    //Llamamos al metodo que encuentra los sitios cercanos y guardammos los resultados en una lista
    var places = await LocationFinder().getPlaceDetails(point, 7500);
    List<dynamic> areaChargers = places['results'] as List;

    int countElement = 0;
    final Uint8List chargerMarker;
    chargerMarker = await getBytesFromAsset();

    // Añadimos marcador para cada elemento encontrado
    for (var element in areaChargers) {
        setMarker(
            Marker(
                markerId: MarkerId(countElement.toString()),
                position: LatLng(element['geometry']['location']['lat'], element['geometry']['location']['lng']),
                icon: BitmapDescriptor.fromBytes(chargerMarker)
            )
        );
      countElement++;
    }

    setState(() {
      circles.add( Circle(circleId: CircleId('nearChargers'), center: point, fillColor: Colors.amber.withOpacity(0.2), radius: 9000, strokeColor: Colors.blue, strokeWidth: 1));
    });

  }

  //Obtiene los bytes para el marker del cargador electrico
  Future<Uint8List> getBytesFromAsset() async {
    ByteData data = await rootBundle.load('assets/chargerMarker.png');

    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: 200);
    FrameInfo frameInfo = await codec.getNextFrame();
    return(await frameInfo.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }

  // Queremos que se mentenga el estado de la pantalla aunque salgamos de esta
  @override
  bool get wantKeepAlive => true;

}