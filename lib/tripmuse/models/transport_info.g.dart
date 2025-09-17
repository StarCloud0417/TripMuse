// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransportInfoImpl _$$TransportInfoImplFromJson(Map<String, dynamic> json) =>
    _$TransportInfoImpl(
      mode: $enumDecode(_$TransportModeEnumMap, json['mode']),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      distanceMeters: (json['distanceMeters'] as num?)?.toInt(),
      estimatedCost: json['estimatedCost'] as String?,
      routeDescription: json['routeDescription'] as String?,
    );

Map<String, dynamic> _$$TransportInfoImplToJson(_$TransportInfoImpl instance) =>
    <String, dynamic>{
      'mode': _$TransportModeEnumMap[instance.mode]!,
      'durationMinutes': instance.durationMinutes,
      'distanceMeters': instance.distanceMeters,
      'estimatedCost': instance.estimatedCost,
      'routeDescription': instance.routeDescription,
    };

const _$TransportModeEnumMap = {
  TransportMode.walking: 'walking',
  TransportMode.driving: 'driving',
  TransportMode.transit: 'transit',
  TransportMode.cycling: 'cycling',
  TransportMode.taxi: 'taxi',
  TransportMode.metro: 'metro',
};
