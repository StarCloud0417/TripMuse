import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto/crypto.dart';
import '../models/models.dart';
import 'api_client.dart';
import 'places_service.dart';

/// 行程生成階段
enum TripGenerationPhase {
  idle('待機中'),
  analyzingPreferences('分析旅行偏好'),
  generatingItinerary('生成行程規劃'),
  enhancingPlaces('補強地點資訊'),
  validating('驗證行程資料'),
  completed('完成');

  const TripGenerationPhase(this.displayName);
  final String displayName;
}

/// 行程生成進度
class TripGenerationProgress {
  final TripGenerationPhase phase;
  final double progress; // 0.0 - 1.0
  final String? message;
  final Trip? trip;
  final String? error;

  const TripGenerationProgress({
    required this.phase,
    required this.progress,
    this.message,
    this.trip,
    this.error,
  });

  TripGenerationProgress copyWith({
    TripGenerationPhase? phase,
    double? progress,
    String? message,
    Trip? trip,
    String? error,
  }) {
    return TripGenerationProgress(
      phase: phase ?? this.phase,
      progress: progress ?? this.progress,
      message: message ?? this.message,
      trip: trip ?? this.trip,
      error: error ?? this.error,
    );
  }

  bool get isLoading => phase != TripGenerationPhase.idle && 
                       phase != TripGenerationPhase.completed && 
                       error == null;
  
  bool get isCompleted => phase == TripGenerationPhase.completed && trip != null;
  
  bool get hasError => error != null;
}

/// 快取項目
class CacheItem<T> {
  final T data;
  final DateTime createdAt;
  final Duration ttl;

  CacheItem({
    required this.data,
    required this.createdAt,
    required this.ttl,
  });

  bool get isExpired => DateTime.now().isAfter(createdAt.add(ttl));
}

/// 行程生成服務
/// 
/// 負責處理完整的行程生成流程，包含：
/// 1. 使用者偏好分析
/// 2. 行程生成
/// 3. 地點資訊補強
/// 4. 快取管理
/// 5. 錯誤處理和重試機制
class TripGenerationService {
  final ApiClient _apiClient;
  final PlacesService _placesService;
  final Map<String, CacheItem<Trip>> _tripCache = {};
  final Map<String, CacheItem<UserPreferenceAnalysis>> _preferenceCache = {};
  
  // 快取設定
  static const Duration _tripCacheTTL = Duration(hours: 24);
  static const Duration _preferenceCacheTTL = Duration(hours: 6);
  static const int _maxCacheSize = 50;

  TripGenerationService(this._apiClient, this._placesService);

  /// 生成完整行程（兩階段處理）
  /// 
  /// 第一階段：分析使用者偏好
  /// 第二階段：基於偏好生成詳細行程
  Future<Trip> generateTrip(
    TripRequest request, {
    Function(TripGenerationProgress)? onProgress,
    bool useCache = true,
  }) async {
    // 檢查快取
    if (useCache) {
      final cachedTrip = _getCachedTrip(request);
      if (cachedTrip != null) {
        onProgress?.call(TripGenerationProgress(
          phase: TripGenerationPhase.completed,
          progress: 1.0,
          trip: cachedTrip,
          message: '從快取載入行程',
        ));
        return cachedTrip;
      }
    }

    try {
      // 階段 1: 分析使用者偏好
      onProgress?.call(const TripGenerationProgress(
        phase: TripGenerationPhase.analyzingPreferences,
        progress: 0.1,
        message: '正在分析您的旅行偏好...',
      ));

      final preferenceAnalysis = await _analyzeUserPreferences(request);

      // 階段 2: 生成行程
      onProgress?.call(const TripGenerationProgress(
        phase: TripGenerationPhase.generatingItinerary,
        progress: 0.4,
        message: '正在為您規劃精彩行程...',
      ));

      final enhancedRequest = _enhanceRequestWithPreferences(request, preferenceAnalysis);
      final rawTrip = await _apiClient.generateTrip(enhancedRequest);

      // 階段 3: 補強地點資訊
      onProgress?.call(const TripGenerationProgress(
        phase: TripGenerationPhase.enhancingPlaces,
        progress: 0.7,
        message: '正在補強地點詳細資訊...',
      ));

      final enhancedTrip = await _enhanceTripWithPlaceDetails(rawTrip);

      // 階段 4: 驗證和最終處理
      onProgress?.call(const TripGenerationProgress(
        phase: TripGenerationPhase.validating,
        progress: 0.9,
        message: '正在驗證行程資料...',
      ));

      final finalTrip = _validateAndEnhanceTrip(enhancedTrip, preferenceAnalysis);

      // 儲存到快取
      if (useCache) {
        _cacheTrip(request, finalTrip);
      }

      // 完成
      onProgress?.call(TripGenerationProgress(
        phase: TripGenerationPhase.completed,
        progress: 1.0,
        trip: finalTrip,
        message: '行程生成完成！',
      ));

      return finalTrip;

    } catch (e) {
      onProgress?.call(TripGenerationProgress(
        phase: TripGenerationPhase.idle,
        progress: 0.0,
        error: e.toString(),
      ));
      rethrow;
    }
  }

