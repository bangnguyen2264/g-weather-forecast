// weather_view_model.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gweatherforecast/data/forecast_day.dart';
import 'package:gweatherforecast/data/location.dart';
import 'package:gweatherforecast/data/weather.dart';
import 'package:gweatherforecast/resource/service/location_service.dart';
import 'package:gweatherforecast/resource/service/weather_service.dart';

class WeatherViewModel with ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  Location? _location;
  Weather? _currentWeather;
  List<ForecastDay>? _forecast;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isInitialized = false;
  Location? get location => _location;
  Weather? get currentWeather => _currentWeather;
  List<ForecastDay>? get forecast => _forecast;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  WeatherViewModel() {
    // Delay initialization to allow the framework to set up
    Future.microtask(_initialize);
  }

  // Initialize the view model
  Future<void> _initialize() async {
    if (!_isInitialized) {
      await fetchWeatherByCurrentLocation();
      _isInitialized = true;
    }
  }

  // Fetch weather by location name or coordinates
  Future<void> fetchWeather(String location) async {
    if (_isLoading) return;
    _setLoading(true);
    _errorMessage = null;

    try {
      final weatherForecast = await _weatherService.fetchWeather(location: location);
      _location = weatherForecast.location;
      _currentWeather = weatherForecast.currentWeather;
      _forecast = weatherForecast.forecast;
    } catch (e) {
      _errorMessage = 'Failed to fetch weather: $e';
    } finally {
      _setLoading(false);
      
    }
  }

  // Fetch weather based on current location using geolocator
  Future<void> fetchWeatherByCurrentLocation() async {
    if (_isLoading) return;
    _setLoading(true);
    _errorMessage = '';

    try {
      // Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = 'Location permissions are denied';
          _setLoading(false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _errorMessage =
            'Location permissions are permanently denied, we cannot request permissions.';
        _setLoading(false);
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      print('Current position latitude: ${position.latitude}, longitude: ${position.longitude}');
      String locationName = '${position.latitude},${position.longitude}';
      _locationService.saveCurrentLocation(locationName);
      print('Resolved location name: $locationName');
      final weatherForecast = await _weatherService.fetchWeather(location: locationName);
      _location = weatherForecast.location;
      _currentWeather = weatherForecast.currentWeather;
      _forecast = weatherForecast.forecast;
    } catch (e) {
      print('Error fetching location or weather: $e');
      _errorMessage = 'Error fetching location or weather: $e';
    } finally {
      _setLoading(false);
    }
  }

  // Helper method to set loading state and notify listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
