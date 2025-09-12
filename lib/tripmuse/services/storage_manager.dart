/// TripMuse 儲存管理器
/// 
/// 統一管理所有儲存服務和 Repository，提供依賴注入和初始化

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'storage/storage_service.dart';
import 'repositories/trip_repository.dart';
import 'repositories/user_repository.dart';
import 'sync/sync_service.dart';
import 'trip_api_service_impl.dart';
import 'api_client.dart';

/// 儲存管理器
class StorageManager {
  static StorageManager? _instance;
  static StorageManager get instance => _instance ??= StorageManager._();
  
  StorageManager._();
  
  HiveStorageService? _hiveStorage;
  FlutterSecureStorageService? _secureStorage;
  SyncServiceImpl? _syncService;
  TripRepositoryImpl? _tripRepository;
  UserRepositoryImpl? _userRepository;
  
  bool _isInitialized = false;
  
  /// 初始化所有儲存服務
  Future<void> initialize([TripApiServiceImpl? tripApiService]) async {
    if (_isInitialized) return;
    
    try {
      // 初始化基礎儲存服務
      _hiveStorage = HiveStorageService();
      await _hiveStorage!.initialize();
      
      _secureStorage = FlutterSecureStorageService();
      
      // 創建 TripApiService（如果沒有提供）
      final apiService = tripApiService ?? TripApiServiceImpl(ApiClient());
      
      // 初始化同步服務
      _syncService = SyncServiceImpl(
        localStorage: _hiveStorage!,
        tripApiService: apiService,
      );
      
      // 初始化 Repository
      _tripRepository = TripRepositoryImpl(
        localStorage: _hiveStorage!,
        syncService: _syncService!,
      );
      
      _userRepository = UserRepositoryImpl(
        localStorage: _hiveStorage!,
        secureStorage: _secureStorage!,
      );
      
      // 開始自動同步
      _syncService!.startAutoSync();
      
      _isInitialized = true;
      
      print('TripMuse 儲存系統初始化完成');
    } catch (e) {
      throw StorageManagerException('儲存系統初始化失敗: $e');
    }
  }
  
  /// 釋放所有資源
  Future<void> dispose() async {
    if (!_isInitialized) return;
    
    try {
      // 停止自動同步
      _syncService?.stopAutoSync();
      _syncService?.dispose();
      
      // 關閉儲存服務
      await _hiveStorage?.dispose();
      
      _hiveStorage = null;
      _secureStorage = null;
      _syncService = null;
      _tripRepository = null;
      _userRepository = null;
      
      _isInitialized = false;
      
      print('TripMuse 儲存系統已釋放');
    } catch (e) {
      print('釋放儲存系統時發生錯誤: $e');
    }
  }
  
  /// 取得 Hive 儲存服務
  HiveStorageService get hiveStorage {
    _ensureInitialized();
    return _hiveStorage!;
  }
  
  /// 取得安全儲存服務
  FlutterSecureStorageService get secureStorage {
    _ensureInitialized();
    return _secureStorage!;
  }
  
  /// 取得同步服務
  SyncServiceImpl get syncService {
    _ensureInitialized();
    return _syncService!;
  }
  
  /// 取得行程 Repository
  TripRepositoryImpl get tripRepository {
    _ensureInitialized();
    return _tripRepository!;
  }
  
  /// 取得使用者 Repository
  UserRepositoryImpl get userRepository {
    _ensureInitialized();
    return _userRepository!;
  }
  
  /// 檢查是否已初始化
  bool get isInitialized => _isInitialized;
  
