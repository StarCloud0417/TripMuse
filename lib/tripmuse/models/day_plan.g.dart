// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DayPlanImpl _$$DayPlanImplFromJson(Map<String, dynamic> json) =>
    _$DayPlanImpl(
      dayIndex: (json['dayIndex'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      theme: json['theme'] as String,
      activities: (json['activities'] as List<dynamic>?)
              ?.map((e) => Activity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      notes: json['notes'] as String?,
      estimatedTotalCost: json['estimatedTotalCost'] as String?,
    );

Map<String, dynamic> _$$DayPlanImplToJson(_$DayPlanImpl instance) =>
    <String, dynamic>{
      'dayIndex': instance.dayIndex,
      'date': instance.date.toIso8601String(),
      'theme': instance.theme,
      'activities': instance.activities.map((e) => e.toJson()).toList(),
      'notes': instance.notes,
      'estimatedTotalCost': instance.estimatedTotalCost,
    };
