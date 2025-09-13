import 'package:gweatherforecast/resource/utils/parsing_helper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable(explicitToJson: true)
class Location {
  @JsonKey(name: 'id', fromJson: parseToInt)
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'region', fromJson: parseToString)
  final String? region;

  @JsonKey(name: 'country')
  final String country;

  @JsonKey(name: 'lat', fromJson: parseToDouble)
  final double lat;

  @JsonKey(name: 'lon', fromJson: parseToDouble)
  final double long;

  @JsonKey(name: 'tz_id', fromJson: parseToString)
  final String? tzId; // có thể null

  @JsonKey(name: 'localtime', fromJson: parseToString)
  final String? localtime; // có thể null

  Location({
    required this.id,
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.long,
    this.tzId,
    this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    try {
      return _$LocationFromJson(json);
    } catch (e) {
      print('Error parsing Location JSON: $e - JSON: $json');
      throw Exception('Failed to parse Location: $e');
    }
  }

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

String formatLocationName(Location loc) {
  return loc.region != null && loc.region!.isNotEmpty
      ? '${loc.name}, ${loc.region}, ${loc.country}'
      : '${loc.name}, ${loc.country}';
}