  /// 分析使用者偏好（第一階段）
  Future<UserPreferenceAnalysis> _analyzeUserPreferences(TripRequest request) async {
    // 檢查偏好快取
    final cacheKey = _generatePreferenceCacheKey(request);
    final cachedPreference = _preferenceCache[cacheKey];
    
    if (cachedPreference != null && !cachedPreference.isExpired) {
      return cachedPreference.data;
    }

    try {
      // 建立偏好分析請求
      final analysisRequest = {
        'destination': request.destination,
        'description': request.description,
        'preferences': request.preferences?.toJson() ?? {},
        'days': request.days,
      };

      // 呼叫 API 進行偏好分析（這裡可以是專門的偏好分析端點）
      // 目前先使用現有的生成端點，後續可以分離
      final response = await _apiClient.post('/api/v1/analyze-preferences', data: analysisRequest);
      
      UserPreferenceAnalysis analysis;
      if (response['success'] == true && response['analysis'] != null) {
        analysis = UserPreferenceAnalysis.fromJson(response['analysis']);
      } else {
        // 如果沒有專門的偏好分析端點，使用預設分析
        analysis = _generateDefaultPreferenceAnalysis(request);
      }

      // 快取偏好分析結果
      _preferenceCache[cacheKey] = CacheItem(
        data: analysis,
        createdAt: DateTime.now(),
        ttl: _preferenceCacheTTL,
      );

      return analysis;
    } catch (e) {
      // 如果偏好分析失敗，使用預設分析
      return _generateDefaultPreferenceAnalysis(request);
    }
  }

  /// 生成預設偏好分析
  UserPreferenceAnalysis _generateDefaultPreferenceAnalysis(TripRequest request) {
    final description = request.description.toLowerCase();

    // 基於描述關鍵字分析興趣
    final interests = <String>[];
    if (description.contains('美食') || description.contains('食物') || description.contains('餐廳')) {
      interests.add('美食');
    }
    if (description.contains('文化') || description.contains('歷史') || description.contains('博物館')) {
      interests.add('文化');
    }
    if (description.contains('自然') || description.contains('風景') || description.contains('山')) {
      interests.add('自然');
    }
    if (description.contains('購物') || description.contains('商店')) {
      interests.add('購物');
    }
    if (description.contains('夜生活') || description.contains('酒吧')) {
      interests.add('夜生活');
    }

    // 分析旅行節奏
    TravelPace pace = TravelPace.medium;
    if (description.contains('悠閒') || description.contains('慢') || description.contains('放鬆')) {
      pace = TravelPace.slow;
    } else if (description.contains('快') || description.contains('緊湊') || description.contains('多')) {
      pace = TravelPace.fast;
    }

    // 分析主要焦點
    String primaryFocus = '綜合體驗';
    if (interests.contains('美食')) {
      primaryFocus = '美食探索';
    } else if (interests.contains('文化')) {
      primaryFocus = '文化體驗';
    } else if (interests.contains('自然')) {
      primaryFocus = '自然風光';
    }

    return UserPreferenceAnalysis(
      primaryFocus: primaryFocus,
      travelPace: pace,
      budgetRange: BudgetRange.mid, // 預設中等預算
      interests: interests.isNotEmpty ? interests : ['觀光', '美食'],
      avoidances: [],
      mood: '探索新奇',
      keywords: _extractKeywords(description),
      confidence: 0.7,
      analyzedAt: DateTime.now(),
    );
  }

