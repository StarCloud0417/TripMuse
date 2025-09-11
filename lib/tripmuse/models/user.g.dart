// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      googleId: json['googleId'] as String?,
      isGuest: json['isGuest'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'avatarUrl': instance.avatarUrl,
      'googleId': instance.googleId,
      'isGuest': instance.isGuest,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$UserPreferencesImpl _$$UserPreferencesImplFromJson(
        Map<String, dynamic> json) =>
    _$UserPreferencesImpl(
      language: json['language'] as String? ?? 'zh-TW',
      theme: json['theme'] as String? ?? 'system',
      defaultCurrency: json['defaultCurrency'] as String? ?? 'TWD',
      defaultMapStyle: json['defaultMapStyle'] as String? ?? 'standard',
      travelPace: json['travelPace'] as String? ?? 'moderate',
      budgetRange: json['budgetRange'] as String? ?? 'medium',
      travelStyle: json['travelStyle'] as String? ?? 'balanced',
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      enableLocationTracking: json['enableLocationTracking'] as bool? ?? true,
      enableOfflineMode: json['enableOfflineMode'] as bool? ?? true,
      autoSync: json['autoSync'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserPreferencesImplToJson(
        _$UserPreferencesImpl instance) =>
    <String, dynamic>{
      'language': instance.language,
      'theme': instance.theme,
      'defaultCurrency': instance.defaultCurrency,
      'defaultMapStyle': instance.defaultMapStyle,
      'travelPace': instance.travelPace,
      'budgetRange': instance.budgetRange,
      'travelStyle': instance.travelStyle,
      'enableNotifications': instance.enableNotifications,
      'enableLocationTracking': instance.enableLocationTracking,
      'enableOfflineMode': instance.enableOfflineMode,
      'autoSync': instance.autoSync,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
