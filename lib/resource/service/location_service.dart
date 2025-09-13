import 'dart:convert';

import 'package:gweatherforecast/data/location.dart';
import 'package:gweatherforecast/resource/constants/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  Future<List<Location>> fetchLocation(String q) async {
    final uri = Uri.parse(
      '${ApiClient.apiUrl}${ApiClient.searchEndpoint}?key=${ApiClient.apiKey}&q=$q',
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Location.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load location data');
    }
  }

  // Future<String?> getPlaceNameFromOSM(double lat, double lon) async {
  //   final url = Uri.parse(
  //     'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon',
  //   );
  //   final response = await http.get(
  //     url,
  //     headers: {'User-Agent': 'GWeatherForecast/1.0 (ngtbang2264.dev@gmail.com)'},
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return data['display_name'];
  //   }
  //   return null;
  // }

  Future<void> saveCurrentLocation(String location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_location', location);
  }
}
