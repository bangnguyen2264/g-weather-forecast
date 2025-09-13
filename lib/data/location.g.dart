// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
  id: parseToInt(json['id']),
  name: json['name'] as String,
  region: parseToString(json['region']),
  country: json['country'] as String,
  lat: parseToDouble(json['lat']),
  long: parseToDouble(json['lon']),
  tzId: parseToString(json['tz_id']),
  localtime: parseToString(json['localtime']),
);

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'region': instance.region,
  'country': instance.country,
  'lat': instance.lat,
  'lon': instance.long,
  'tz_id': instance.tzId,
  'localtime': instance.localtime,
};
