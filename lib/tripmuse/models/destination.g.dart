// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'destination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DestinationImpl _$$DestinationImplFromJson(Map<String, dynamic> json) =>
    _$DestinationImpl(
      name: json['name'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      placeId: json['placeId'] as String?,
      fullAddress: json['fullAddress'] as String?,
      timezone: json['timezone'] as String?,
      currencyCode: json['currencyCode'] as String?,
      languageCode: json['languageCode'] as String?,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DestinationImplToJson(_$DestinationImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'city': instance.city,
      'country': instance.country,
      'lat': instance.lat,
      'lng': instance.lng,
      'placeId': instance.placeId,
      'fullAddress': instance.fullAddress,
      'timezone': instance.timezone,
      'currencyCode': instance.currencyCode,
      'languageCode': instance.languageCode,
      'photos': instance.photos,
    };
