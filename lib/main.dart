import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:chargetrip_app/locations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  TextEditingController initialLocationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  Set<Marker> markers = <Marker>{};



  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  void setMarker (LatLng coordenadas) {
    setState(() {
      markers.add(Marker(
          markerId: const MarkerId('marker'),
          position: coordenadas,
          icon: BitmapDescriptor.defaultMarker

      ),

      );
    });
    print("PONIENDO MARKEEEEER");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),

          Column(
            children: [
              const SizedBox(
                height: 50,
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
                        //icon: Icon(Icons.person),
                        hintText: 'Enter your initial location',
                        //labelText: 'Name *',

                      ),
                      controller: initialLocationController,
                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                    ),
                  ),
                  IconButton(onPressed: () async {
                    var place = await LocationFinder().getPlace(initialLocationController.text);
                    goToNewLocation(place);
                  },
                      icon: Icon(Icons.search)),
                  const SizedBox(width: 10)

                  //IconButton(onPressed: () {}, icon: const Icon(Icons.search),)
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
                        //icon: Icon(Icons.person),
                        hintText: 'Enter your final destination',
                        //labelText: 'Name *',

                      ),
                      controller: destinationController,
                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                    ),
                  ),
                  IconButton(onPressed: () async {
                    var place = await LocationFinder().getPlace(destinationController.text);
                    goToNewLocation(place);
                  },
                      icon: Icon(Icons.search)),
                  const SizedBox(width: 10)

                  //IconButton(onPressed: () {}, icon: const Icon(Icons.search),)
                ],
              ),


            ],
          )


        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );


  }


  Future<void> goToNewLocation(Map<String, dynamic> location) async {
    final double latitud = location['geometry']['location']['lat'];
    final double longitud = location['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitud, longitud), zoom: 12)
    ));
    markers.add(Marker(
        markerId: const MarkerId('marker'),
        position: LatLng(latitud, longitud),
        icon: BitmapDescriptor.defaultMarker
    ));

  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    //controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}