  /// 從描述中提取關鍵字
  List<String> _extractKeywords(String description) {
    final keywords = <String>[];
    final commonKeywords = [
      '美食', '文化', '歷史', '自然', '風景', '購物', '夜生活',
      '悠閒', '放鬆', '探索', '體驗', '傳統', '現代', '當地',
    ];

    for (final keyword in commonKeywords) {
      if (description.contains(keyword)) {
        keywords.add(keyword);
      }
    }

    return keywords.take(5).toList();
  }

  /// 使用偏好分析增強請求
  TripRequest _enhanceRequestWithPreferences(
    TripRequest request, 
    UserPreferenceAnalysis analysis,
  ) {
    // 將偏好分析結果融入到請求描述中
    final enhancedDescription = '''
${request.description}

基於分析的旅行偏好：
- 主要焦點：${analysis.primaryFocus}
- 旅行節奏：${analysis.travelPace.displayName}
- 興趣領域：${analysis.interests.join('、')}
- 關鍵字：${analysis.keywords.join('、')}
''';

    return request.copyWith(description: enhancedDescription);
  }

  /// 補強行程的地點詳細資訊
  Future<Trip> _enhanceTripWithPlaceDetails(Trip trip) async {
    try {
      // 使用 PlacesService 進行批量補強
      return await _placesService.enhanceTripWithPlaceData(trip);
    } catch (e) {
      print('⚠️ 使用 PlacesService 補強失敗，使用備用方案: $e');
      
      // 備用方案：使用原有的簡單補強邏輯
      final enhancedDays = <DayPlan>[];

      for (final day in trip.days) {
        final enhancedActivities = <Activity>[];

        for (final activity in day.activities) {
          try {
            final enhancedActivity = await _placesService.enhanceActivityWithPlaceData(
              activity,
              trip.destination.name,
            );
            enhancedActivities.add(enhancedActivity);
          } catch (e) {
            // 如果補強失敗，使用原始活動
            enhancedActivities.add(activity);
          }
        }

        enhancedDays.add(day.copyWith(activities: enhancedActivities));
      }

      return trip.copyWith(days: enhancedDays);
    }
  }

  /// 驗證和增強行程
  Trip _validateAndEnhanceTrip(Trip trip, UserPreferenceAnalysis analysis) {
    // 添加偏好分析到行程
    final enhancedTrip = trip.copyWith(
      preferenceAnalysis: analysis,
      updatedAt: DateTime.now(),
    );

    // 驗證行程完整性
    _validateTripIntegrity(enhancedTrip);

    return enhancedTrip;
  }

  /// 驗證行程完整性
  void _validateTripIntegrity(Trip trip) {
    if (trip.days.isEmpty) {
      throw const ApiException('生成的行程沒有包含任何天數');
    }

    for (final day in trip.days) {
      if (day.activities.isEmpty) {
        throw ApiException('第 ${day.dayIndex} 天沒有包含任何活動');
      }

      for (final activity in day.activities) {
        if (activity.lat == 0 && activity.lng == 0) {
          print('⚠️ 警告: 活動 "${activity.name}" 沒有有效的座標');
        }
      }
    }
  }

  /// 生成快取鍵
  String _generateCacheKey(TripRequest request) {
    final key = '${request.destination}_${request.days}_${request.description}_${request.preferences?.toJson()}';
    return md5.convert(utf8.encode(key)).toString();
  }

  /// 生成偏好快取鍵
  String _generatePreferenceCacheKey(TripRequest request) {
    final key = '${request.destination}_${request.description}_${request.preferences?.toJson()}';
    return md5.convert(utf8.encode(key)).toString();
  }

