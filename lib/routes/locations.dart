import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class LocationFinder {
  //final String key = 'API_KEY';

  // Obtiene el código del lugar que hemos buscado
  Future<String> getPlaceID (String input) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=AIzaSyDb07faU3tiBmEKJjRe1KaTL_gtG8DhUcw';

    var response = await get(Uri.parse(url));
    var json = jsonDecode(response.body);
    var placeID = json['candidates'][0]['place_id'] as String;

    //print("THE PLACE ID Is $placeID");
    return placeID;
  }


  Future<Map<String, dynamic>> getPlace (String input) async {
    final placeID = await getPlaceID(input);

    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=AIzaSyDb07faU3tiBmEKJjRe1KaTL_gtG8DhUcw';

    var response = await get(Uri.parse(url));
    var json = jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;

    //print("LOS RESULTADOS SON $results");
    return results;

  }

  Future<Map<String, dynamic>> getDirections (String origin, String destiny) async {

    final String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destiny&key=AIzaSyDb07faU3tiBmEKJjRe1KaTL_gtG8DhUcw';

    var response = await get(Uri.parse(url));
    var json = jsonDecode(response.body);

    print(json);
    var polyline =json['routes'][0]['overview_polyline']['points'];

    var results = {
      'distance' : json['routes'][0]['legs'][0]['distance']['value'],
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline_decoded': PolylinePoints().decodePolyline(polyline),
    };

    print('lalalaalalllalaa  $results');
    return results;


  }


}