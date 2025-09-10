import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'api_client.dart';

/// 快取條目，包含資料和時間戳
class _CacheEntry<T> {
  final T data;
  final DateTime timestamp;
  
  _CacheEntry(this.data, this.timestamp);
  
  bool isExpired(Duration expiry) {
    return DateTime.now().difference(timestamp) > expiry;
  }
}

/// 地點資料補強服務
/// 
/// 負責處理 Google Places API 的整合，包含：
/// 1. 地點搜尋和詳細資訊獲取
/// 2. 地理座標驗證和補齊
/// 3. 地點照片和評分資料處理
/// 4. API 限制和錯誤處理
class PlacesService {
  final ApiClient _apiClient;
  
  // 快取機制
  final Map<String, _CacheEntry<Place>> _placeCache = {};
  final Map<String, _CacheEntry<List<Place>>> _searchCache = {};
  
  // API 限制設定
  static const int _maxSearchResults = 20;
  static const int _maxPhotosPerPlace = 3;
  static const Duration _cacheExpiry = Duration(hours: 6);
  
  // 重試機制設定
  static const int _maxRetries = 3;
  static const Duration _baseRetryDelay = Duration(seconds: 1);
  final Map<String, DateTime> _rateLimitResetTimes = {};
  
  PlacesService(this._apiClient);

  /// 搜尋地點
  /// 
  /// [query] 搜尋關鍵字
  /// [location] 搜尋中心點座標 (lat,lng)
  /// [radius] 搜尋半徑（公尺）
  /// [types] 地點類型過濾
  Future<List<Place>> searchPlaces(
    String query, {
    String? location,
    int? radius,
    List<String>? types,
    int maxResults = 10,
  }) async {
    return await _executeWithRetry(() async {
      // 檢查快取
      final cacheKey = _generateSearchCacheKey(query, location, radius, types);
      if (_searchCache.containsKey(cacheKey)) {
        final cacheEntry = _searchCache[cacheKey]!;
        if (!cacheEntry.isExpired(_cacheExpiry)) {
          return cacheEntry.data.take(maxResults).toList();
        } else {
          _searchCache.remove(cacheKey);
        }
      }

      // 呼叫 API
      final places = await _apiClient.searchPlaces(
        query,
        location: location,
        radius: radius,
      );

      // 過濾類型
      List<Place> filteredPlaces = places;
      if (types != null && types.isNotEmpty) {
        filteredPlaces = places.where((place) {
          return place.types?.any((type) => types.contains(type)) ?? false;
        }).toList();
      }

      // 限制結果數量
      final limitedResults = filteredPlaces.take(_maxSearchResults).toList();

      // 快取結果
      _searchCache[cacheKey] = _CacheEntry(limitedResults, DateTime.now());

      return limitedResults.take(maxResults).toList();
    }, 'searchPlaces');
  }

  /// 取得地點詳細資訊
  /// 
  /// [placeId] Google Places ID
  Future<Place?> getPlaceDetails(String placeId) async {
    return await _executeWithRetry(() async {
      // 檢查快取
      if (_placeCache.containsKey(placeId)) {
        final cacheEntry = _placeCache[placeId]!;
        if (!cacheEntry.isExpired(_cacheExpiry)) {
          return cacheEntry.data;
        } else {
          _placeCache.remove(placeId);
        }
      }

      // 呼叫 API 取得詳細資訊
      final place = await _apiClient.getPlaceDetails(placeId);
      
      if (place != null) {
        // 快取結果
        _placeCache[placeId] = _CacheEntry(place, DateTime.now());
        return place;
      }

      return null;
    }, 'getPlaceDetails');
  }

