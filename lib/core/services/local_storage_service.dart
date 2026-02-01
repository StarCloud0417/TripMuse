import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../exceptions/app_exceptions.dart';
import '../storage/hive_adapters.dart';
import 'logger_service.dart';

/// Service for managing local storage using Hive
class LocalStorageService {
  final LoggerService _logger;
  
  // Box names
  static const String _tripsBoxName = 'trips';
  static const String _usersBoxName = 'users';
  static const String _cacheBoxName = 'app_cache';
  static const String _metadataBoxName = 'cache_metadata';
  static const String _syncQueueBoxName = 'sync_queue';
  
  // Boxes
  Box? _tripsBox;
  Box? _usersBox;
  Box? _cacheBox;
  Box? _metadataBox;
  Box? _syncQueueBox;
  
  bool _isInitialized = false;
  
  LocalStorageService(this._logger);
  
  /// Initialize Hive and open all required boxes
  Future<void> initialize() async {
    if (_isInitialized) {
      _logger.warning('Local storage already initialized');
      return;
    }
    
    try {
      // Initialize Hive
      await Hive.initFlutter();
      
      // Register all type adapters
      HiveAdapters.registerAdapters();
      
      // Open all boxes
      await Future.wait([
        _openBox(_tripsBoxName).then((box) => _tripsBox = box),
        _openBox(_usersBoxName).then((box) => _usersBox = box),
        _openBox(_cacheBoxName).then((box) => _cacheBox = box),
        _openBox(_metadataBoxName).then((box) => _metadataBox = box),
        _openBox(_syncQueueBoxName).then((box) => _syncQueueBox = box),
      ]);
      
      _isInitialized = true;
      _logger.info('Local storage initialized successfully');
      
      // Log storage statistics
      await _logStorageStats();
      
    } catch (e) {
      _logger.error('Failed to initialize local storage', e);
      throw StorageException('本地儲存初始化失敗: ${e.toString()}');
    }
  }
  
  /// Get trips box
  Box get tripsBox {
    _ensureInitialized();
    return _tripsBox!;
  }
  
  /// Get users box
  Box get usersBox {
    _ensureInitialized();
    return _usersBox!;
  }
  
  /// Get cache box
  Box get cacheBox {
    _ensureInitialized();
    return _cacheBox!;
  }
  
  /// Get metadata box
  Box get metadataBox {
    _ensureInitialized();
    return _metadataBox!;
  }
  
  /// Get sync queue box
  Box get syncQueueBox {
    _ensureInitialized();
    return _syncQueueBox!;
  }
  
  /// Check if storage is initialized
  bool get isInitialized => _isInitialized;
  
