// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripRequestImpl _$$TripRequestImplFromJson(Map<String, dynamic> json) =>
    _$TripRequestImpl(
      destination: json['destination'] as String,
      days: (json['days'] as num).toInt(),
      description: json['description'] as String,
      preferences: json['preferences'] == null
          ? null
          : TripPreferences.fromJson(
              json['preferences'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TripRequestImplToJson(_$TripRequestImpl instance) =>
    <String, dynamic>{
      'destination': instance.destination,
      'days': instance.days,
      'description': instance.description,
      'preferences': instance.preferences,
    };

_$TripPreferencesImpl _$$TripPreferencesImplFromJson(
        Map<String, dynamic> json) =>
    _$TripPreferencesImpl(
      budget: json['budget'] as String? ?? 'medium',
      pace: json['pace'] as String? ?? 'medium',
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      companions: (json['companions'] as num?)?.toInt() ?? 2,
    );

Map<String, dynamic> _$$TripPreferencesImplToJson(
        _$TripPreferencesImpl instance) =>
    <String, dynamic>{
      'budget': instance.budget,
      'pace': instance.pace,
      'interests': instance.interests,
      'companions': instance.companions,
    };

_$PreferenceAnalysisImpl _$$PreferenceAnalysisImplFromJson(
        Map<String, dynamic> json) =>
    _$PreferenceAnalysisImpl(
      primaryFocus: json['primaryFocus'] as String,
      travelPace: json['travelPace'] as String,
      interests:
          (json['interests'] as List<dynamic>).map((e) => e as String).toList(),
      avoidances: (json['avoidances'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      mood: json['mood'] as String,
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$PreferenceAnalysisImplToJson(
        _$PreferenceAnalysisImpl instance) =>
    <String, dynamic>{
      'primaryFocus': instance.primaryFocus,
      'travelPace': instance.travelPace,
      'interests': instance.interests,
      'avoidances': instance.avoidances,
      'mood': instance.mood,
      'keywords': instance.keywords,
    };

_$PlaceImpl _$$PlaceImplFromJson(Map<String, dynamic> json) => _$PlaceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      location:
          PlaceLocation.fromJson(json['location'] as Map<String, dynamic>),
      rating: (json['rating'] as num?)?.toDouble(),
      priceLevel: (json['priceLevel'] as num?)?.toInt(),
      types:
          (json['types'] as List<dynamic>?)?.map((e) => e as String).toList(),
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => PlacePhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
      openingHours: json['openingHours'] == null
          ? null
          : PlaceOpeningHours.fromJson(
              json['openingHours'] as Map<String, dynamic>),
      website: json['website'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );

Map<String, dynamic> _$$PlaceImplToJson(_$PlaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'location': instance.location,
      'rating': instance.rating,
      'priceLevel': instance.priceLevel,
      'types': instance.types,
      'photos': instance.photos,
      'openingHours': instance.openingHours,
      'website': instance.website,
      'phoneNumber': instance.phoneNumber,
    };

_$PlaceOpeningHoursImpl _$$PlaceOpeningHoursImplFromJson(
        Map<String, dynamic> json) =>
    _$PlaceOpeningHoursImpl(
      openNow: json['openNow'] as bool,
      weekdayText: (json['weekdayText'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$PlaceOpeningHoursImplToJson(
        _$PlaceOpeningHoursImpl instance) =>
    <String, dynamic>{
      'openNow': instance.openNow,
      'weekdayText': instance.weekdayText,
    };

_$PlaceLocationImpl _$$PlaceLocationImplFromJson(Map<String, dynamic> json) =>
    _$PlaceLocationImpl(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$$PlaceLocationImplToJson(_$PlaceLocationImpl instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

_$PlacePhotoImpl _$$PlacePhotoImplFromJson(Map<String, dynamic> json) =>
    _$PlacePhotoImpl(
      reference: json['reference'] as String,
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
    );

Map<String, dynamic> _$$PlacePhotoImplToJson(_$PlacePhotoImpl instance) =>
    <String, dynamic>{
      'reference': instance.reference,
      'width': instance.width,
      'height': instance.height,
    };

_$MapConfigImpl _$$MapConfigImplFromJson(Map<String, dynamic> json) =>
    _$MapConfigImpl(
      accessToken: json['accessToken'] as String,
      style: json['style'] as String,
      maxZoom: (json['maxZoom'] as num).toDouble(),
      minZoom: (json['minZoom'] as num).toDouble(),
      defaultCenter: (json['defaultCenter'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      defaultZoom: (json['defaultZoom'] as num).toDouble(),
    );

Map<String, dynamic> _$$MapConfigImplToJson(_$MapConfigImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'style': instance.style,
      'maxZoom': instance.maxZoom,
      'minZoom': instance.minZoom,
      'defaultCenter': instance.defaultCenter,
      'defaultZoom': instance.defaultZoom,
    };

_$ApiResponseImpl _$$ApiResponseImplFromJson(Map<String, dynamic> json) =>
    _$ApiResponseImpl(
      success: json['success'] as bool,
      data: json['data'] as Map<String, dynamic>?,
      error: json['error'] as String?,
      message: json['message'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$ApiResponseImplToJson(_$ApiResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'error': instance.error,
      'message': instance.message,
      'note': instance.note,
    };

_$HealthResponseImpl _$$HealthResponseImplFromJson(Map<String, dynamic> json) =>
    _$HealthResponseImpl(
      status: json['status'] as String,
      timestamp: json['timestamp'] as String,
      version: json['version'] as String,
      service: json['service'] as String?,
    );

Map<String, dynamic> _$$HealthResponseImplToJson(
        _$HealthResponseImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'timestamp': instance.timestamp,
      'version': instance.version,
      'service': instance.service,
    };
