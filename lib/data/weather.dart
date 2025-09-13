import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable(explicitToJson: true)
class Weather {
  @JsonKey(name: 'temp_c')
  final double temperatureC;

  @JsonKey(name: 'wind_kph')
  final double windKph;

  @JsonKey(name: 'humidity')
  final int humidity;

  @JsonKey(name: 'condition')
  final WeatherCondition condition;

  @JsonKey(ignore: true)
  final String? locationName;

  @JsonKey(ignore: true)
  final String? date;

  Weather({
    required this.temperatureC,
    required this.windKph,
    required this.humidity,
    required this.condition,
    this.locationName,
    this.date,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}

@JsonSerializable()
class WeatherCondition {
  @JsonKey(name: 'text')
  final String text;
  @JsonKey(name: 'icon')
  final String icon;
  @JsonKey(name: 'code')
  final int code;

  WeatherCondition({required this.text, required this.icon, required this.code});

  factory WeatherCondition.fromJson(Map<String, dynamic> json) =>
      _$WeatherConditionFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherConditionToJson(this);
}