  /// Get storage directory path
  Future<String> getStoragePath() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } catch (e) {
      _logger.error('Failed to get storage path', e);
      throw StorageException('無法取得儲存路徑');
    }
  }
  
  /// Get storage size in bytes
  Future<int> getStorageSize() async {
    try {
      final storagePath = await getStoragePath();
      final hiveDir = Directory('$storagePath/hive');
      
      if (!await hiveDir.exists()) return 0;
      
      int totalSize = 0;
      await for (final entity in hiveDir.list(recursive: true)) {
        if (entity is File) {
          final stat = await entity.stat();
          totalSize += stat.size;
        }
      }
      
      return totalSize;
    } catch (e) {
      _logger.error('Failed to calculate storage size', e);
      return 0;
    }
  }
  
  /// Clear all data from a specific box
  Future<void> clearBox(String boxName) async {
    try {
      _ensureInitialized();
      
      final box = await _openBox(boxName);
      await box.clear();
      
      _logger.info('Cleared box: $boxName');
    } catch (e) {
      _logger.error('Failed to clear box: $boxName', e);
      throw StorageException('清除資料失敗: $boxName');
    }
  }
  
  /// Clear all storage data
  Future<void> clearAllData() async {
    try {
      _ensureInitialized();
      
      await Future.wait([
        _tripsBox?.clear() ?? Future.value(),
        _usersBox?.clear() ?? Future.value(),
        _cacheBox?.clear() ?? Future.value(),
        _metadataBox?.clear() ?? Future.value(),
        _syncQueueBox?.clear() ?? Future.value(),
      ]);
      
      _logger.info('Cleared all local storage data');
    } catch (e) {
      _logger.error('Failed to clear all data', e);
      throw StorageException('清除所有資料失敗');
    }
  }
  
  /// Compact all boxes to optimize storage
  Future<void> compactStorage() async {
    try {
      _ensureInitialized();
      
      await Future.wait([
        _tripsBox?.compact() ?? Future.value(),
        _usersBox?.compact() ?? Future.value(),
        _cacheBox?.compact() ?? Future.value(),
        _metadataBox?.compact() ?? Future.value(),
        _syncQueueBox?.compact() ?? Future.value(),
      ]);
      
      _logger.info('Storage compaction completed');
    } catch (e) {
      _logger.error('Failed to compact storage', e);
      throw StorageException('儲存壓縮失敗');
    }
  }
  
  /// Close all boxes and cleanup
  Future<void> dispose() async {
    try {
      if (!_isInitialized) return;
      
      await Future.wait([
        _tripsBox?.close() ?? Future.value(),
        _usersBox?.close() ?? Future.value(),
        _cacheBox?.close() ?? Future.value(),
        _metadataBox?.close() ?? Future.value(),
        _syncQueueBox?.close() ?? Future.value(),
      ]);
      
      _isInitialized = false;
      _logger.info('Local storage disposed');
    } catch (e) {
      _logger.error('Failed to dispose local storage', e);
    }
  }
  
  /// Backup data to external storage
  Future<String> backupData() async {
    try {
      _ensureInitialized();
      
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final backupPath = await getStoragePath();
      final backupFile = File('$backupPath/backup_$timestamp.json');
      
      final backupData = {
        'timestamp': timestamp,
        'trips': _tripsBox?.toMap() ?? {},
        'users': _usersBox?.toMap() ?? {},
        'cache': _cacheBox?.toMap() ?? {},
        'metadata': _metadataBox?.toMap() ?? {},
        'syncQueue': _syncQueueBox?.toMap() ?? {},
      };
      
      await backupFile.writeAsString(backupData.toString());
      
      _logger.info('Data backup created: ${backupFile.path}');
      return backupFile.path;
    } catch (e) {
      _logger.error('Failed to backup data', e);
      throw StorageException('資料備份失敗');
    }
  }
  
  /// Get storage statistics
  Future<StorageStats> getStorageStats() async {
    try {
      _ensureInitialized();
      
      final totalSize = await getStorageSize();
      
      return StorageStats(
        totalSizeBytes: totalSize,
        tripsCount: _tripsBox?.length ?? 0,
        usersCount: _usersBox?.length ?? 0,
        cacheEntriesCount: _cacheBox?.length ?? 0,
        syncQueueCount: _syncQueueBox?.length ?? 0,
        lastCompacted: DateTime.now(), // This would be stored in metadata in real implementation
      );
    } catch (e) {
      _logger.error('Failed to get storage stats', e);
      return StorageStats.empty();
    }
  }
  
  Future<Box> _openBox(String boxName) async {
    try {
      return await Hive.openBox(boxName);
    } catch (e) {
      _logger.error('Failed to open box: $boxName', e);
      throw StorageException('無法開啟資料庫: $boxName');
    }
  }
  
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StorageException('本地儲存尚未初始化');
    }
  }
  
  Future<void> _logStorageStats() async {
    try {
      final stats = await getStorageStats();
      _logger.info('Storage Stats - '
          'Size: ${(stats.totalSizeBytes / 1024).toStringAsFixed(2)} KB, '
          'Trips: ${stats.tripsCount}, '
          'Users: ${stats.usersCount}, '
          'Cache: ${stats.cacheEntriesCount}');
    } catch (e) {
      _logger.error('Failed to log storage stats', e);
    }
  }
}

/// Storage statistics model
class StorageStats {
  final int totalSizeBytes;
  final int tripsCount;
  final int usersCount;
  final int cacheEntriesCount;
  final int syncQueueCount;
  final DateTime lastCompacted;
  
  const StorageStats({
    required this.totalSizeBytes,
    required this.tripsCount,
    required this.usersCount,
    required this.cacheEntriesCount,
    required this.syncQueueCount,
    required this.lastCompacted,
  });
  
  factory StorageStats.empty() => StorageStats(
    totalSizeBytes: 0,
    tripsCount: 0,
    usersCount: 0,
    cacheEntriesCount: 0,
    syncQueueCount: 0,
    lastCompacted: DateTime.now(),
  );
  
  double get totalSizeKB => totalSizeBytes / 1024;
  double get totalSizeMB => totalSizeKB / 1024;
}