  /// 驗證和補齊地理座標
  /// 
  /// [placeName] 地點名稱
  /// [currentLocation] 目前座標 (用於驗證)
  Future<PlaceLocation?> validateAndEnhanceLocation(
    String placeName, {
    PlaceLocation? currentLocation,
  }) async {
    try {
      // 如果有目前座標，先驗證
      if (currentLocation != null) {
        if (_isValidCoordinate(currentLocation.lat, currentLocation.lng)) {
          return currentLocation;
        }
      }

      // 搜尋地點取得座標
      final places = await searchPlaces(placeName, maxResults: 1);

      if (places.isNotEmpty) {
        return places.first.location;
      }

      return null;
    } catch (e) {
      print('⚠️ 座標驗證失敗: $e');
      return null;
    }
  }

  /// 驗證和補齊地理座標 (舊版本相容)
  /// 
  /// [placeName] 地點名稱
  /// [address] 地址（可選）
  /// [existingLat] 現有緯度
  /// [existingLng] 現有經度
  Future<PlaceLocation?> validateAndEnhanceCoordinates(
    String placeName, {
    String? address,
    double? existingLat,
    double? existingLng,
  }) async {
    try {
      // 如果已有有效座標，先驗證
      if (existingLat != null && existingLng != null) {
        if (_isValidCoordinate(existingLat, existingLng)) {
          return PlaceLocation(lat: existingLat, lng: existingLng);
        }
      }

      // 搜尋地點取得座標
      final searchQuery = address != null ? '$placeName $address' : placeName;
      final places = await searchPlaces(searchQuery, maxResults: 1);

      if (places.isNotEmpty) {
        return places.first.location;
      }

      return null;
    } catch (e) {
      print('⚠️ 座標驗證失敗: $e');
      return null;
    }
  }

  /// 補強活動的地點資訊
  /// 
  /// [activity] 要補強的活動
  /// [destinationName] 目的地名稱（用於搜尋上下文）
  Future<Activity> enhanceActivityWithPlaceData(
    Activity activity,
    String destinationName,
  ) async {
    try {
      // 如果已有完整資訊，直接返回
      if (_hasCompleteLocationData(activity)) {
        return activity;
      }

      // 搜尋地點資訊
      final searchQuery = '${activity.name} $destinationName';
      final places = await searchPlaces(searchQuery, maxResults: 1);

      if (places.isEmpty) {
        return activity;
      }

      final place = places.first;
      
      // 補強活動資訊
      return activity.copyWith(
        lat: place.location.lat,
        lng: place.location.lng,
        address: activity.address ?? place.address,
        rating: activity.rating ?? place.rating,
        placeId: activity.placeId ?? place.id,
        photos: activity.photos.isEmpty && place.photos != null
            ? place.photos!.take(_maxPhotosPerPlace)
                .map((photo) => _buildPhotoUrl(photo.reference))
                .toList()
            : activity.photos,
      );
    } catch (e) {
      print('⚠️ 補強活動地點資訊失敗: ${activity.name} - $e');
      return activity;
    }
  }

  /// 批量增強活動地點資訊
  /// [activities] 活動列表
  /// [destination] 目的地 (用於搜尋上下文)
  Future<List<Activity>> enhanceActivitiesWithPlaceData(
    List<Activity> activities,
    String destination,
  ) async {
    final enhancedActivities = <Activity>[];
    
    for (final activity in activities) {
      try {
        // 如果活動已經有完整的地點資訊，跳過
        if (_hasCompleteLocationData(activity)) {
          enhancedActivities.add(activity);
          continue;
        }

        // 搜尋地點資訊
        final searchQuery = '${activity.name} $destination';
        final places = await searchPlaces(
          searchQuery,
          radius: 50000, // 50km 搜尋範圍
        );

        if (places.isNotEmpty) {
          final place = places.first;
          
          // 增強活動資訊
          final enhancedActivity = activity.copyWith(
            placeId: place.id,
            lat: place.location.lat,
            lng: place.location.lng,
            rating: place.rating,
            address: place.address,
          );
          
          enhancedActivities.add(enhancedActivity);
          print('✅ Enhanced activity: ${activity.name}');
        } else {
          // 嘗試座標驗證
          final location = await validateAndEnhanceLocation(activity.name);
          if (location != null) {
            final enhancedActivity = activity.copyWith(
              lat: location.lat,
              lng: location.lng,
            );
            enhancedActivities.add(enhancedActivity);
            print('✅ Validated location for: ${activity.name}');
          } else {
            // 保持原始活動
            enhancedActivities.add(activity);
            print('⚠️ Could not enhance: ${activity.name}');
          }
        }
      } catch (e) {
        print('❌ Error enhancing activity ${activity.name}: ${e.toString()}');
        // 保持原始活動
        enhancedActivities.add(activity);
      }
    }
    
    return enhancedActivities;
  }