  /// 確保已初始化
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StorageManagerException('儲存管理器尚未初始化，請先呼叫 initialize()');
    }
  }
  
  /// 清除所有資料（用於測試或重置）
  Future<void> clearAllData() async {
    _ensureInitialized();
    
    try {
      await _syncService!.clearSyncQueue();
      await _hiveStorage!.clear();
      await _secureStorage!.clearSecure();
      
      print('所有儲存資料已清除');
    } catch (e) {
      throw StorageManagerException('清除資料失敗: $e');
    }
  }
  
  /// 取得儲存統計資訊
  Future<StorageStatistics> getStorageStatistics() async {
    _ensureInitialized();
    
    try {
      final tripStats = await _tripRepository!.getTripStatistics();
      final syncQueue = await _syncService!.getSyncQueue();
      final allKeys = await _hiveStorage!.getAllKeys();
      
      return StorageStatistics(
        totalTrips: tripStats.totalTrips,
        totalActivities: tripStats.totalActivities,
        pendingSyncItems: syncQueue.length,
        totalStorageKeys: allKeys.length,
        isOnline: await _syncService!.isOnline(),
        lastSyncTime: await _getLastSyncTime(),
      );
    } catch (e) {
      throw StorageManagerException('取得儲存統計失敗: $e');
    }
  }
  
  /// 取得最後同步時間
  Future<DateTime?> _getLastSyncTime() async {
    try {
      final timestamp = await _hiveStorage!.retrieve<int>(StorageKeys.lastSyncTime);
      return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
    } catch (e) {
      return null;
    }
  }
  
  /// 更新最後同步時間
  Future<void> updateLastSyncTime() async {
    try {
      await _hiveStorage!.store(StorageKeys.lastSyncTime, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('更新同步時間失敗: $e');
    }
  }
}

/// 儲存統計資訊
class StorageStatistics {
  final int totalTrips;
  final int totalActivities;
  final int pendingSyncItems;
  final int totalStorageKeys;
  final bool isOnline;
  final DateTime? lastSyncTime;
  
  const StorageStatistics({
    required this.totalTrips,
    required this.totalActivities,
    required this.pendingSyncItems,
    required this.totalStorageKeys,
    required this.isOnline,
    this.lastSyncTime,
  });
  
  /// 取得格式化的最後同步時間
  String get formattedLastSyncTime {
    if (lastSyncTime == null) return '從未同步';
    
    final now = DateTime.now();
    final difference = now.difference(lastSyncTime!);
    
    if (difference.inMinutes < 1) {
      return '剛剛同步';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} 分鐘前同步';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} 小時前同步';
    } else {
      return '${difference.inDays} 天前同步';
    }
  }
  
  /// 檢查是否需要同步
  bool get needsSync => pendingSyncItems > 0;
  
  /// 取得儲存狀態摘要
  String get statusSummary {
    final buffer = StringBuffer();
    buffer.write('$totalTrips 個行程');
    
    if (totalActivities > 0) {
      buffer.write('，$totalActivities 個活動');
    }
    
    if (needsSync) {
      buffer.write('，$pendingSyncItems 項待同步');
    }
    
    if (!isOnline) {
      buffer.write('（離線模式）');
    }
    
    return buffer.toString();
  }
}

/// 儲存管理器例外
class StorageManagerException implements Exception {
  final String message;
  
  const StorageManagerException(this.message);
  
  @override
  String toString() => 'StorageManagerException: $message';
}

// Riverpod Providers

/// 儲存管理器 Provider
final storageManagerProvider = Provider<StorageManager>((ref) {
  return StorageManager.instance;
});

/// Hive 儲存服務 Provider
final hiveStorageProvider = Provider<HiveStorageService>((ref) {
  final storageManager = ref.watch(storageManagerProvider);
  return storageManager.hiveStorage;
});

/// 安全儲存服務 Provider
final secureStorageProvider = Provider<FlutterSecureStorageService>((ref) {
  final storageManager = ref.watch(storageManagerProvider);
  return storageManager.secureStorage;
});

/// 同步服務 Provider
final syncServiceProvider = Provider<SyncServiceImpl>((ref) {
  final storageManager = ref.watch(storageManagerProvider);
  return storageManager.syncService;
});

/// 行程 Repository Provider
final tripRepositoryProvider = Provider<TripRepositoryImpl>((ref) {
  final storageManager = ref.watch(storageManagerProvider);
  return storageManager.tripRepository;
});

/// 使用者 Repository Provider
final userRepositoryProvider = Provider<UserRepositoryImpl>((ref) {
  final storageManager = ref.watch(storageManagerProvider);
  return storageManager.userRepository;
});

/// 儲存統計 Provider
final storageStatisticsProvider = FutureProvider<StorageStatistics>((ref) async {
  final storageManager = ref.watch(storageManagerProvider);
  return await storageManager.getStorageStatistics();
});