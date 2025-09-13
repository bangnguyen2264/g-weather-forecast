// models/weather_models.dart
import 'package:json_annotation/json_annotation.dart';

part 'weather_alert.g.dart';

@JsonSerializable()
class WeatherAlert {
  final String headline;
  final String? category;
  final String? event;
  final String? desc;
  final String? effective;
  final String? expires;

  WeatherAlert({
    required this.headline,
    this.category,
    this.event,
    this.desc,
    this.effective,
    this.expires,
  });

  factory WeatherAlert.fromJson(Map<String, dynamic> json) =>
      _$WeatherAlertFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherAlertToJson(this);
}

