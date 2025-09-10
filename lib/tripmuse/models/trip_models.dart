import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_models.freezed.dart';
part 'trip_models.g.dart';

// 行程請求模型
@freezed
class TripRequest with _$TripRequest {
  const factory TripRequest({
    required String destination,
    required int days,
    required String description,
    TripPreferences? preferences,
  }) = _TripRequest;

  factory TripRequest.fromJson(Map<String, dynamic> json) =>
      _$TripRequestFromJson(json);
}

// 旅行偏好設定
@freezed
class TripPreferences with _$TripPreferences {
  const factory TripPreferences({
    @Default('medium') String budget, // low, medium, high
    @Default('medium') String pace, // slow, medium, fast
    @Default([]) List<String> interests,
    @Default(2) int companions,
  }) = _TripPreferences;

  factory TripPreferences.fromJson(Map<String, dynamic> json) =>
      _$TripPreferencesFromJson(json);
}

// 偏好分析結果
@freezed
class PreferenceAnalysis with _$PreferenceAnalysis {
  const factory PreferenceAnalysis({
    required String primaryFocus,
    required String travelPace,
    required List<String> interests,
    required List<String> avoidances,
    required String mood,
    required List<String> keywords,
  }) = _PreferenceAnalysis;

  factory PreferenceAnalysis.fromJson(Map<String, dynamic> json) =>
      _$PreferenceAnalysisFromJson(json);
}

// 地點搜尋結果
@freezed
class Place with _$Place {
  const factory Place({
    required String id,
    required String name,
    required String address,
    required PlaceLocation location,
    double? rating,
    int? priceLevel,
    List<String>? types,
    List<PlacePhoto>? photos,
    PlaceOpeningHours? openingHours,
    String? website,
    String? phoneNumber,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}

// 地點營業時間
@freezed
class PlaceOpeningHours with _$PlaceOpeningHours {
  const factory PlaceOpeningHours({
    required bool openNow,
    List<String>? weekdayText,
  }) = _PlaceOpeningHours;

  factory PlaceOpeningHours.fromJson(Map<String, dynamic> json) =>
      _$PlaceOpeningHoursFromJson(json);
}

// 地點位置
@freezed
class PlaceLocation with _$PlaceLocation {
  const factory PlaceLocation({
    required double lat,
    required double lng,
  }) = _PlaceLocation;

  factory PlaceLocation.fromJson(Map<String, dynamic> json) =>
      _$PlaceLocationFromJson(json);
}

// 地點照片
@freezed
class PlacePhoto with _$PlacePhoto {
  const factory PlacePhoto({
    required String reference,
    required int width,
    required int height,
  }) = _PlacePhoto;

  factory PlacePhoto.fromJson(Map<String, dynamic> json) =>
      _$PlacePhotoFromJson(json);
}

// 地圖配置
@freezed
class MapConfig with _$MapConfig {
  const factory MapConfig({
    required String accessToken,
    required String style,
    required double maxZoom,
    required double minZoom,
    required List<double> defaultCenter,
    required double defaultZoom,
  }) = _MapConfig;

  factory MapConfig.fromJson(Map<String, dynamic> json) =>
      _$MapConfigFromJson(json);
}

// API 回應包裝器（簡化版本，不使用泛型）
@freezed
class ApiResponse with _$ApiResponse {
  const factory ApiResponse({
    required bool success,
    Map<String, dynamic>? data,
    String? error,
    String? message,
    String? note,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
}

// 泛型 API 回應包裝器（用於服務介面）
class ApiResponseWrapper<T> {
  const ApiResponseWrapper({
    required this.success,
    this.data,
    this.error,
    this.message,
    this.note,
  });

  final bool success;
  final T? data;
  final String? error;
  final String? message;
  final String? note;

  factory ApiResponseWrapper.success(T data, {String? message}) {
    return ApiResponseWrapper(
      success: true,
      data: data,
      message: message,
    );
  }

  factory ApiResponseWrapper.error(String error, {String? message}) {
    return ApiResponseWrapper(
      success: false,
      error: error,
      message: message,
    );
  }
}

// 健康檢查回應
@freezed
class HealthResponse with _$HealthResponse {
  const factory HealthResponse({
    required String status,
    required String timestamp,
    required String version,
    String? service,
  }) = _HealthResponse;

  factory HealthResponse.fromJson(Map<String, dynamic> json) =>
      _$HealthResponseFromJson(json);
}