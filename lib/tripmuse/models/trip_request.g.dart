// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripRequestImpl _$$TripRequestImplFromJson(Map<String, dynamic> json) =>
    _$TripRequestImpl(
      requestId: json['requestId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      userId: json['userId'] as String?,
      destination:
          Destination.fromJson(json['destination'] as Map<String, dynamic>),
      days: (json['days'] as num).toInt(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      travelDescription: json['travelDescription'] as String,
      budget: $enumDecodeNullable(_$BudgetRangeEnumMap, json['budget']),
      groupSize: (json['groupSize'] as num?)?.toInt() ?? 1,
      travelStyle:
          $enumDecodeNullable(_$TravelStyleEnumMap, json['travelStyle']),
      locale: json['locale'] as String? ?? 'zh-TW',
    );

Map<String, dynamic> _$$TripRequestImplToJson(_$TripRequestImpl instance) =>
    <String, dynamic>{
      'requestId': instance.requestId,
      'timestamp': instance.timestamp.toIso8601String(),
      'userId': instance.userId,
      'destination': instance.destination,
      'days': instance.days,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'travelDescription': instance.travelDescription,
      'budget': _$BudgetRangeEnumMap[instance.budget],
      'groupSize': instance.groupSize,
      'travelStyle': _$TravelStyleEnumMap[instance.travelStyle],
      'locale': instance.locale,
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
