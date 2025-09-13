// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
  temperatureC: (json['temp_c'] as num).toDouble(),
  windKph: (json['wind_kph'] as num).toDouble(),
  humidity: (json['humidity'] as num).toInt(),
  condition: WeatherCondition.fromJson(
    json['condition'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
  'temp_c': instance.temperatureC,
  'wind_kph': instance.windKph,
  'humidity': instance.humidity,
  'condition': instance.condition.toJson(),
};

WeatherCondition _$WeatherConditionFromJson(Map<String, dynamic> json) =>
    WeatherCondition(
      text: json['text'] as String,
      icon: json['icon'] as String,
      code: (json['code'] as num).toInt(),
    );

Map<String, dynamic> _$WeatherConditionToJson(WeatherCondition instance) =>
    <String, dynamic>{
      'text': instance.text,
      'icon': instance.icon,
      'code': instance.code,
    };
