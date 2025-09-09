// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      isGuest: json['isGuest'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      googleId: json['googleId'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'isGuest': instance.isGuest,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'googleId': instance.googleId,
      'avatarUrl': instance.avatarUrl,
    };

_$UserPreferencesImpl _$$UserPreferencesImplFromJson(
        Map<String, dynamic> json) =>
    _$UserPreferencesImpl(
      language: json['language'] as String,
      theme: json['theme'] as String,
      defaultCurrency: json['defaultCurrency'] as String,
      defaultMapStyle: json['defaultMapStyle'] as String,
      enableNotifications: json['enableNotifications'] as bool,
      enableLocationTracking: json['enableLocationTracking'] as bool,
      enableOfflineMode: json['enableOfflineMode'] as bool,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserPreferencesImplToJson(
        _$UserPreferencesImpl instance) =>
    <String, dynamic>{
      'language': instance.language,
      'theme': instance.theme,
      'defaultCurrency': instance.defaultCurrency,
      'defaultMapStyle': instance.defaultMapStyle,
      'enableNotifications': instance.enableNotifications,
      'enableLocationTracking': instance.enableLocationTracking,
      'enableOfflineMode': instance.enableOfflineMode,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
