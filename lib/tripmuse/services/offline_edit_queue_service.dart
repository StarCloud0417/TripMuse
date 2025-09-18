/// TripMuse 離線編輯佇列服務
/// 
/// 管理離線狀態下的編輯操作佇列，並在網路恢復時自動同步

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'storage/storage_service.dart';
import 'network_service.dart';
import 'sync/sync_service.dart';
import 'trip_api_service_impl.dart';
import 'edit_history_service.dart';
import '../providers/api_provider.dart';

/// 離線編輯操作類型
enum OfflineEditType {
  createTrip,
  updateTrip,
  deleteTrip,
  addActivity,
  updateActivity,
  deleteActivity,
  moveActivity,
  reorderActivities,
  updateDayPlan,
}

/// 離線編輯操作
class OfflineEditOperation {
  final String id;
  final String tripId;
  final OfflineEditType type;
  final DateTime timestamp;
  final Map<String, dynamic> data;
  final String? activityId;
  final int? dayIndex;
  final bool isProcessed;
  final String? errorMessage;
  final int retryCount;
  
  const OfflineEditOperation({
    required this.id,
    required this.tripId,
    required this.type,
    required this.timestamp,
    required this.data,
    this.activityId,
    this.dayIndex,
    this.isProcessed = false,
    this.errorMessage,
    this.retryCount = 0,
  });
  
  factory OfflineEditOperation.fromJson(Map<String, dynamic> json) {
    return OfflineEditOperation(
      id: json['id'] as String,
      tripId: json['tripId'] as String,
      type: OfflineEditType.values[json['type'] as int],
      timestamp: DateTime.parse(json['timestamp'] as String),
      data: Map<String, dynamic>.from(json['data'] as Map),
      activityId: json['activityId'] as String?,
      dayIndex: json['dayIndex'] as int?,
      isProcessed: json['isProcessed'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
      retryCount: json['retryCount'] as int? ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'type': type.index,
      'timestamp': timestamp.toIso8601String(),
      'data': data,
      'activityId': activityId,
      'dayIndex': dayIndex,
      'isProcessed': isProcessed,
      'errorMessage': errorMessage,
      'retryCount': retryCount,
    };
  }
  
  OfflineEditOperation copyWith({
    String? id,
    String? tripId,
    OfflineEditType? type,
    DateTime? timestamp,
    Map<String, dynamic>? data,
    String? activityId,
    int? dayIndex,
    bool? isProcessed,
    String? errorMessage,
    int? retryCount,
  }) {
    return OfflineEditOperation(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      data: data ?? this.data,
      activityId: activityId ?? this.activityId,
      dayIndex: dayIndex ?? this.dayIndex,
      isProcessed: isProcessed ?? this.isProcessed,
      errorMessage: errorMessage,
      retryCount: retryCount ?? this.retryCount,
    );
  }
  
  /// 取得操作描述
  String get description {
    switch (type) {
      case OfflineEditType.createTrip:
        return '建立行程';
      case OfflineEditType.updateTrip:
        return '更新行程';
      case OfflineEditType.deleteTrip:
        return '刪除行程';
      case OfflineEditType.addActivity:
        return '新增活動';
      case OfflineEditType.updateActivity:
        return '更新活動';
      case OfflineEditType.deleteActivity:
        return '刪除活動';
      case OfflineEditType.moveActivity:
        return '移動活動';
      case OfflineEditType.reorderActivities:
        return '重新排序活動';
      case OfflineEditType.updateDayPlan:
        return '更新日程計畫';
    }
  }
}

/// 離線編輯佇列狀態
class OfflineEditQueueState {
  final List<OfflineEditOperation> pendingOperations;
  final List<OfflineEditOperation> processingOperations;
  final List<OfflineEditOperation> failedOperations;
  final bool isProcessing;
  final String? lastError;
  
  const OfflineEditQueueState({
    this.pendingOperations = const [],
    this.processingOperations = const [],
    this.failedOperations = const [],
    this.isProcessing = false,
    this.lastError,
  });
  
  OfflineEditQueueState copyWith({
    List<OfflineEditOperation>? pendingOperations,
    List<OfflineEditOperation>? processingOperations,
    List<OfflineEditOperation>? failedOperations,
    bool? isProcessing,
    String? lastError,
  }) {
    return OfflineEditQueueState(
      pendingOperations: pendingOperations ?? this.pendingOperations,
      processingOperations: processingOperations ?? this.processingOperations,
      failedOperations: failedOperations ?? this.failedOperations,
      isProcessing: isProcessing ?? this.isProcessing,
      lastError: lastError,
    );
  }
  
