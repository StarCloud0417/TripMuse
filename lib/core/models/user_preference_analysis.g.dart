// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preference_analysis.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPreferenceAnalysisAdapter
    extends TypeAdapter<UserPreferenceAnalysis> {
  @override
  final int typeId = 13;

  @override
  UserPreferenceAnalysis read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreferenceAnalysis(
      primaryFocus: fields[0] as String,
      travelPace: fields[1] as TravelPace,
      interests: (fields[2] as List).cast<String>(),
      avoidances: (fields[3] as List).cast<String>(),
      mood: fields[4] as String,
      keywords: (fields[5] as List).cast<String>(),
      detectedInterests: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserPreferenceAnalysis obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.primaryFocus)
      ..writeByte(1)
      ..write(obj.travelPace)
      ..writeByte(2)
      ..write(obj.interests)
      ..writeByte(3)
      ..write(obj.avoidances)
      ..writeByte(4)
      ..write(obj.mood)
      ..writeByte(5)
      ..write(obj.keywords)
      ..writeByte(6)
      ..write(obj.detectedInterests);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreferenceAnalysisAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BasicPreferencesAdapter extends TypeAdapter<BasicPreferences> {
  @override
  final int typeId = 14;

  @override
  BasicPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BasicPreferences(
      budget: fields[0] as BudgetRange,
      groupSize: fields[1] as int,
      travelStyle: fields[2] as TravelStyle,
    );
  }

  @override
  void write(BinaryWriter writer, BasicPreferences obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.budget)
      ..writeByte(1)
      ..write(obj.groupSize)
      ..writeByte(2)
      ..write(obj.travelStyle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BasicPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserPreferenceAnalysisImpl _$$UserPreferenceAnalysisImplFromJson(
        Map<String, dynamic> json) =>
    _$UserPreferenceAnalysisImpl(
      primaryFocus: json['primaryFocus'] as String,
      travelPace: $enumDecode(_$TravelPaceEnumMap, json['travelPace']),
      interests:
          (json['interests'] as List<dynamic>).map((e) => e as String).toList(),
      avoidances: (json['avoidances'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      mood: json['mood'] as String,
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
      detectedInterests: (json['detectedInterests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
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
      'detectedInterests': instance.detectedInterests,
    };

const _$TravelPaceEnumMap = {
  TravelPace.slow: 'slow',
  TravelPace.medium: 'medium',
  TravelPace.fast: 'fast',
};

_$BasicPreferencesImpl _$$BasicPreferencesImplFromJson(
        Map<String, dynamic> json) =>
    _$BasicPreferencesImpl(
      budget: $enumDecode(_$BudgetRangeEnumMap, json['budget']),
      groupSize: (json['groupSize'] as num).toInt(),
      travelStyle: $enumDecode(_$TravelStyleEnumMap, json['travelStyle']),
    );

Map<String, dynamic> _$$BasicPreferencesImplToJson(
        _$BasicPreferencesImpl instance) =>
    <String, dynamic>{
      'budget': _$BudgetRangeEnumMap[instance.budget]!,
      'groupSize': instance.groupSize,
      'travelStyle': _$TravelStyleEnumMap[instance.travelStyle]!,
    };

const _$BudgetRangeEnumMap = {
  BudgetRange.low: 'low',
  BudgetRange.mid: 'mid',
  BudgetRange.high: 'high',
};

const _$TravelStyleEnumMap = {
  TravelStyle.leisure: 'leisure',
  TravelStyle.adventure: 'adventure',
  TravelStyle.cultural: 'cultural',
  TravelStyle.business: 'business',
};
