/// TripMuse 行程生成狀態管理
/// 
/// 提供完整的行程生成狀態管理，包含取消、超時、重試機制

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';

/// 行程生成狀態
enum TripGenerationState {
  idle,
  loading,
  success,
  error,
  cancelled,
  timeout,
}

/// 行程生成結果
class TripGenerationResult {
  final TripGenerationState state;
  final Trip? trip;
  final String? error;
  final double progress;
  final String? currentPhase;
  final bool canRetry;
  final bool canCancel;
  final int retryCount;
  final DateTime? startTime;
  final Duration? elapsedTime;

  const TripGenerationResult({
    required this.state,
    this.trip,
    this.error,
    this.progress = 0.0,
    this.currentPhase,
    this.canRetry = false,
    this.canCancel = false,
    this.retryCount = 0,
    this.startTime,
    this.elapsedTime,
  });

  TripGenerationResult copyWith({
    TripGenerationState? state,
    Trip? trip,
    String? error,
    double? progress,
    String? currentPhase,
    bool? canRetry,
    bool? canCancel,
    int? retryCount,
    DateTime? startTime,
    Duration? elapsedTime,
  }) {
    return TripGenerationResult(
      state: state ?? this.state,
      trip: trip ?? this.trip,
      error: error ?? this.error,
      progress: progress ?? this.progress,
      currentPhase: currentPhase ?? this.currentPhase,
      canRetry: canRetry ?? this.canRetry,
      canCancel: canCancel ?? this.canCancel,
      retryCount: retryCount ?? this.retryCount,
      startTime: startTime ?? this.startTime,
      elapsedTime: elapsedTime ?? this.elapsedTime,
    );
  }

  bool get isLoading => state == TripGenerationState.loading;
  bool get isSuccess => state == TripGenerationState.success;
  bool get isError => state == TripGenerationState.error;
  bool get isCancelled => state == TripGenerationState.cancelled;
  bool get isTimeout => state == TripGenerationState.timeout;
  bool get isIdle => state == TripGenerationState.idle;
}

/// 行程生成控制器
class TripGenerationController extends StateNotifier<TripGenerationResult> {
  final TripGenerationService _generationService;
  final TripRepositoryImpl _tripRepository;
  
  // 控制相關
  Timer? _timeoutTimer;
  Timer? _progressTimer;
  Completer<void>? _cancellationCompleter;
  bool _isCancellationRequested = false;
  
  // 配置
  static const Duration _defaultTimeout = Duration(minutes: 5);
  static const Duration _progressUpdateInterval = Duration(milliseconds: 500);
  static const int _maxRetries = 3;

  TripGenerationController(
    this._generationService,
    this._tripRepository,
  ) : super(const TripGenerationResult(state: TripGenerationState.idle));

  /// 開始生成行程
  Future<Trip?> generateTrip(
    TripRequest request, {
    Duration? timeout,
    bool useCache = true,
  }) async {
    if (state.isLoading) {
      throw StateError('已有行程正在生成中');
    }

    _resetState();
    _isCancellationRequested = false;
    _cancellationCompleter = Completer<void>();

    final startTime = DateTime.now();
    final effectiveTimeout = timeout ?? _defaultTimeout;

    // 設定初始狀態
    state = TripGenerationResult(
      state: TripGenerationState.loading,
      progress: 0.0,
      currentPhase: '準備開始生成...',
      canCancel: true,
      startTime: startTime,
    );

    try {
      // 設定超時計時器
      _setupTimeoutTimer(effectiveTimeout);
      
      // 設定進度更新計時器
      _setupProgressTimer(startTime);

      // 開始生成行程
      final trip = await _generationService.generateTrip(
        request,
        useCache: useCache,
        onProgress: _updateProgress,
      );

      // 檢查是否被取消
      if (_isCancellationRequested) {
        _handleCancellation();
        return null;
      }

      // 儲存生成的行程
      await _tripRepository.saveTrip(trip);

      // 更新成功狀態
      final elapsedTime = DateTime.now().difference(startTime);
      state = state.copyWith(
        state: TripGenerationState.success,
        trip: trip,
        progress: 1.0,
        currentPhase: '行程生成完成！',
        canCancel: false,
        elapsedTime: elapsedTime,
      );

      _cleanup();
      return trip;

    } on TimeoutException {
      _handleTimeout();
      return null;
    } catch (e) {
      _handleError(e.toString());
      return null;
    }
  }

