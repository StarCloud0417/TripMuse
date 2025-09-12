// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripImpl _$$TripImplFromJson(Map<String, dynamic> json) => _$TripImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      destination:
          Destination.fromJson(json['destination'] as Map<String, dynamic>),
      days: (json['days'] as List<dynamic>?)
              ?.map((e) => DayPlan.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as String?,
      generatedBy: json['generatedBy'] as String?,
      status: $enumDecodeNullable(_$TripStatusEnumMap, json['status']) ??
          TripStatus.draft,
      notes: json['notes'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      sharingSettings: json['sharingSettings'] == null
          ? null
          : TripSharingSettings.fromJson(
              json['sharingSettings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TripImplToJson(_$TripImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'destination': instance.destination,
      'days': instance.days,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'userId': instance.userId,
      'generatedBy': instance.generatedBy,
      'status': _$TripStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'isFavorite': instance.isFavorite,
      'sharingSettings': instance.sharingSettings,
    };

const _$TripStatusEnumMap = {
  TripStatus.draft: 'draft',
  TripStatus.active: 'active',
  TripStatus.completed: 'completed',
  TripStatus.archived: 'archived',
};

_$TripSharingSettingsImpl _$$TripSharingSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$TripSharingSettingsImpl(
      isEnabled: json['isEnabled'] as bool? ?? false,
      shareToken: json['shareToken'] as String?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TripSharingSettingsImplToJson(
        _$TripSharingSettingsImpl instance) =>
    <String, dynamic>{
      'isEnabled': instance.isEnabled,
      'shareToken': instance.shareToken,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
