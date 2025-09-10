import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'api_client.dart';

// 行程生成狀態
enum TripGenerationState {
  idle,
  loading,
  success,
  error,
}

// 行程生成結果
class TripGenerationResult {
  final TripGenerationState state;
  final Trip? trip;
  final String? error;
  final double? progress;

  const TripGenerationResult({
    required this.state,
    this.trip,
    this.error,
    this.progress,
  });

  TripGenerationResult copyWith({
    TripGenerationState? state,
    Trip? trip,
    String? error,
    double? progress,
  }) {
    return TripGenerationResult(
      state: state ?? this.state,
      trip: trip ?? this.trip,
      error: error ?? this.error,
      progress: progress ?? this.progress,
    );
  }
}

// 行程生成服務
class TripService {
  final ApiClient _apiClient;

  TripService(this._apiClient);

  // 生成行程
  Future<Trip> generateTrip(TripRequest request) async {
    try {
      // 驗證請求資料
      _validateTripRequest(request);
      
      // 呼叫 API 生成行程
      final trip = await _apiClient.generateTrip(request);
      
      // 驗證回應資料
      _validateTripResponse(trip);
      
      return trip;
    } catch (e) {
      rethrow;
    }
  }

  // 搜尋地點
  Future<List<Place>> searchPlaces(String query) async {
    if (query.trim().isEmpty) {
      throw const ApiException('搜尋關鍵字不能為空');
    }

    return await _apiClient.searchPlaces(query);
  }

  // 取得地圖配置
  Future<MapConfig> getMapConfig() async {
    return await _apiClient.getMapConfig();
  }

  // 測試 API 連線
  Future<bool> testApiConnection() async {
    try {
      await _apiClient.checkHealth();
      return true;
    } catch (e) {
      return false;
    }
  }

  // 驗證行程請求
  void _validateTripRequest(TripRequest request) {
    if (request.destination.trim().isEmpty) {
      throw const ApiException('目的地不能為空');
    }
    
    if (request.days < 1 || request.days > 30) {
      throw const ApiException('天數必須在 1-30 天之間');
    }
    
    if (request.description.trim().isEmpty) {
      throw const ApiException('旅行描述不能為空');
    }
    
    if (request.description.length < 10) {
      throw const ApiException('旅行描述至少需要 10 個字元');
    }
  }

  // 驗證行程回應
  void _validateTripResponse(Trip trip) {
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
}

// 行程生成狀態管理器
class TripGenerationNotifier extends StateNotifier<TripGenerationResult> {
  final TripService _tripService;

  TripGenerationNotifier(this._tripService)
      : super(const TripGenerationResult(state: TripGenerationState.idle));

  // 生成行程
  Future<void> generateTrip(TripRequest request) async {
    state = state.copyWith(
      state: TripGenerationState.loading,
      progress: 0.0,
      error: null,
    );

    try {
      // 模擬進度更新
      _updateProgress(0.1);
      
      // 呼叫服務生成行程
      final trip = await _tripService.generateTrip(request);
      
      _updateProgress(1.0);
      
      state = state.copyWith(
        state: TripGenerationState.success,
        trip: trip,
        progress: 1.0,
      );
    } catch (e) {
      state = state.copyWith(
        state: TripGenerationState.error,
        error: e.toString(),
        progress: 0.0,
      );
    }
  }

  // 重置狀態
  void reset() {
    state = const TripGenerationResult(state: TripGenerationState.idle);
  }

  // 更新進度
  void _updateProgress(double progress) {
    state = state.copyWith(progress: progress);
  }
}

// Riverpod Providers
final tripServiceProvider = Provider<TripService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return TripService(apiClient);
});

final tripGenerationProvider =
    StateNotifierProvider<TripGenerationNotifier, TripGenerationResult>((ref) {
  final tripService = ref.read(tripServiceProvider);
  return TripGenerationNotifier(tripService);
});

// 地點搜尋 Provider
final placeSearchProvider = FutureProvider.family<List<Place>, String>((ref, query) async {
  if (query.trim().isEmpty) return [];
  
  final tripService = ref.read(tripServiceProvider);
  return await tripService.searchPlaces(query);
});

// 地圖配置 Provider
final mapConfigProvider = FutureProvider<MapConfig>((ref) async {
  final tripService = ref.read(tripServiceProvider);
  return await tripService.getMapConfig();
});