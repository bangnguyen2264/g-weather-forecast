import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gweatherforecast/data/location.dart';
import 'package:gweatherforecast/resource/service/location_service.dart';

class SearchViewModel with ChangeNotifier {
  final LocationService _locationService = LocationService();
  final TextEditingController controller = TextEditingController();

  List<Location> _suggestions = [];
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _debounce;

  List<Location> get suggestions => _suggestions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Gọi API với debounce khi user gõ
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isNotEmpty) {
        await fetchSuggestions(query);
      } else {
        _suggestions = [];
        notifyListeners();
      }
    });
  }

  // Fetch location suggestions từ API
  Future<void> fetchSuggestions(String query) async {
    try {
      _isLoading = true;
      notifyListeners();

      final results = await _locationService.fetchLocation(query);
      _suggestions = results;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Failed to fetch locations: $e";
      _suggestions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSuggestions() {
    _suggestions = [];
    notifyListeners();
  }

  // Khi user chọn location
  void selectLocation(Location location) {
    controller.text = location.name;
    _suggestions = [];
    notifyListeners();
  }

  @override
  void dispose() {
    controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