  int get totalPendingCount => pendingOperations.length + processingOperations.length;
  bool get hasFailedOperations => failedOperations.isNotEmpty;
  bool get hasPendingOperations => totalPendingCount > 0;
}

/// 離線編輯佇列服務
class OfflineEditQueueService {
  static const String _queueKey = 'offline_edit_queue';
  static const int _maxRetryCount = 3;
  static const Duration _retryDelay = Duration(seconds: 5);
  
  final HiveStorageService _storageService;
  final NetworkService _networkService;
  final SyncService _syncService;
  
  final StreamController<OfflineEditQueueState> _stateController = 
      StreamController<OfflineEditQueueState>.broadcast();
  
  OfflineEditQueueState _currentState = const OfflineEditQueueState();
  StreamSubscription<NetworkInfo>? _networkSubscription;
  Timer? _retryTimer;
  
  OfflineEditQueueService({
    required HiveStorageService storageService,
    required NetworkService networkService,
    required SyncService syncService,
  }) : _storageService = storageService,
       _networkService = networkService,
       _syncService = syncService {
    _initialize();
  }
  
  /// 當前狀態
  OfflineEditQueueState get currentState => _currentState;
  
  /// 狀態串流
  Stream<OfflineEditQueueState> get stateStream => _stateController.stream;
  
  /// 初始化服務
  Future<void> _initialize() async {
    await _loadQueue();
    _startNetworkMonitoring();
    
    // 如果已連線，嘗試處理佇列
    if (_networkService.isConnected) {
      _processQueue();
    }
  }
  
  /// 新增編輯操作到佇列
  Future<void> addOperation({
    required String tripId,
    required OfflineEditType type,
    required Map<String, dynamic> data,
    String? activityId,
    int? dayIndex,
  }) async {
    final operation = OfflineEditOperation(
      id: '${DateTime.now().millisecondsSinceEpoch}_${type.name}',
      tripId: tripId,
      type: type,
      timestamp: DateTime.now(),
      data: data,
      activityId: activityId,
      dayIndex: dayIndex,
    );
    
    final newPendingOperations = List<OfflineEditOperation>.from(_currentState.pendingOperations)
      ..add(operation);
    
    _updateState(_currentState.copyWith(
      pendingOperations: newPendingOperations,
    ));
    
    await _saveQueue();
    
    // 如果已連線，立即嘗試處理
    if (_networkService.isConnected && !_currentState.isProcessing) {
      _processQueue();
    }
  }
  
  /// 處理佇列中的操作
  Future<void> _processQueue() async {
    if (_currentState.isProcessing || _currentState.pendingOperations.isEmpty) {
      return;
    }
    
    if (!_networkService.isConnected) {
      return;
    }
    
    _updateState(_currentState.copyWith(isProcessing: true));
    
    try {
      final operationsToProcess = List<OfflineEditOperation>.from(_currentState.pendingOperations);
      
      for (final operation in operationsToProcess) {
        await _processOperation(operation);
      }
      
      _updateState(_currentState.copyWith(
        isProcessing: false,
        lastError: null,
      ));
    } catch (e) {
      _updateState(_currentState.copyWith(
        isProcessing: false,
        lastError: e.toString(),
      ));
      
      // 設定重試計時器
      _scheduleRetry();
    }
    
    await _saveQueue();
  }
  
