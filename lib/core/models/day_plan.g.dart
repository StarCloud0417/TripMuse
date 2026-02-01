// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayPlanAdapter extends TypeAdapter<DayPlan> {
  @override
  final int typeId = 2;

  @override
  DayPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayPlan(
      dayIndex: fields[0] as int,
      date: fields[1] as DateTime,
      theme: fields[2] as String,
      activities: (fields[3] as List).cast<Activity>(),
    );
  }

  @override
  void write(BinaryWriter writer, DayPlan obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dayIndex)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.theme)
      ..writeByte(3)
      ..write(obj.activities);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DayPlanImpl _$$DayPlanImplFromJson(Map<String, dynamic> json) =>
    _$DayPlanImpl(
      dayIndex: (json['dayIndex'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      theme: json['theme'] as String,
      activities: (json['activities'] as List<dynamic>)
          .map((e) => Activity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DayPlanImplToJson(_$DayPlanImpl instance) =>
    <String, dynamic>{
      'dayIndex': instance.dayIndex,
      'date': instance.date.toIso8601String(),
      'theme': instance.theme,
      'activities': instance.activities,
    };
