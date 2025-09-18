/// TripMuse 離線編輯管理器
/// 
/// 整合離線編輯佇列、同步服務、衝突解決和編輯歷史功能

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'edit_history_service.dart';
import 'offline_edit_queue_service.dart';
import 'conflict_resolution_service.dart';
import 'sync/sync_service.dart';
import 'network_service.dart';
import 'auto_save_service.dart';

/// 離線編輯狀態
class OfflineEditState {
  final bool isOnline;
  final bool isAutoSaveEnabled;
  final bool hasPendingChanges;
  final bool hasUnresolvedConflicts;
  final int pendingOperationsCount;
  final int unresolvedConflictCount;
  final DateTime? lastSyncTime;
  final String? lastError;
  final bool isSyncing;
  
  const OfflineEditState({
    this.isOnline = false,
    this.isAutoSaveEnabled = true,
    this.hasPendingChanges = false,
    this.hasUnresolvedConflicts = false,
    this.pendingOperationsCount = 0,
    this.unresolvedConflictCount = 0,
    this.lastSyncTime,
    this.lastError,
    this.isSyncing = false,
  });
  
  OfflineEditState copyWith({
    bool? isOnline,
    bool? isAutoSaveEnabled,
    bool? hasPendingChanges,
    bool? hasUnresolvedConflicts,
    int? pendingOperationsCount,
    int? unresolvedConflictCount,
    DateTime? lastSyncTime,
    String? lastError,
    bool? isSyncing,
  }) {
    return OfflineEditState(
      isOnline: isOnline ?? this.isOnline,
      isAutoSaveEnabled: isAutoSaveEnabled ?? this.isAutoSaveEnabled,
      hasPendingChanges: hasPendingChanges ?? this.hasPendingChanges,
      hasUnresolvedConflicts: hasUnresolvedConflicts ?? this.hasUnresolvedConflicts,
      pendingOperationsCount: pendingOperationsCount ?? this.pendingOperationsCount,
      unresolvedConflictCount: unresolvedConflictCount ?? this.unresolvedConflictCount,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      lastError: lastError,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
  
  /// 取得狀態描述
  String get statusDescription {
    if (!isOnline) {
      return '離線模式';
    } else if (isSyncing) {
      return '同步中...';
    } else if (hasUnresolvedConflicts) {
      return '有 $unresolvedConflictCount 個衝突需要解決';
    } else if (hasPendingChanges) {
      return '有 $pendingOperationsCount 個變更待同步';
    } else {
      return '已同步';
    }
  }
  
  /// 是否需要使用者注意
  bool get needsAttention => hasUnresolvedConflicts || (hasPendingChanges && isOnline);
}

/// 離線編輯管理器
class OfflineEditManager {
  final EditHistoryService _editHistoryService;
  final OfflineEditQueueService _offlineEditQueueService;
  final ConflictResolutionService _conflictResolutionService;
  final SyncService _syncService;
  final NetworkService _networkService;
  final AutoSaveService _autoSaveService;
  
  final StreamController<OfflineEditState> _stateController = 
      StreamController<OfflineEditState>.broadcast();
  
  OfflineEditState _currentState = const OfflineEditState();
  
  // 訂閱
  StreamSubscription<NetworkInfo>? _networkSubscription;
  StreamSubscription<OfflineEditQueueState>? _queueSubscription;
  StreamSubscription<List<SyncConflict>>? _conflictsSubscription;
  StreamSubscription<AutoSaveState>? _autoSaveSubscription;
  
  OfflineEditManager({
    required EditHistoryService editHistoryService,
    required OfflineEditQueueService offlineEditQueueService,
    required ConflictResolutionService conflictResolutionService,
    required SyncService syncService,
    required NetworkService networkService,
    required AutoSaveService autoSaveService,
  }) : _editHistoryService = editHistoryService,
       _offlineEditQueueService = offlineEditQueueService,
       _conflictResolutionService = conflictResolutionService,
       _syncService = syncService,
       _networkService = networkService,
       _autoSaveService = autoSaveService {
    _initialize();
  }
  
  /// 當前狀態
  OfflineEditState get currentState => _currentState;
  
  /// 狀態串流
  Stream<OfflineEditState> get stateStream => _stateController.stream;
  
  /// 初始化
  void _initialize() {
    // 監聽網路狀態
    _networkSubscription = _networkService.networkStream.listen((networkInfo) {
      _updateState(_currentState.copyWith(isOnline: networkInfo.isConnected));
    });
    
    // 監聽編輯佇列狀態
    _queueSubscription = _offlineEditQueueService.stateStream.listen((queueState) {
      _updateState(_currentState.copyWith(
        hasPendingChanges: queueState.hasPendingOperations,
        pendingOperationsCount: queueState.totalPendingCount,
      ));
    });
    
    // 監聽衝突狀態
    _conflictsSubscription = _conflictResolutionService.conflictsStream.listen((conflicts) {
      final unresolvedCount = conflicts.where((c) => !c.isResolved).length;
      _updateState(_currentState.copyWith(
        hasUnresolvedConflicts: unresolvedCount > 0,
        unresolvedConflictCount: unresolvedCount,
      ));
    });
    
    // 設定初始狀態
    _updateInitialState();
  }
  
  /// 設定初始狀態
  void _updateInitialState() {
    _updateState(OfflineEditState(
      isOnline: _networkService.isConnected,
      hasPendingChanges: _offlineEditQueueService.currentState.hasPendingOperations,
      pendingOperationsCount: _offlineEditQueueService.currentState.totalPendingCount,
      hasUnresolvedConflicts: _conflictResolutionService.hasUnresolvedConflicts,
      unresolvedConflictCount: _conflictResolutionService.unresolvedConflictCount,
    ));
  }
  
  /// 記錄行程編輯操作
  Future<void> recordTripEdit({
    required String tripId,
    required Trip beforeTrip,
    required Trip afterTrip,
    required String description,
  }) async {
    // 記錄編輯歷史
    await _editHistoryService.recordAction(
      tripId: tripId,
      type: EditActionType.updateTrip,
      beforeState: beforeTrip.toJson(),
      afterState: afterTrip.toJson(),
      description: description,
    );
    
    // 如果離線，加入編輯佇列
    if (!_networkService.isConnected) {
      await _offlineEditQueueService.addOperation(
        tripId: tripId,
        type: OfflineEditType.updateTrip,
        data: afterTrip.toJson(),
      );
    } else {
      // 線上時直接同步
      await _syncTrip(tripId);
    }
    
    // 觸發自動儲存
    _autoSaveService.markTripForSave(afterTrip);
  }
  
  /// 記錄活動編輯操作
  Future<void> recordActivityEdit({
    required String tripId,
    required String activityId,
    required Activity beforeActivity,
    required Activity afterActivity,
    required String description,
  }) async {
    // 記錄編輯歷史
    await _editHistoryService.recordAction(
      tripId: tripId,
      type: EditActionType.updateActivity,
      beforeState: beforeActivity.toJson(),
      afterState: afterActivity.toJson(),
      description: description,
    );
    
    // 如果離線，加入編輯佇列
    if (!_networkService.isConnected) {
      await _offlineEditQueueService.addOperation(
        tripId: tripId,
        type: OfflineEditType.updateActivity,
        data: afterActivity.toJson(),
        activityId: activityId,
      );
    } else {
      // 線上時直接同步
      await _syncTrip(tripId);
    }
  }
  
  /// 記錄活動新增操作
  Future<void> recordActivityAdd({
    required String tripId,
    required Activity activity,
    required int dayIndex,
  }) async {
    // 記錄編輯歷史
    await _editHistoryService.recordAction(
      tripId: tripId,
      type: EditActionType.addActivity,
      beforeState: {},
      afterState: activity.toJson(),
      description: '新增活動: ${activity.name}',
    );
    
    // 如果離線，加入編輯佇列
    if (!_networkService.isConnected) {
      await _offlineEditQueueService.addOperation(
        tripId: tripId,
        type: OfflineEditType.addActivity,
        data: activity.toJson(),
        activityId: activity.id,
        dayIndex: dayIndex,
      );
    } else {
      // 線上時直接同步
      await _syncTrip(tripId);
    }
  }
  
  /// 記錄活動刪除操作
  Future<void> recordActivityDelete({
    required String tripId,
    required Activity activity,
    required int dayIndex,
  }) async {
    // 記錄編輯歷史
    await _editHistoryService.recordAction(
      tripId: tripId,
      type: EditActionType.deleteActivity,
      beforeState: activity.toJson(),
      afterState: {},
      description: '刪除活動: ${activity.name}',
    );
    
    // 如果離線，加入編輯佇列
    if (!_networkService.isConnected) {
      await _offlineEditQueueService.addOperation(
        tripId: tripId,
        type: OfflineEditType.deleteActivity,
        data: {'deletedActivityId': activity.id},
        activityId: activity.id,
        dayIndex: dayIndex,
      );
    } else {
      // 線上時直接同步
      await _syncTrip(tripId);
    }
  }
  
  /// 復原操作
  Future<Map<String, dynamic>?> undoEdit(String tripId) async {
    return await _editHistoryService.undo(tripId);
  }
  
  /// 重做操作
  Future<Map<String, dynamic>?> redoEdit(String tripId) async {
    return await _editHistoryService.redo(tripId);
  }
  
  /// 取得編輯歷史狀態
  EditHistoryState getEditHistoryState(String tripId) {
    return _editHistoryService.getHistoryState(tripId);
  }
  
  /// 手動同步
  Future<void> manualSync() async {
    if (!_networkService.isConnected) {
      throw Exception('無網路連線');
    }
    
    _updateState(_currentState.copyWith(isSyncing: true, lastError: null));
    
    try {
      await _syncService.syncAllTrips();
      _updateState(_currentState.copyWith(
        isSyncing: false,
        lastSyncTime: DateTime.now(),
      ));
    } catch (e) {
      _updateState(_currentState.copyWith(
        isSyncing: false,
        lastError: e.toString(),
      ));
      rethrow;
    }
  }
  
  /// 重試失敗的操作
  Future<void> retryFailedOperations() async {
    await _offlineEditQueueService.retryFailedOperations();
  }
  
  /// 解決衝突
  Future<ConflictResolutionResult?> resolveConflict(
    String conflictId,
    ConflictResolutionStrategy strategy,
  ) async {
    return await _conflictResolutionService.autoResolveConflict(conflictId, strategy);
  }
  
  /// 取得衝突列表
  List<SyncConflict> getConflicts() {
    return _conflictResolutionService.conflicts;
  }
  
  /// 啟用自動儲存
  void enableAutoSave() {
    _autoSaveService.enable();
    _updateState(_currentState.copyWith(isAutoSaveEnabled: true));
  }
  
  /// 停用自動儲存
  void disableAutoSave() {
    _autoSaveService.disable();
    _updateState(_currentState.copyWith(isAutoSaveEnabled: false));
  }
  
  /// 清除編輯歷史
  Future<void> clearEditHistory(String tripId) async {
    await _editHistoryService.clearHistory(tripId);
  }
  
  /// 清除已解決的衝突
  Future<void> clearResolvedConflicts() async {
    await _conflictResolutionService.clearResolvedConflicts();
  }
  
  /// 同步單一行程
  Future<void> _syncTrip(String tripId) async {
    try {
      await _syncService.syncTrip(tripId);
      _updateState(_currentState.copyWith(lastSyncTime: DateTime.now()));
    } catch (e) {
      _updateState(_currentState.copyWith(lastError: e.toString()));
      // 不重新拋出錯誤，讓操作繼續
    }
  }
  
  /// 更新狀態
  void _updateState(OfflineEditState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }
  
  /// 釋放資源
  void dispose() {
    _networkSubscription?.cancel();
    _queueSubscription?.cancel();
    _conflictsSubscription?.cancel();
    _autoSaveSubscription?.cancel();
    _stateController.close();
  }
}

/// 離線編輯管理器 Notifier
class OfflineEditManagerNotifier extends StateNotifier<OfflineEditState> {
  OfflineEditManagerNotifier({
    required this.offlineEditManager,
  }) : super(const OfflineEditState()) {
    _initialize();
  }
  
  final OfflineEditManager offlineEditManager;
  StreamSubscription<OfflineEditState>? _stateSubscription;
  
  void _initialize() {
    _stateSubscription = offlineEditManager.stateStream.listen((newState) {
      state = newState;
    });
    
    // 設定初始狀態
    state = offlineEditManager.currentState;
  }
  
  /// 記錄行程編輯
  Future<void> recordTripEdit({
    required String tripId,
    required Trip beforeTrip,
    required Trip afterTrip,
    required String description,
  }) async {
    await offlineEditManager.recordTripEdit(
      tripId: tripId,
      beforeTrip: beforeTrip,
      afterTrip: afterTrip,
      description: description,
    );
  }
  
  /// 記錄活動編輯
  Future<void> recordActivityEdit({
    required String tripId,
    required String activityId,
    required Activity beforeActivity,
    required Activity afterActivity,
    required String description,
  }) async {
    await offlineEditManager.recordActivityEdit(
      tripId: tripId,
      activityId: activityId,
      beforeActivity: beforeActivity,
      afterActivity: afterActivity,
      description: description,
    );
  }
  
  /// 記錄活動新增
  Future<void> recordActivityAdd({
    required String tripId,
    required Activity activity,
    required int dayIndex,
  }) async {
    await offlineEditManager.recordActivityAdd(
      tripId: tripId,
      activity: activity,
      dayIndex: dayIndex,
    );
  }
  
  /// 記錄活動刪除
  Future<void> recordActivityDelete({
    required String tripId,
    required Activity activity,
    required int dayIndex,
  }) async {
    await offlineEditManager.recordActivityDelete(
      tripId: tripId,
      activity: activity,
      dayIndex: dayIndex,
    );
  }
  
  /// 復原操作
  Future<Map<String, dynamic>?> undoEdit(String tripId) async {
    return await offlineEditManager.undoEdit(tripId);
  }
  
  /// 重做操作
  Future<Map<String, dynamic>?> redoEdit(String tripId) async {
    return await offlineEditManager.redoEdit(tripId);
  }
  
  /// 手動同步
  Future<void> manualSync() async {
    await offlineEditManager.manualSync();
  }
  
  /// 重試失敗的操作
  Future<void> retryFailedOperations() async {
    await offlineEditManager.retryFailedOperations();
  }
  
  /// 解決衝突
  Future<ConflictResolutionResult?> resolveConflict(
    String conflictId,
    ConflictResolutionStrategy strategy,
  ) async {
    return await offlineEditManager.resolveConflict(conflictId, strategy);
  }
  
  /// 啟用自動儲存
  void enableAutoSave() {
    offlineEditManager.enableAutoSave();
  }
  
  /// 停用自動儲存
  void disableAutoSave() {
    offlineEditManager.disableAutoSave();
  }
  
  @override
  void dispose() {
    _stateSubscription?.cancel();
    offlineEditManager.dispose();
    super.dispose();
  }
}

/// 離線編輯管理器服務 Provider
final offlineEditManagerProvider = Provider<OfflineEditManager>((ref) {
  final editHistoryService = ref.watch(editHistoryServiceProvider);
  final offlineEditQueueService = ref.watch(offlineEditQueueServiceProvider);
  final conflictResolutionService = ref.watch(conflictResolutionServiceProvider);
  final syncService = ref.watch(offlineSyncServiceProvider);
  final networkService = ref.watch(networkServiceProvider);
  final autoSaveService = ref.watch(autoSaveServiceProvider);
  
  final manager = OfflineEditManager(
    editHistoryService: editHistoryService,
    offlineEditQueueService: offlineEditQueueService,
    conflictResolutionService: conflictResolutionService,
    syncService: syncService,
    networkService: networkService,
    autoSaveService: autoSaveService,
  );
  
  ref.onDispose(() => manager.dispose());
  return manager;
});

/// 離線編輯狀態 Provider
final offlineEditStateProvider = StateNotifierProvider<OfflineEditManagerNotifier, OfflineEditState>((ref) {
  final manager = ref.watch(offlineEditManagerProvider);
  return OfflineEditManagerNotifier(offlineEditManager: manager);
});