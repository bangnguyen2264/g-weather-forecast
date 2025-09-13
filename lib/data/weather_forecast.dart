import 'package:gweatherforecast/data/location.dart';
import 'package:gweatherforecast/data/weather_alert.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:gweatherforecast/data/weather.dart';
import 'package:gweatherforecast/data/forecast_day.dart';

part 'weather_forecast.g.dart';

@JsonSerializable(explicitToJson: true)
class WeatherForecast {
  @JsonKey(name: 'location')
  final Location? location;
  @JsonKey(name: 'current')
  final Weather? currentWeather;
  @JsonKey(name: 'forecast', fromJson: _forecastFromJson)
  final List<ForecastDay>? forecast;
  @JsonKey(name: 'alerts', fromJson: _alertsFromJson)
  final List<WeatherAlert>? alerts;

  WeatherForecast({ this.location, this.currentWeather, this.forecast, this.alerts});

  factory WeatherForecast.fromJson(Map<String, dynamic> json) => _$WeatherForecastFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherForecastToJson(this);
}

// Helper function for forecast list
List<ForecastDay>? _forecastFromJson(dynamic json) {
  if (json == null || json['forecastday'] == null) return null;
  final list = json['forecastday'] as List<dynamic>?;
  return list?.map((item) => ForecastDay.fromJson(item as Map<String, dynamic>)).toList();
}

List<WeatherAlert>? _alertsFromJson(dynamic json) {
  if (json == null || json['alert'] == null) return null;
  final list = json['alert'] as List<dynamic>?;
  return list?.map((item) => WeatherAlert.fromJson(item as Map<String, dynamic>)).toList();
}