  /// 處理單一操作
  Future<void> _processOperation(OfflineEditOperation operation) async {
    try {
      // 移動到處理中佇列
      final newPendingOperations = List<OfflineEditOperation>.from(_currentState.pendingOperations)
        ..removeWhere((op) => op.id == operation.id);
      
      final newProcessingOperations = List<OfflineEditOperation>.from(_currentState.processingOperations)
        ..add(operation);
      
      _updateState(_currentState.copyWith(
        pendingOperations: newPendingOperations,
        processingOperations: newProcessingOperations,
      ));
      
      // 執行同步操作
      await _executeOperation(operation);
      
      // 操作成功，從處理中佇列移除
      final updatedProcessingOperations = List<OfflineEditOperation>.from(_currentState.processingOperations)
        ..removeWhere((op) => op.id == operation.id);
      
      _updateState(_currentState.copyWith(
        processingOperations: updatedProcessingOperations,
      ));
      
    } catch (e) {
      // 操作失敗，移動到失敗佇列或重試
      final updatedProcessingOperations = List<OfflineEditOperation>.from(_currentState.processingOperations)
        ..removeWhere((op) => op.id == operation.id);
      
      final failedOperation = operation.copyWith(
        retryCount: operation.retryCount + 1,
        errorMessage: e.toString(),
      );
      
      if (failedOperation.retryCount >= _maxRetryCount) {
        // 超過重試次數，移動到失敗佇列
        final newFailedOperations = List<OfflineEditOperation>.from(_currentState.failedOperations)
          ..add(failedOperation);
        
        _updateState(_currentState.copyWith(
          processingOperations: updatedProcessingOperations,
          failedOperations: newFailedOperations,
        ));
      } else {
        // 重新加入待處理佇列
        final newPendingOperations = List<OfflineEditOperation>.from(_currentState.pendingOperations)
          ..add(failedOperation);
        
        _updateState(_currentState.copyWith(
          pendingOperations: newPendingOperations,
          processingOperations: updatedProcessingOperations,
        ));
      }
      
      rethrow;
    }
  }
  
  /// 執行具體的同步操作
  Future<void> _executeOperation(OfflineEditOperation operation) async {
    switch (operation.type) {
      case OfflineEditType.createTrip:
      case OfflineEditType.updateTrip:
        await _syncService.markForSync(operation.tripId, SyncAction.update);
        await _syncService.syncTrip(operation.tripId);
        break;
      case OfflineEditType.deleteTrip:
        await _syncService.markForSync(operation.tripId, SyncAction.delete);
        await _syncService.syncTrip(operation.tripId);
        break;
      case OfflineEditType.addActivity:
      case OfflineEditType.updateActivity:
      case OfflineEditType.deleteActivity:
      case OfflineEditType.moveActivity:
      case OfflineEditType.reorderActivities:
      case OfflineEditType.updateDayPlan:
        // 這些操作都會影響行程，標記行程需要同步
        await _syncService.markForSync(operation.tripId, SyncAction.update);
        await _syncService.syncTrip(operation.tripId);
        break;
    }
  }
  
  /// 重試失敗的操作
  Future<void> retryFailedOperations() async {
    if (_currentState.failedOperations.isEmpty) return;
    
    final failedOperations = List<OfflineEditOperation>.from(_currentState.failedOperations);
    final newPendingOperations = List<OfflineEditOperation>.from(_currentState.pendingOperations);
    
    // 將失敗的操作重新加入待處理佇列，重置重試次數
    for (final operation in failedOperations) {
      newPendingOperations.add(operation.copyWith(
        retryCount: 0,
        errorMessage: null,
      ));
    }
    
    _updateState(_currentState.copyWith(
      pendingOperations: newPendingOperations,
      failedOperations: [],
    ));
    
    await _saveQueue();
    
    // 嘗試處理佇列
    if (_networkService.isConnected) {
      _processQueue();
    }
  }
  
  /// 清除失敗的操作
  Future<void> clearFailedOperations() async {
    _updateState(_currentState.copyWith(failedOperations: []));
    await _saveQueue();
  }
  
  /// 清除所有佇列
  Future<void> clearAllQueues() async {
    _updateState(const OfflineEditQueueState());
    await _saveQueue();
  }
  
  /// 開始網路監控
  void _startNetworkMonitoring() {
    _networkSubscription = _networkService.networkStream.listen((networkInfo) {
      if (networkInfo.isConnected && _currentState.hasPendingOperations && !_currentState.isProcessing) {
        _processQueue();
      }
    });
  }
  
  /// 設定重試計時器
  void _scheduleRetry() {
    _retryTimer?.cancel();
    _retryTimer = Timer(_retryDelay, () {
      if (_networkService.isConnected && _currentState.hasPendingOperations) {
        _processQueue();
      }
    });
  }
  
  /// 更新狀態
  void _updateState(OfflineEditQueueState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }
  
