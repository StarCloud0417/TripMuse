// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_request.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripRequestAdapter extends TypeAdapter<TripRequest> {
  @override
  final int typeId = 11;

  @override
  TripRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripRequest(
      destination: fields[0] as Destination,
      duration: fields[1] as TripDuration,
      travelDescription: fields[2] as String,
      basicPreferences: fields[3] as BasicPreferences,
      locale: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TripRequest obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.destination)
      ..writeByte(1)
      ..write(obj.duration)
      ..writeByte(2)
      ..write(obj.travelDescription)
      ..writeByte(3)
      ..write(obj.basicPreferences)
      ..writeByte(4)
      ..write(obj.locale);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TripDurationAdapter extends TypeAdapter<TripDuration> {
  @override
  final int typeId = 12;

  @override
  TripDuration read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripDuration(
      days: fields[0] as int,
      startDate: fields[1] as DateTime,
      endDate: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TripDuration obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.days)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.endDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripDurationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripRequestImpl _$$TripRequestImplFromJson(Map<String, dynamic> json) =>
    _$TripRequestImpl(
      destination:
          Destination.fromJson(json['destination'] as Map<String, dynamic>),
      duration: TripDuration.fromJson(json['duration'] as Map<String, dynamic>),
      travelDescription: json['travelDescription'] as String,
      basicPreferences: BasicPreferences.fromJson(
          json['basicPreferences'] as Map<String, dynamic>),
      locale: json['locale'] as String? ?? 'zh-TW',
    );

Map<String, dynamic> _$$TripRequestImplToJson(_$TripRequestImpl instance) =>
    <String, dynamic>{
      'destination': instance.destination,
      'duration': instance.duration,
      'travelDescription': instance.travelDescription,
      'basicPreferences': instance.basicPreferences,
      'locale': instance.locale,
    };

_$TripDurationImpl _$$TripDurationImplFromJson(Map<String, dynamic> json) =>
    _$TripDurationImpl(
      days: (json['days'] as num).toInt(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$$TripDurationImplToJson(_$TripDurationImpl instance) =>
    <String, dynamic>{
      'days': instance.days,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
    };
