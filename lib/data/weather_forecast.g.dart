// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_forecast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherForecast _$WeatherForecastFromJson(Map<String, dynamic> json) =>
    WeatherForecast(
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
      currentWeather: json['current'] == null
          ? null
          : Weather.fromJson(json['current'] as Map<String, dynamic>),
      forecast: _forecastFromJson(json['forecast']),
      alerts: _alertsFromJson(json['alerts']),
    );

Map<String, dynamic> _$WeatherForecastToJson(WeatherForecast instance) =>
    <String, dynamic>{
      'location': instance.location?.toJson(),
      'current': instance.currentWeather?.toJson(),
      'forecast': instance.forecast?.map((e) => e.toJson()).toList(),
      'alerts': instance.alerts?.map((e) => e.toJson()).toList(),
    };
