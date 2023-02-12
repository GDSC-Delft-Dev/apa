import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService {

  final String key = 'AIzaSyAawI0easc_9l11sxcphOIPREa6aw4aoOg';

  Future<String> getPlaceId(String input) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;
    print(placeId);
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&inputtype=textquery&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    // Cast as map
    var results = json['result'] as Map<String, dynamic>;
    print(results);
    return results;
  }

}