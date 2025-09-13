// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForecastDay _$ForecastDayFromJson(Map<String, dynamic> json) => ForecastDay(
  date: json['date'] as String?,
  day: json['day'] == null
      ? null
      : ForecastDayDetail.fromJson(json['day'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ForecastDayToJson(ForecastDay instance) =>
    <String, dynamic>{'date': instance.date, 'day': instance.day?.toJson()};

ForecastDayDetail _$ForecastDayDetailFromJson(Map<String, dynamic> json) =>
    ForecastDayDetail(
      maxTempC: (json['maxtemp_c'] as num?)?.toDouble(),
      minTempC: (json['mintemp_c'] as num?)?.toDouble(),
      maxWindKph: (json['maxwind_kph'] as num?)?.toDouble(),
      avgHumidity: (json['avghumidity'] as num?)?.toInt(),
      condition: json['condition'] == null
          ? null
          : ForecastCondition.fromJson(
              json['condition'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ForecastDayDetailToJson(ForecastDayDetail instance) =>
    <String, dynamic>{
      'maxtemp_c': instance.maxTempC,
      'mintemp_c': instance.minTempC,
      'maxwind_kph': instance.maxWindKph,
      'avghumidity': instance.avgHumidity,
      'condition': instance.condition,
    };

ForecastCondition _$ForecastConditionFromJson(Map<String, dynamic> json) =>
    ForecastCondition(
      text: json['text'] as String?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$ForecastConditionToJson(ForecastCondition instance) =>
    <String, dynamic>{'text': instance.text, 'icon': instance.icon};