  /// 取消行程生成
  Future<void> cancelGeneration() async {
    if (!state.canCancel) {
      return;
    }

    _isCancellationRequested = true;
    
    // 等待當前操作完成或超時
    try {
      await _cancellationCompleter?.future.timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          // 強制取消
          _handleCancellation();
        },
      );
    } catch (e) {
      _handleCancellation();
    }
  }

  /// 重試生成
  Future<Trip?> retryGeneration(TripRequest request) async {
    if (!state.canRetry || state.retryCount >= _maxRetries) {
      throw StateError('無法重試：已達最大重試次數');
    }

    final newRetryCount = state.retryCount + 1;
    
    // 重置狀態但保留重試計數
    state = TripGenerationResult(
      state: TripGenerationState.idle,
      retryCount: newRetryCount,
    );

    // 延遲一下再重試
    await Future.delayed(Duration(seconds: newRetryCount));

    return generateTrip(request, useCache: false);
  }

  /// 重置狀態
  void reset() {
    _cleanup();
    state = const TripGenerationResult(state: TripGenerationState.idle);
  }

  /// 設定超時計時器
  void _setupTimeoutTimer(Duration timeout) {
    _timeoutTimer = Timer(timeout, () {
      if (state.isLoading) {
        _handleTimeout();
      }
    });
  }

  /// 設定進度更新計時器
  void _setupProgressTimer(DateTime startTime) {
    _progressTimer = Timer.periodic(_progressUpdateInterval, (timer) {
      if (!state.isLoading) {
        timer.cancel();
        return;
      }

      final elapsedTime = DateTime.now().difference(startTime);
      state = state.copyWith(elapsedTime: elapsedTime);
    });
  }

  /// 更新生成進度
  void _updateProgress(TripGenerationProgress progress) {
    if (_isCancellationRequested) {
      _cancellationCompleter?.complete();
      return;
    }

    state = state.copyWith(
      progress: progress.progress,
      currentPhase: progress.message ?? progress.phase.displayName,
    );
  }

  /// 處理超時
  void _handleTimeout() {
    state = state.copyWith(
      state: TripGenerationState.timeout,
      error: '行程生成超時，請檢查網路連線後重試',
      canRetry: state.retryCount < _maxRetries,
      canCancel: false,
    );
    _cleanup();
  }

  /// 處理錯誤
  void _handleError(String error) {
    state = state.copyWith(
      state: TripGenerationState.error,
      error: error,
      canRetry: state.retryCount < _maxRetries,
      canCancel: false,
    );
    _cleanup();
  }

  /// 處理取消
  void _handleCancellation() {
    state = state.copyWith(
      state: TripGenerationState.cancelled,
      error: '行程生成已取消',
      canRetry: true,
      canCancel: false,
    );
    _cleanup();
  }

  /// 重置內部狀態
  void _resetState() {
    _cleanup();
    _isCancellationRequested = false;
    _cancellationCompleter = null;
  }

  /// 清理資源
  void _cleanup() {
    _timeoutTimer?.cancel();
    _progressTimer?.cancel();
    _timeoutTimer = null;
    _progressTimer = null;
    
    if (_cancellationCompleter != null && !_cancellationCompleter!.isCompleted) {
      _cancellationCompleter!.complete();
    }
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }
}

/// 行程生成控制器 Provider
final tripGenerationControllerProvider = 
    StateNotifierProvider<TripGenerationController, TripGenerationResult>((ref) {
  final generationService = ref.read(tripGenerationServiceProvider);
  final tripRepository = ref.read(tripRepositoryProvider);
  
  return TripGenerationController(generationService, tripRepository);
});