  /// 批量補強行程中的地點資訊
  /// 
  /// [trip] 要補強的行程
  Future<Trip> enhanceTripWithPlaceData(Trip trip) async {
    try {
      final enhancedDays = <DayPlan>[];

      for (final day in trip.days) {
        final enhancedActivities = <Activity>[];

        for (final activity in day.activities) {
          final enhancedActivity = await enhanceActivityWithPlaceData(
            activity,
            trip.destination.name,
          );
          enhancedActivities.add(enhancedActivity);
        }

        enhancedDays.add(day.copyWith(activities: enhancedActivities));
      }

      return trip.copyWith(days: enhancedDays);
    } catch (e) {
      print('⚠️ 補強行程地點資訊失敗: $e');
      return trip;
    }
  }

  /// 取得附近的地點
  /// 
  /// [lat] 緯度
  /// [lng] 經度
  /// [radius] 搜尋半徑（公尺）
  /// [types] 地點類型
  Future<List<Place>> getNearbyPlaces(
    double lat,
    double lng, {
    int radius = 1000,
    List<String>? types,
    int maxResults = 10,
  }) async {
    try {
      final location = '$lat,$lng';
      return await searchPlaces(
        '', // 空查詢，只搜尋附近
        location: location,
        radius: radius,
        types: types,
        maxResults: maxResults,
      );
    } catch (e) {
      throw PlacesException('附近地點搜尋失敗: $e');
    }
  }

  /// 驗證座標是否有效
  bool _isValidCoordinate(double lat, double lng) {
    return lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180 &&
           !(lat == 0.0 && lng == 0.0);
  }

  /// 檢查活動是否有完整的地點資料
  bool _hasCompleteLocationData(Activity activity) {
    return _isValidCoordinate(activity.lat, activity.lng) &&
           activity.address != null &&
           activity.placeId != null;
  }

  /// 生成搜尋快取鍵
  String _generateSearchCacheKey(
    String query,
    String? location,
    int? radius,
    List<String>? types,
  ) {
    return '$query|$location|$radius|${types?.join(',')}';
  }

  /// 建立照片 URL
  String _buildPhotoUrl(String photoReference) {
    return _apiClient.getPlacePhotoUrl(photoReference, maxWidth: 400);
  }

  /// 執行帶重試機制的 API 請求
  /// [operation] 要執行的操作
  /// [operationName] 操作名稱 (用於日誌)
  Future<T> _executeWithRetry<T>(
    Future<T> Function() operation,
    String operationName,
  ) async {
    // 檢查是否在速率限制期間
    if (_isRateLimited(operationName)) {
      throw PlacesQuotaExceededException(
        'API 仍在速率限制期間，請稍後再試',
        retryAfterSeconds: 60,
      );
    }
    
    int retryCount = 0;
    
    while (retryCount <= _maxRetries) {
      try {
        return await operation();
      } catch (e) {
        // 檢查是否為配額超限錯誤
        if (e.toString().contains('OVER_QUERY_LIMIT') || 
            e.toString().contains('quota') ||
            e.toString().contains('rate limit')) {
          
          // 設置速率限制
          _setRateLimitReset(operationName, 300); // 5分鐘
          
          if (retryCount == _maxRetries) {
            throw PlacesQuotaExceededException(
              'Places API 配額超限，請稍後再試',
              retryAfterSeconds: _calculateRetryDelay(retryCount).inSeconds,
            );
          }
          
          final delay = _calculateRetryDelay(retryCount);
          print('⏳ $operationName 配額超限，${delay.inSeconds}秒後重試 (${retryCount + 1}/$_maxRetries)');
          await Future.delayed(delay);
          
        } else if (e.toString().contains('INVALID_REQUEST')) {
          throw PlacesInvalidRequestException(
            'Places API 請求無效: ${e.toString()}',
          );
        } else if (e.toString().contains('NOT_FOUND')) {
          throw PlaceNotFoundException(
            '地點未找到: ${e.toString()}',
            'unknown',
          );
        } else {
          // 其他錯誤，如果還有重試次數就重試
          if (retryCount == _maxRetries) {
            throw PlacesException('$operationName 失敗: ${e.toString()}');
          }
          
          final delay = _calculateRetryDelay(retryCount);
          print('⚠️ $operationName 失敗，${delay.inSeconds}秒後重試: ${e.toString()}');
          await Future.delayed(delay);
        }
        
        retryCount++;
      }
    }
    
    throw PlacesException('$operationName 重試次數已用盡');
  }

