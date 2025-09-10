// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityImpl _$$ActivityImplFromJson(Map<String, dynamic> json) =>
    _$ActivityImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      timeFrom: json['timeFrom'] as String,
      timeTo: json['timeTo'] as String,
      category: $enumDecode(_$ActivityCategoryEnumMap, json['category']),
      priority: $enumDecode(_$ActivityPriorityEnumMap, json['priority']),
      estimatedCost: json['estimatedCost'] as String?,
      tips: json['tips'] as String?,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      placeId: json['placeId'] as String?,
      address: json['address'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      suggestedDurationMinutes:
          (json['suggestedDurationMinutes'] as num?)?.toInt(),
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
      'photos': instance.photos,
      'placeId': instance.placeId,
      'address': instance.address,
      'rating': instance.rating,
      'suggestedDurationMinutes': instance.suggestedDurationMinutes,
    };

const _$ActivityCategoryEnumMap = {
  ActivityCategory.food: 'food',
  ActivityCategory.sightseeing: 'sightseeing',
  ActivityCategory.culture: 'culture',
  ActivityCategory.nature: 'nature',
  ActivityCategory.shopping: 'shopping',
  ActivityCategory.outdoor: 'outdoor',
  ActivityCategory.transportation: 'transportation',
};

const _$ActivityPriorityEnumMap = {
  ActivityPriority.high: 'high',
  ActivityPriority.medium: 'medium',
  ActivityPriority.low: 'low',
};
