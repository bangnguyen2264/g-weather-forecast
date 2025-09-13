// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherAlert _$WeatherAlertFromJson(Map<String, dynamic> json) => WeatherAlert(
  headline: json['headline'] as String,
  category: json['category'] as String?,
  event: json['event'] as String?,
  desc: json['desc'] as String?,
  effective: json['effective'] as String?,
  expires: json['expires'] as String?,
);

Map<String, dynamic> _$WeatherAlertToJson(WeatherAlert instance) =>
    <String, dynamic>{
      'headline': instance.headline,
      'category': instance.category,
      'event': instance.event,
      'desc': instance.desc,
      'effective': instance.effective,
      'expires': instance.expires,
    };
