// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preference_analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserPreferenceAnalysisImpl _$$UserPreferenceAnalysisImplFromJson(
        Map<String, dynamic> json) =>
    _$UserPreferenceAnalysisImpl(
      primaryFocus: json['primaryFocus'] as String,
      travelPace: $enumDecode(_$TravelPaceEnumMap, json['travelPace']),
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      avoidances: (json['avoidances'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      mood: json['mood'] as String,
      keywords: (json['keywords'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      analyzedAt: json['analyzedAt'] == null
          ? null
          : DateTime.parse(json['analyzedAt'] as String),
    );

Map<String, dynamic> _$$UserPreferenceAnalysisImplToJson(
        _$UserPreferenceAnalysisImpl instance) =>
    <String, dynamic>{
      'primaryFocus': instance.primaryFocus,
      'travelPace': _$TravelPaceEnumMap[instance.travelPace]!,
      'interests': instance.interests,
      'avoidances': instance.avoidances,
      'mood': instance.mood,
      'keywords': instance.keywords,
      'confidence': instance.confidence,
      'analyzedAt': instance.analyzedAt?.toIso8601String(),
    };

const _$TravelPaceEnumMap = {
  TravelPace.slow: 'slow',
  TravelPace.medium: 'medium',
  TravelPace.fast: 'fast',
};
