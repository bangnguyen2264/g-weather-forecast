import 'package:flutter/material.dart';
import 'package:gweatherforecast/data/forecast_day.dart';

class ForecastCard extends StatelessWidget {
  final ForecastDay day;
  const ForecastCard({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade600,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day.date ?? 'N/A',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),

          Image.network(day.day?.condition?.icon ?? '', width: 50, height: 50),
          const SizedBox(height: 8),
          Text("Temp: ${day.day?.maxTempC}°C", style: const TextStyle(color: Colors.white)),
          Text("Wind: ${day.day?.maxWindKph} km/h", style: const TextStyle(color: Colors.white)),
          Text("Humidity: ${day.day?.avgHumidity}%", style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