  /// 計算重試延遲時間 (指數退避)
  Duration _calculateRetryDelay(int retryCount) {
    final multiplier = math.pow(2, retryCount).toInt();
    return Duration(
      milliseconds: _baseRetryDelay.inMilliseconds * multiplier,
    );
  }

  /// 檢查是否在速率限制期間
  bool _isRateLimited(String endpoint) {
    final resetTime = _rateLimitResetTimes[endpoint];
    if (resetTime == null) return false;
    
    return DateTime.now().isBefore(resetTime);
  }

  /// 設置速率限制重置時間
  void _setRateLimitReset(String endpoint, int retryAfterSeconds) {
    _rateLimitResetTimes[endpoint] = DateTime.now().add(
      Duration(seconds: retryAfterSeconds),
    );
  }

  /// 清除快取
  void clearCache() {
    _placeCache.clear();
    _searchCache.clear();
  }

  /// 取得快取統計
  Map<String, int> getCacheStats() {
    // 清理過期的快取條目
    _cleanExpiredCache();
    
    return {
      'placeCache': _placeCache.length,
      'searchCache': _searchCache.length,
    };
  }
  
  /// 清理過期的快取條目
  void _cleanExpiredCache() {
    // 清理地點快取
    _placeCache.removeWhere((key, entry) => entry.isExpired(_cacheExpiry));
    
    // 清理搜尋快取
    _searchCache.removeWhere((key, entry) => entry.isExpired(_cacheExpiry));
  }
}

/// Places API 異常
class PlacesException implements Exception {
  final String message;
  
  const PlacesException(this.message);
  
  @override
  String toString() => 'PlacesException: $message';
}

/// Places API 配額超限異常
class PlacesQuotaExceededException extends PlacesException {
  final int? retryAfterSeconds;
  
  const PlacesQuotaExceededException(
    String message, {
    this.retryAfterSeconds,
  }) : super(message);
  
  @override
  String toString() => 'PlacesQuotaExceededException: $message${retryAfterSeconds != null ? ' (retry after ${retryAfterSeconds}s)' : ''}';
}

/// Places API 無效請求異常
class PlacesInvalidRequestException extends PlacesException {
  final String? invalidField;
  
  const PlacesInvalidRequestException(
    String message, {
    this.invalidField,
  }) : super(message);
  
  @override
  String toString() => 'PlacesInvalidRequestException: $message${invalidField != null ? ' (field: $invalidField)' : ''}';
}

/// Places API 地點未找到異常
class PlaceNotFoundException extends PlacesException {
  final String placeId;
  
  const PlaceNotFoundException(
    String message,
    this.placeId,
  ) : super(message);
  
  @override
  String toString() => 'PlaceNotFoundException: $message (placeId: $placeId)';
}

/// Riverpod Provider
final placesServiceProvider = Provider<PlacesService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return PlacesService(apiClient);
});