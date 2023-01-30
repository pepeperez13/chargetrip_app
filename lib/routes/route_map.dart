import 'dart:async';

import 'package:chargetrip_app/car_info/car_settings.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:chargetrip_app/routes/locations.dart';
import 'package:chargetrip_app/bottom_navigation/navigator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../car_info/car.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> with AutomaticKeepAliveClientMixin {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  TextEditingController initialLocationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  Map<String, dynamic> initialLocation = {};
  Map<String, dynamic> destinationLocation = {};

  Set<Marker> markers = <Marker>{};
  Set<Polyline> polylines = <Polyline>{};

  // Necesitamos que esta variable (que se actualiza desde "car_settings" sea estática
  // para que su valor no se pierda al pasar de la página de "car_settings" al propio mapa
  static Car currentcar = CarSettingsState().defaultCar;

  callback(car) {
    //setState(() {
      currentcar = car;
    //});
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  void setMarker (Marker marker) {
    setState(() {
      markers.add(marker);
    });
    print("PONIENDO MARKEEEEER");
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
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            markers: markers,
            polylines: polylines,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),

          Column(
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
                          fillColor: Colors.grey,
                          hintText: 'Enter your initial location',
                          labelText: 'Initial location',
                          labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
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
                          fillColor: Colors.grey,
                          hintText: 'Enter your final destination',
                          labelText: 'Final destination',
                          labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)

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
      ),
      //bottomNavigationBar: const NavigatorBar(),
    );


  }

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


  Future<void> goToNewLocation(Map<String, dynamic> location) async {
    final double latitud = location['geometry']['location']['lat'];
    final double longitud = location['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitud, longitud), zoom: 12)
    ));

    Marker newMarker = Marker(
        markerId: const MarkerId('Initial Destination'),
        position: LatLng(latitud, longitud),
        icon: BitmapDescriptor.defaultMarker
    );
    setMarker(newMarker);
  }

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
    //var range = CarSettingsState().getCurrentCar().range;
    var range = currentcar.range;
     if (range < distance ) {
       print(distance);
       alertDialog = AlertDialog(
         title: const Text('Oh no!'),
         content: const Text('Your current car does''nt have enough range for this route'),
         actions: [
           TextButton(onPressed: (){Navigator.pop(context);}, child: Text('OK'))
         ],
         
       );
     }else {
       alertDialog = AlertDialog(
         title: const Text('Congratulations!'),
         content: const Text('Your current car has enough range for this route'),
         actions: [
           TextButton(onPressed: (){Navigator.pop(context);}, child: Text('OK'))
         ],

       );
     }
     return alertDialog;
  }

  // Queremos que se mentenga el estado
  @override
  bool get wantKeepAlive => true;

}