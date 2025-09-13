import 'package:flutter/material.dart';
import 'package:gweatherforecast/presentation/search_viewmodel.dart';
import 'package:gweatherforecast/presentation/weather_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:gweatherforecast/data/location.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    final searchVM = context.watch<SearchViewModel>();
    final weatherVM = context.watch<WeatherViewModel>(); // watch để rebuild theo state

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Enter a City Name", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: searchVM.controller,
            decoration: InputDecoration(
              hintText: "E.g., New York, London, Tokyo",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onChanged: searchVM.onSearchChanged,
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                weatherVM.fetchWeather(value);
              }
            },
          ),

          const SizedBox(height: 8),

          // Loading bar khi fetch gợi ý
          if (searchVM.isLoading) const LinearProgressIndicator(),

          // Danh sách gợi ý
          if (searchVM.suggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: searchVM.suggestions.length,
                itemBuilder: (context, index) {
                  final Location loc = searchVM.suggestions[index];
                  return ListTile(
                    title: Text(formatLocationName(loc)),
                    onTap: () {
                      searchVM.selectLocation(loc);
                      searchVM.clearSuggestions();
                      weatherVM.fetchWeather(formatLocationName(loc));
                    },
                  );
                },
              ),
            ),

          // Thông báo lỗi từ SearchVM
          if (searchVM.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(searchVM.errorMessage!, style: const TextStyle(color: Colors.red)),
            ),

          const SizedBox(height: 12),

          // Button search
          ElevatedButton(
            onPressed: weatherVM.isLoading
                ? null
                : () {
                    if (searchVM.controller.text.isNotEmpty) {
                      print("Searching for ${searchVM.controller.text}");
                      weatherVM.fetchWeather(searchVM.controller.text);
                    }
                  },
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
            child: weatherVM.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Search"),
          ),

          const SizedBox(height: 8),
          Row(
            children: const [
              Expanded(child: Divider()),
              Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text("or")),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 8),

          // Button current location
          ElevatedButton(
            onPressed: weatherVM.isLoading
                ? null
                : () {
                    weatherVM.fetchWeatherByCurrentLocation();
                    searchVM.controller.clear();
                    searchVM.clearSuggestions();
                  },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(45),
              backgroundColor: Colors.grey,
            ),
            child: weatherVM.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Use Current Location"),
          ),

          // Thông báo lỗi từ WeatherVM
          if (weatherVM.errorMessage != null && weatherVM.errorMessage!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(weatherVM.errorMessage!, style: const TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }
}
