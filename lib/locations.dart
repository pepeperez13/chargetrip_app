import 'package:http/http.dart';
import 'dart:convert';

class LocationFinder {
  //final String key = 'API_KEY';

  // Obtiene el código del lugar que hemos buscado
  Future<String> getPlaceID (String input) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=AIzaSyDb07faU3tiBmEKJjRe1KaTL_gtG8DhUcw';

    var response = await get(Uri.parse(url));
    var json = jsonDecode(response.body);
    var placeID = json['candidates'][0]['place_id'] as String;

    print("THE PLACE ID Is $placeID");
    return placeID;
  }


  Future<Map<String, dynamic>> getPlace (String input) async {
    final placeID = await getPlaceID(input);

    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=AIzaSyDb07faU3tiBmEKJjRe1KaTL_gtG8DhUcw';

    var response = await get(Uri.parse(url));
    var json = jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;

    print("LOS RESULTADOS SON $results");
    return results;

  }


}