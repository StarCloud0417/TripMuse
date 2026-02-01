// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripAdapter extends TypeAdapter<Trip> {
  @override
  final int typeId = 0;

  @override
  Trip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trip(
      id: fields[0] as String,
      title: fields[1] as String,
      destination: fields[2] as Destination,
      days: (fields[3] as List).cast<DayPlan>(),
      preferenceAnalysis: fields[4] as UserPreferenceAnalysis,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      userId: fields[7] as String?,
      generatedBy: fields[8] as String?,
      isFavorite: fields[9] as bool,
      isShared: fields[10] as bool,
      shareToken: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Trip obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.destination)
      ..writeByte(3)
      ..write(obj.days)
      ..writeByte(4)
      ..write(obj.preferenceAnalysis)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.userId)
      ..writeByte(8)
      ..write(obj.generatedBy)
      ..writeByte(9)
      ..write(obj.isFavorite)
      ..writeByte(10)
      ..write(obj.isShared)
      ..writeByte(11)
      ..write(obj.shareToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripImpl _$$TripImplFromJson(Map<String, dynamic> json) => _$TripImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      destination:
          Destination.fromJson(json['destination'] as Map<String, dynamic>),
      days: (json['days'] as List<dynamic>)
          .map((e) => DayPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      preferenceAnalysis: UserPreferenceAnalysis.fromJson(
          json['preferenceAnalysis'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as String?,
      generatedBy: json['generatedBy'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isShared: json['isShared'] as bool? ?? false,
      shareToken: json['shareToken'] as String?,
    );

Map<String, dynamic> _$$TripImplToJson(_$TripImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'destination': instance.destination,
      'days': instance.days,
      'preferenceAnalysis': instance.preferenceAnalysis,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'userId': instance.userId,
      'generatedBy': instance.generatedBy,
      'isFavorite': instance.isFavorite,
      'isShared': instance.isShared,
      'shareToken': instance.shareToken,
    };
