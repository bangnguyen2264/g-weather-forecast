import 'package:flutter/material.dart';
import 'package:gweatherforecast/data/location.dart';
import 'package:gweatherforecast/data/weather.dart';

class CurrentWeatherCard extends StatelessWidget {
  final Location location;
  final Weather weather;
  const CurrentWeatherCard({super.key, required this.location, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${location.name} (${location.localtime})",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  "Temperature: ${weather.temperatureC}°C",
                  style: TextStyle(color: Colors.white),
                ),
                Text("Wind: ${weather.windKph} KPH", style: TextStyle(color: Colors.white)),
                Text("Humidity: ${weather.humidity}%", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Column(
            children:  [
              Image.network(weather.condition.icon),
              SizedBox(height: 4),
              Text(weather.condition.text, style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
