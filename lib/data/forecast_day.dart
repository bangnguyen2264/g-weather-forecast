import 'package:json_annotation/json_annotation.dart';

part 'forecast_day.g.dart';

@JsonSerializable(explicitToJson: true)
class ForecastDay {
  final String? date;

  @JsonKey(name: 'day')
  final ForecastDayDetail? day;

  ForecastDay({
    this.date,
    this.day,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) =>
      _$ForecastDayFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastDayToJson(this);
}

@JsonSerializable()
class ForecastDayDetail {
  @JsonKey(name: 'maxtemp_c')
  final double? maxTempC;

  @JsonKey(name: 'mintemp_c')
  final double? minTempC;

  @JsonKey(name: 'maxwind_kph')
  final double? maxWindKph;

  @JsonKey(name: 'avghumidity')
  final int? avgHumidity;

  @JsonKey(name: 'condition')
  final ForecastCondition? condition;

  ForecastDayDetail({
    this.maxTempC,
    this.minTempC,
    this.maxWindKph,
    this.avgHumidity,
    this.condition,
  });

  factory ForecastDayDetail.fromJson(Map<String, dynamic> json) =>
      _$ForecastDayDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastDayDetailToJson(this);
}

@JsonSerializable()
class ForecastCondition {
  final String? text;
  final String? icon;

  ForecastCondition({this.text, this.icon});

  factory ForecastCondition.fromJson(Map<String, dynamic> json) =>
      _$ForecastConditionFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastConditionToJson(this);
}