  /// 從快取取得行程
  Trip? _getCachedTrip(TripRequest request) {
    final cacheKey = _generateCacheKey(request);
    final cachedItem = _tripCache[cacheKey];
    
    if (cachedItem != null && !cachedItem.isExpired) {
      return cachedItem.data;
    }
    
    // 移除過期的快取
    if (cachedItem != null) {
      _tripCache.remove(cacheKey);
    }
    
    return null;
  }

  /// 快取行程
  void _cacheTrip(TripRequest request, Trip trip) {
    final cacheKey = _generateCacheKey(request);
    
    // 如果快取已滿，移除最舊的項目
    if (_tripCache.length >= _maxCacheSize) {
      _cleanupCache();
    }
    
    _tripCache[cacheKey] = CacheItem(
      data: trip,
      createdAt: DateTime.now(),
      ttl: _tripCacheTTL,
    );
  }

  /// 清理過期快取
  void _cleanupCache() {
    _tripCache.removeWhere((key, item) => item.isExpired);
    _preferenceCache.removeWhere((key, item) => item.isExpired);
    
    // 如果還是太多，移除最舊的項目
    if (_tripCache.length >= _maxCacheSize) {
      final sortedEntries = _tripCache.entries.toList()
        ..sort((a, b) => a.value.createdAt.compareTo(b.value.createdAt));
      
      final toRemove = sortedEntries.take(_tripCache.length - _maxCacheSize + 1);
      for (final entry in toRemove) {
        _tripCache.remove(entry.key);
      }
    }
  }

  /// 清除所有快取
  void clearCache() {
    _tripCache.clear();
    _preferenceCache.clear();
  }

  /// 取得快取統計
  Map<String, dynamic> getCacheStats() {
    return {
      'tripCacheSize': _tripCache.length,
      'preferenceCacheSize': _preferenceCache.length,
      'maxCacheSize': _maxCacheSize,
    };
  }

  /// 預熱快取（預先載入常用目的地的偏好分析）
  Future<void> preloadCommonDestinations() async {
    final commonDestinations = ['台北', '台中', '高雄', '台南', '花蓮'];
    
    for (final destination in commonDestinations) {
      try {
        final request = TripRequest(
          destination: destination,
          days: 3,
          description: '想要體驗當地文化和美食',
        );
        
        await _analyzeUserPreferences(request);
      } catch (e) {
        // 忽略預載入錯誤
        print('預載入 $destination 偏好分析失敗: $e');
      }
    }
  }
}

/// Riverpod Provider
final tripGenerationServiceProvider = Provider<TripGenerationService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final placesService = ref.read(placesServiceProvider);
  return TripGenerationService(apiClient, placesService);
});

/// 行程生成進度 Provider
final tripGenerationProgressProvider = 
    StateNotifierProvider<TripGenerationProgressNotifier, TripGenerationProgress>((ref) {
  final service = ref.read(tripGenerationServiceProvider);
  return TripGenerationProgressNotifier(service);
});

/// 行程生成進度狀態管理器
class TripGenerationProgressNotifier extends StateNotifier<TripGenerationProgress> {
  final TripGenerationService _service;

  TripGenerationProgressNotifier(this._service)
      : super(const TripGenerationProgress(
          phase: TripGenerationPhase.idle,
          progress: 0.0,
        ));

  /// 開始生成行程
  Future<void> generateTrip(TripRequest request, {bool useCache = true}) async {
    try {
      await _service.generateTrip(
        request,
        useCache: useCache,
        onProgress: (progress) {
          state = progress;
        },
      );
    } catch (e, stackTrace) {
      print('❌ Trip generation error: $e');
      print('Stack trace: $stackTrace');
      
      state = state.copyWith(
        phase: TripGenerationPhase.idle,
        progress: 0.0,
        error: e.toString(),
      );
    }
  }

  /// 重置狀態
  void reset() {
    state = const TripGenerationProgress(
      phase: TripGenerationPhase.idle,
      progress: 0.0,
    );
  }

  /// 清除快取
  void clearCache() {
    _service.clearCache();
  }
}