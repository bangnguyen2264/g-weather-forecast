import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gweatherforecast/data/weather_forecast.dart';
import 'package:gweatherforecast/resource/constants/api_client.dart';
import 'package:gweatherforecast/resource/service/weather_cache_service.dart';

class WeatherService {
  Future<WeatherForecast> fetchWeather({
    required String location,
    int days = 14,
    String lang = 'en',
  }) async {
    final url = Uri.parse(
      '${ApiClient.apiUrl}/${ApiClient.forecastEndpoint}'
      '?key=${ApiClient.apiKey}'
      '&q=$location'
      '&days=$days'
      '&lang=$lang',
    );
    print("Fetching weather for: $location (cacheKey=$url)");

    try {
      //1. Check cache trước
      final cached = await WeatherCacheService.loadHistory(key: url.toString());
      if (cached != null) {
        print("Loaded weather from cache for $location");
        return WeatherForecast.fromJson(cached);
      }

      //2. Nếu không có cache → call API
      print("Loaded weather from HTTP GET request to: $url");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        // print("Weather API response for $location: $jsonData");

        //3. Save cache tới hết ngày
        await WeatherCacheService.saveHistory(key: url.toString(), data: jsonData);

        return WeatherForecast.fromJson(jsonData);
      } else {
        throw Exception("Failed to load weather data: ${response.statusCode}");
      }
    } catch (e) {
      print(" Error fetching weather: $e");
      throw Exception("Error fetching weather: $e");
    }
  }
}
