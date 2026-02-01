// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  final int typeId = 3;

  @override
  Activity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Activity(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      lat: fields[3] as double,
      lng: fields[4] as double,
      timeFrom: fields[5] as String,
      timeTo: fields[6] as String,
      category: fields[7] as ActivityCategory,
      priority: fields[8] as ActivityPriority,
      estimatedCost: fields[9] as String?,
      tips: fields[10] as String?,
      address: fields[11] as String?,
      photos: (fields[12] as List).cast<String>(),
      rating: fields[13] as double?,
      placeId: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.lat)
      ..writeByte(4)
      ..write(obj.lng)
      ..writeByte(5)
      ..write(obj.timeFrom)
      ..writeByte(6)
      ..write(obj.timeTo)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.priority)
      ..writeByte(9)
      ..write(obj.estimatedCost)
      ..writeByte(10)
      ..write(obj.tips)
      ..writeByte(11)
      ..write(obj.address)
      ..writeByte(12)
      ..write(obj.photos)
      ..writeByte(13)
      ..write(obj.rating)
      ..writeByte(14)
      ..write(obj.placeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityImpl _$$ActivityImplFromJson(Map<String, dynamic> json) =>
    _$ActivityImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      timeFrom: json['timeFrom'] as String,
      timeTo: json['timeTo'] as String,
      category: $enumDecode(_$ActivityCategoryEnumMap, json['category']),
      priority: $enumDecode(_$ActivityPriorityEnumMap, json['priority']),
      estimatedCost: json['estimatedCost'] as String?,
      tips: json['tips'] as String?,
      address: json['address'] as String?,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rating: (json['rating'] as num?)?.toDouble(),
      placeId: json['placeId'] as String?,
    );

Map<String, dynamic> _$$ActivityImplToJson(_$ActivityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'lat': instance.lat,
      'lng': instance.lng,
      'timeFrom': instance.timeFrom,
      'timeTo': instance.timeTo,
      'category': _$ActivityCategoryEnumMap[instance.category]!,
      'priority': _$ActivityPriorityEnumMap[instance.priority]!,
      'estimatedCost': instance.estimatedCost,
      'tips': instance.tips,
      'address': instance.address,
      'photos': instance.photos,
      'rating': instance.rating,
      'placeId': instance.placeId,
    };

const _$ActivityCategoryEnumMap = {
  ActivityCategory.food: 'food',
  ActivityCategory.sightseeing: 'sightseeing',
  ActivityCategory.culture: 'culture',
  ActivityCategory.nature: 'nature',
  ActivityCategory.shopping: 'shopping',
};

const _$ActivityPriorityEnumMap = {
  ActivityPriority.high: 'high',
  ActivityPriority.medium: 'medium',
  ActivityPriority.low: 'low',
};