  /// 載入佇列
  Future<void> _loadQueue() async {
    try {
      final queueData = await _storageService.retrieve<Map<String, dynamic>>(_queueKey);
      if (queueData == null) return;
      
      final pendingOperations = (queueData['pendingOperations'] as List<dynamic>? ?? [])
          .map((item) => OfflineEditOperation.fromJson(item as Map<String, dynamic>))
          .toList();
      
      final processingOperations = (queueData['processingOperations'] as List<dynamic>? ?? [])
          .map((item) => OfflineEditOperation.fromJson(item as Map<String, dynamic>))
          .toList();
      
      final failedOperations = (queueData['failedOperations'] as List<dynamic>? ?? [])
          .map((item) => OfflineEditOperation.fromJson(item as Map<String, dynamic>))
          .toList();
      
      // 將處理中的操作移回待處理佇列（應用重啟後）
      final allPendingOperations = [...pendingOperations, ...processingOperations];
      
      _updateState(OfflineEditQueueState(
        pendingOperations: allPendingOperations,
        processingOperations: [],
        failedOperations: failedOperations,
      ));
    } catch (e) {
      print('載入離線編輯佇列失敗: $e');
    }
  }
  
  /// 儲存佇列
  Future<void> _saveQueue() async {
    try {
      final queueData = {
        'pendingOperations': _currentState.pendingOperations.map((op) => op.toJson()).toList(),
        'processingOperations': _currentState.processingOperations.map((op) => op.toJson()).toList(),
        'failedOperations': _currentState.failedOperations.map((op) => op.toJson()).toList(),
      };
      
      await _storageService.store(_queueKey, queueData);
    } catch (e) {
      print('儲存離線編輯佇列失敗: $e');
    }
  }
  
  /// 釋放資源
  void dispose() {
    _networkSubscription?.cancel();
    _retryTimer?.cancel();
    _stateController.close();
  }
}

/// 離線編輯佇列 Notifier
class OfflineEditQueueNotifier extends StateNotifier<OfflineEditQueueState> {
  OfflineEditQueueNotifier({
    required this.offlineEditQueueService,
  }) : super(const OfflineEditQueueState()) {
    _initialize();
  }
  
  final OfflineEditQueueService offlineEditQueueService;
  StreamSubscription<OfflineEditQueueState>? _stateSubscription;
  
  void _initialize() {
    _stateSubscription = offlineEditQueueService.stateStream.listen((newState) {
      state = newState;
    });
    
    // 設定初始狀態
    state = offlineEditQueueService.currentState;
  }
  
  /// 新增編輯操作
  Future<void> addOperation({
    required String tripId,
    required OfflineEditType type,
    required Map<String, dynamic> data,
    String? activityId,
    int? dayIndex,
  }) async {
    await offlineEditQueueService.addOperation(
      tripId: tripId,
      type: type,
      data: data,
      activityId: activityId,
      dayIndex: dayIndex,
    );
  }
  
  /// 重試失敗的操作
  Future<void> retryFailedOperations() async {
    await offlineEditQueueService.retryFailedOperations();
  }
  
  /// 清除失敗的操作
  Future<void> clearFailedOperations() async {
    await offlineEditQueueService.clearFailedOperations();
  }
  
  /// 清除所有佇列
  Future<void> clearAllQueues() async {
    await offlineEditQueueService.clearAllQueues();
  }
  
  @override
  void dispose() {
    _stateSubscription?.cancel();
    offlineEditQueueService.dispose();
    super.dispose();
  }
}

/// 離線編輯佇列服務 Provider
final offlineEditQueueServiceProvider = Provider<OfflineEditQueueService>((ref) {
  final storageService = ref.watch(offlineStorageServiceProvider);
  final networkService = ref.watch(networkServiceProvider);
  final syncService = ref.watch(offlineSyncServiceProvider);
  
  final service = OfflineEditQueueService(
    storageService: storageService,
    networkService: networkService,
    syncService: syncService,
  );
  
  ref.onDispose(() => service.dispose());
  return service;
});

/// 離線編輯佇列 Provider
final offlineEditQueueProvider = StateNotifierProvider<OfflineEditQueueNotifier, OfflineEditQueueState>((ref) {
  final service = ref.watch(offlineEditQueueServiceProvider);
  return OfflineEditQueueNotifier(offlineEditQueueService: service);
});

/// 同步服務 Provider（重新命名以避免衝突）
final offlineSyncServiceProvider = Provider<SyncService>((ref) {
  final storageService = ref.watch(offlineStorageServiceProvider);
  final tripApiService = ref.watch(offlineTripApiServiceProvider);
  
  return SyncServiceImpl(
    localStorage: storageService,
    tripApiService: tripApiService,
  );
});

/// Trip API Service Provider（重新命名以避免衝突）
final offlineTripApiServiceProvider = Provider<TripApiServiceImpl>((ref) {
  // 暫時返回一個模擬的實作，避免應用程式崩潰
  final apiClient = ref.watch(apiClientProvider);
  return TripApiServiceImpl(apiClient);
});