/// 行程生成快取管理 Provider
final tripGenerationCacheProvider = Provider<TripGenerationCacheManager>((ref) {
  final generationService = ref.read(tripGenerationServiceProvider);
  return TripGenerationCacheManager(generationService);
});

/// 行程生成快取管理器
class TripGenerationCacheManager {
  final TripGenerationService _generationService;

  TripGenerationCacheManager(this._generationService);

  /// 清除所有快取
  void clearAllCache() {
    _generationService.clearCache();
  }

  /// 取得快取統計
  Map<String, dynamic> getCacheStats() {
    return _generationService.getCacheStats();
  }

  /// 預熱常用目的地快取
  Future<void> preloadCommonDestinations() async {
    await _generationService.preloadCommonDestinations();
  }

  /// 檢查特定請求是否有快取
  bool hasCachedTrip(TripRequest request) {
    // 這裡需要實作檢查邏輯
    // 目前先返回 false
    return false;
  }

  /// 取得快取大小（MB）
  double getCacheSizeInMB() {
    final stats = getCacheStats();
    final tripCacheSize = stats['tripCacheSize'] as int;
    final preferenceCacheSize = stats['preferenceCacheSize'] as int;
    
    // 估算每個快取項目約 50KB
    return (tripCacheSize + preferenceCacheSize) * 0.05;
  }
}

/// 行程生成統計 Provider
final tripGenerationStatsProvider = FutureProvider<TripGenerationStats>((ref) async {
  final tripRepository = ref.read(tripRepositoryProvider);
  final cacheManager = ref.read(tripGenerationCacheProvider);
  
  // 取得所有行程
  final allTrips = await tripRepository.getAllTrips();
  
  // 計算統計資料
  final totalTrips = allTrips.length;
  final generatedTrips = allTrips.where((trip) => 
      trip.preferenceAnalysis != null).length;
  
  final cacheStats = cacheManager.getCacheStats();
  
  return TripGenerationStats(
    totalTrips: totalTrips,
    generatedTrips: generatedTrips,
    cacheHitRate: _calculateCacheHitRate(cacheStats),
    averageGenerationTime: _calculateAverageGenerationTime(allTrips),
    cacheSize: cacheManager.getCacheSizeInMB(),
  );
});

/// 行程生成統計資料
class TripGenerationStats {
  final int totalTrips;
  final int generatedTrips;
  final double cacheHitRate;
  final Duration averageGenerationTime;
  final double cacheSize;

  const TripGenerationStats({
    required this.totalTrips,
    required this.generatedTrips,
    required this.cacheHitRate,
    required this.averageGenerationTime,
    required this.cacheSize,
  });
}

/// 計算快取命中率
double _calculateCacheHitRate(Map<String, dynamic> cacheStats) {
  // 這裡需要實際的快取命中統計
  // 目前返回估算值
  return 0.75; // 75% 命中率
}

/// 計算平均生成時間
Duration _calculateAverageGenerationTime(List<Trip> trips) {
  if (trips.isEmpty) return Duration.zero;
  
  // 這裡需要實際的生成時間統計
  // 目前返回估算值
  return const Duration(seconds: 30);
}

/// 行程生成歷史記錄 Provider
final tripGenerationHistoryProvider = FutureProvider<List<TripGenerationRecord>>((ref) async {
  // 這裡應該從本地儲存載入生成歷史
  // 目前返回空列表
  return <TripGenerationRecord>[];
});

/// 行程生成記錄
class TripGenerationRecord {
  final String id;
  final TripRequest request;
  final DateTime startTime;
  final DateTime? endTime;
  final TripGenerationState finalState;
  final String? errorMessage;
  final int retryCount;
  final Duration? totalTime;

  const TripGenerationRecord({
    required this.id,
    required this.request,
    required this.startTime,
    this.endTime,
    required this.finalState,
    this.errorMessage,
    this.retryCount = 0,
    this.totalTime,
  });

  bool get isSuccess => finalState == TripGenerationState.success;
  bool get isFailed => finalState == TripGenerationState.error || 
                      finalState == TripGenerationState.timeout;
}