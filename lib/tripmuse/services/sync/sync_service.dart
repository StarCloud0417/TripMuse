/// 離線資料同步服務
/// 
/// 處理本地資料與雲端的同步，支援離線編輯和衝突解決

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../storage/storage_service.dart';
import '../trip_api_service_impl.dart';

/// 同步動作類型
enum SyncAction {
  create,
  update,
  delete,
}

/// 同步狀態
enum SyncStatus {
  pending,
  syncing,
  completed,
  failed,
}

/// 同步項目
class SyncItem {
  final String id;
  final String itemId;
  final SyncAction action;
  final SyncStatus status;
  final DateTime createdAt;
  final DateTime? lastAttempt;
  final int retryCount;
  final String? errorMessage;
  
  const SyncItem({
    required this.id,
    required this.itemId,
    required this.action,
    required this.status,
    required this.createdAt,
    this.lastAttempt,
    this.retryCount = 0,
    this.errorMessage,
  });
  
  factory SyncItem.fromJson(Map<String, dynamic> json) {
    return SyncItem(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      action: SyncAction.values[json['action'] as int],
      status: SyncStatus.values[json['status'] as int],
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastAttempt: json['lastAttempt'] != null 
          ? DateTime.parse(json['lastAttempt'] as String) 
          : null,
      retryCount: json['retryCount'] as int? ?? 0,
      errorMessage: json['errorMessage'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'action': action.index,
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
      'lastAttempt': lastAttempt?.toIso8601String(),
      'retryCount': retryCount,
      'errorMessage': errorMessage,
    };
  }
  
  SyncItem copyWith({
    String? id,
    String? itemId,
    SyncAction? action,
    SyncStatus? status,
    DateTime? createdAt,
    DateTime? lastAttempt,
    int? retryCount,
    String? errorMessage,
  }) {
    return SyncItem(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      action: action ?? this.action,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastAttempt: lastAttempt ?? this.lastAttempt,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// 同步服務介面
abstract class SyncService {
  /// 檢查網路連線狀態
  Future<bool> isOnline();
  
  /// 標記項目需要同步
  Future<void> markForSync(String itemId, SyncAction action);
  
  /// 同步單一項目
  Future<void> syncTrip(String tripId);
  
  /// 同步所有待同步項目
  Future<void> syncAllTrips();
  
  /// 檢查是否有待同步的變更
  Future<bool> hasPendingChanges();
  
  /// 取得同步狀態
  Future<List<SyncItem>> getSyncQueue();
  
  /// 清除同步佇列
  Future<void> clearSyncQueue();
  
  /// 開始自動同步
  void startAutoSync();
  
  /// 停止自動同步
  void stopAutoSync();
}

/// 同步服務實作
class SyncServiceImpl implements SyncService {
  final HiveStorageService _localStorage;
  final TripApiServiceImpl _tripApiService;
  
  static const String _syncQueueKey = 'sync_queue';
  static const int _maxRetryCount = 3;
  static const Duration _autoSyncInterval = Duration(minutes: 5);
  
  Timer? _autoSyncTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  
  SyncServiceImpl({
    required HiveStorageService localStorage,
    required TripApiServiceImpl tripApiService,
  }) : _localStorage = localStorage,
       _tripApiService = tripApiService;
  
  @override
  Future<bool> isOnline() async {
    try {
      final connectivityResults = await Connectivity().checkConnectivity();
      return connectivityResults.any((result) => result != ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<void> markForSync(String itemId, SyncAction action) async {
    try {
      final syncQueue = await _getSyncQueue();
      
      // 檢查是否已存在相同項目的同步請求
      final existingIndex = syncQueue.indexWhere((item) => item.itemId == itemId);
      
      final syncItem = SyncItem(
        id: '${itemId}_${DateTime.now().millisecondsSinceEpoch}',
        itemId: itemId,
        action: action,
        status: SyncStatus.pending,
        createdAt: DateTime.now(),
      );
      
      if (existingIndex >= 0) {
        // 更新現有項目
        syncQueue[existingIndex] = syncItem;
      } else {
        // 新增項目
        syncQueue.add(syncItem);
      }
      
      await _saveSyncQueue(syncQueue);
    } catch (e) {
      throw SyncException('標記同步失敗: $e');
    }
  }
  
  @override
  Future<void> syncTrip(String tripId) async {
    try {
      if (!await isOnline()) {
        throw SyncException('無網路連線');
      }
      
      final syncQueue = await _getSyncQueue();
      final syncItem = syncQueue.firstWhere(
        (item) => item.itemId == tripId,
        orElse: () => throw SyncException('找不到同步項目'),
      );
      
      // 更新狀態為同步中
      final updatedItem = syncItem.copyWith(
        status: SyncStatus.syncing,
        lastAttempt: DateTime.now(),
      );
      await _updateSyncItem(updatedItem);
      
      try {
        switch (syncItem.action) {
          case SyncAction.create:
          case SyncAction.update:
            await _syncTripToCloud(tripId);
            break;
          case SyncAction.delete:
            await _deleteTripFromCloud(tripId);
            break;
        }
        
        // 同步成功，標記為完成
        final completedItem = updatedItem.copyWith(
          status: SyncStatus.completed,
        );
        await _updateSyncItem(completedItem);
        
        // 從佇列中移除已完成的項目
        await _removeSyncItem(completedItem.id);
        
      } catch (e) {
        // 同步失敗，更新重試次數
        final failedItem = updatedItem.copyWith(
          status: SyncStatus.failed,
          retryCount: updatedItem.retryCount + 1,
          errorMessage: e.toString(),
        );
        await _updateSyncItem(failedItem);
        
        // 如果重試次數超過限制，從佇列中移除
        if (failedItem.retryCount >= _maxRetryCount) {
          await _removeSyncItem(failedItem.id);
        }
        
        rethrow;
      }
    } catch (e) {
      throw SyncException('同步行程失敗: $e');
    }
  }
  
  @override
  Future<void> syncAllTrips() async {
    try {
      if (!await isOnline()) {
        throw SyncException('無網路連線');
      }
      
      final syncQueue = await _getSyncQueue();
      final pendingItems = syncQueue.where((item) => 
        item.status == SyncStatus.pending || 
        (item.status == SyncStatus.failed && item.retryCount < _maxRetryCount)
      ).toList();
      
      for (final item in pendingItems) {
        try {
          await syncTrip(item.itemId);
        } catch (e) {
          // 記錄錯誤但繼續同步其他項目
          print('同步項目 ${item.itemId} 失敗: $e');
        }
      }
    } catch (e) {
      throw SyncException('批量同步失敗: $e');
    }
  }
  
  @override
  Future<bool> hasPendingChanges() async {
    try {
      final syncQueue = await _getSyncQueue();
      return syncQueue.any((item) => 
        item.status == SyncStatus.pending || 
        item.status == SyncStatus.syncing
      );
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<List<SyncItem>> getSyncQueue() async {
    return await _getSyncQueue();
  }
  
  @override
  Future<void> clearSyncQueue() async {
    try {
      await _localStorage.delete(_syncQueueKey);
    } catch (e) {
      throw SyncException('清除同步佇列失敗: $e');
    }
  }
  
  @override
  void startAutoSync() {
    stopAutoSync(); // 確保沒有重複的 timer
    
    _autoSyncTimer = Timer.periodic(_autoSyncInterval, (timer) async {
      if (await isOnline() && await hasPendingChanges()) {
        try {
          await syncAllTrips();
        } catch (e) {
          print('自動同步失敗: $e');
        }
      }
    });
    
    // 監聽網路狀態變化
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) async {
      if (results.any((result) => result != ConnectivityResult.none) && await hasPendingChanges()) {
        try {
          await syncAllTrips();
        } catch (e) {
          print('網路恢復後同步失敗: $e');
        }
      }
    });
  }
  
  @override
  void stopAutoSync() {
    _autoSyncTimer?.cancel();
    _autoSyncTimer = null;
    
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }
  
  /// 取得同步佇列
  Future<List<SyncItem>> _getSyncQueue() async {
    try {
      final queueData = await _localStorage.retrieve<List<dynamic>>(_syncQueueKey);
      if (queueData == null) return [];
      
      return queueData
          .map((item) => SyncItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
  
  /// 儲存同步佇列
  Future<void> _saveSyncQueue(List<SyncItem> queue) async {
    try {
      final queueData = queue.map((item) => item.toJson()).toList();
      await _localStorage.store(_syncQueueKey, queueData);
    } catch (e) {
      throw SyncException('儲存同步佇列失敗: $e');
    }
  }
  
  /// 更新同步項目
  Future<void> _updateSyncItem(SyncItem updatedItem) async {
    try {
      final syncQueue = await _getSyncQueue();
      final index = syncQueue.indexWhere((item) => item.id == updatedItem.id);
      
      if (index >= 0) {
        syncQueue[index] = updatedItem;
        await _saveSyncQueue(syncQueue);
      }
    } catch (e) {
      throw SyncException('更新同步項目失敗: $e');
    }
  }
  
  /// 移除同步項目
  Future<void> _removeSyncItem(String itemId) async {
    try {
      final syncQueue = await _getSyncQueue();
      syncQueue.removeWhere((item) => item.id == itemId);
      await _saveSyncQueue(syncQueue);
    } catch (e) {
      throw SyncException('移除同步項目失敗: $e');
    }
  }
  
  /// 同步行程到雲端（模擬實作）
  Future<void> _syncTripToCloud(String tripId) async {
    // 這裡應該實作實際的 API 呼叫
    // 暫時模擬網路延遲
    await Future.delayed(const Duration(seconds: 1));
    
    // 模擬偶爾的網路錯誤
    if (DateTime.now().millisecond % 10 == 0) {
      throw Exception('網路錯誤');
    }
    
    print('行程 $tripId 已同步到雲端');
  }
  
  /// 從雲端刪除行程
  Future<void> _deleteTripFromCloud(String tripId) async {
    try {
      final response = await _tripApiService.deleteTrip(tripId);
      
      if (response.success) {
        print('行程 $tripId 已成功從雲端刪除');
      } else {
        throw Exception('刪除雲端行程失敗: ${response.message}');
      }
    } catch (e) {
      print('刪除雲端行程時發生錯誤: $e');
      throw e; // 重新拋出錯誤，讓上層處理
    }
  }
  
  /// 釋放資源
  void dispose() {
    stopAutoSync();
  }
}

/// 同步例外
class SyncException implements Exception {
  final String message;
  
  const SyncException(this.message);
  
  @override
  String toString() => 'SyncException: $message';
}