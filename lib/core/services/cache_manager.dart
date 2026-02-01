import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

import '../exceptions/app_exceptions.dart';
import '../repositories/cache_repository.dart';
import 'logger_service.dart';

class CacheManager implements CacheRepository {
  final HiveInterface _hive;
  final LoggerService _logger;
  
  static const String _cacheBoxName = 'app_cache';
  static const String _metadataBoxName = 'cache_metadata';
  
  Box? _cacheBox;
  Box? _metadataBox;
  
  CacheManager(this._hive, this._logger);
  
  Future<void> initialize() async {
    try {
      _cacheBox = await _hive.openBox(_cacheBoxName);
      _metadataBox = await _hive.openBox(_metadataBoxName);
      _logger.info('Cache manager initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize cache manager', e);
      throw CacheException('快取系統初始化失敗');
    }
  }
  
  /// Store data in cache with optional TTL
  @override
  Future<void> set<T>(String key, T value, {Duration? ttl}) async {
    try {
      if (_cacheBox == null) {
        throw CacheException('快取系統尚未初始化');
      }
      
      // Store the actual data
      final serializedValue = _serialize(value);
      await _cacheBox!.put(key, serializedValue);
      
      // Store metadata with expiration time
      if (ttl != null) {
        final expirationTime = DateTime.now().add(ttl).millisecondsSinceEpoch;
        await _metadataBox!.put(key, {
          'expiresAt': expirationTime,
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        });
      }
      
      _logger.debug('Cached data for key: $key');
    } catch (e) {
      _logger.error('Failed to cache data for key: $key', e);
      throw CacheException('資料快取失敗');
    }
  }
  
  /// Retrieve data from cache
  @override
  Future<T?> get<T>(String key) async {
    try {
      if (_cacheBox == null) {
        throw CacheException('快取系統尚未初始化');
      }
      
      // Check if data has expired
      if (await _isExpired(key)) {
        await remove(key);
        return null;
      }
      
      final serializedValue = _cacheBox!.get(key);
      if (serializedValue == null) return null;
      
      _logger.debug('Retrieved cached data for key: $key');
      return _deserialize<T>(serializedValue);
    } catch (e) {
      _logger.error('Failed to retrieve cached data for key: $key', e);
      return null;
    }
  }
  
  /// Remove data from cache
  @override
  Future<void> remove(String key) async {
    try {
      if (_cacheBox == null) return;
      
      await _cacheBox!.delete(key);
      await _metadataBox?.delete(key);
      
      _logger.debug('Removed cached data for key: $key');
    } catch (e) {
      _logger.error('Failed to remove cached data for key: $key', e);
    }
  }
  
  /// Clear all cached data
  @override
  Future<void> clear() async {
    try {
      if (_cacheBox == null) return;
      
      await _cacheBox!.clear();
      await _metadataBox?.clear();
      
      _logger.info('Cleared all cached data');
    } catch (e) {
      _logger.error('Failed to clear cache', e);
      throw CacheException('清除快取失敗');
    }
  }
  
  /// Check if cached data exists and is not expired
  @override
  Future<bool> contains(String key) async {
    try {
      if (_cacheBox == null) return false;
      
      if (await _isExpired(key)) {
        await remove(key);
        return false;
      }
      
      return _cacheBox!.containsKey(key);
    } catch (e) {
      _logger.error('Failed to check cache for key: $key', e);
      return false;
    }
  }
  
  /// Get cache size in bytes (approximate)
  @override
  Future<int> getCacheSize() async {
    try {
      if (_cacheBox == null) return 0;
      
      int totalSize = 0;
      for (final key in _cacheBox!.keys) {
        final value = _cacheBox!.get(key);
        if (value is String) {
          totalSize += value.length;
        }
      }
      
      return totalSize;
    } catch (e) {
      _logger.error('Failed to calculate cache size', e);
      return 0;
    }
  }
  
  /// Clean up expired entries
  @override
  Future<void> cleanupExpired() async {
    try {
      if (_cacheBox == null || _metadataBox == null) return;
      
      final now = DateTime.now().millisecondsSinceEpoch;
      final expiredKeys = <String>[];
      
      for (final key in _metadataBox!.keys) {
        final metadata = _metadataBox!.get(key) as Map?;
        if (metadata != null) {
          final expiresAt = metadata['expiresAt'] as int?;
          if (expiresAt != null && expiresAt < now) {
            expiredKeys.add(key.toString());
          }
        }
      }
      
      for (final key in expiredKeys) {
        await remove(key);
      }
      
      if (expiredKeys.isNotEmpty) {
        _logger.info('Cleaned up ${expiredKeys.length} expired cache entries');
      }
    } catch (e) {
      _logger.error('Failed to cleanup expired cache entries', e);
    }
  }
  
  /// Get cache statistics
  @override
  Future<CacheStats> getStats() async {
    try {
      if (_cacheBox == null || _metadataBox == null) {
        return CacheStats(
          totalEntries: 0,
          expiredEntries: 0,
          sizeInBytes: 0,
          lastCleanup: DateTime.now(),
        );
      }
      
      final now = DateTime.now().millisecondsSinceEpoch;
      int expiredCount = 0;
      
      for (final key in _metadataBox!.keys) {
        final metadata = _metadataBox!.get(key) as Map?;
        if (metadata != null) {
          final expiresAt = metadata['expiresAt'] as int?;
          if (expiresAt != null && expiresAt < now) {
            expiredCount++;
          }
        }
      }
      
      final sizeInBytes = await getCacheSize();
      
      return CacheStats(
        totalEntries: _cacheBox!.length,
        expiredEntries: expiredCount,
        sizeInBytes: sizeInBytes,
        lastCleanup: DateTime.now(),
      );
    } catch (e) {
      _logger.error('Failed to get cache stats', e);
      return CacheStats(
        totalEntries: 0,
        expiredEntries: 0,
        sizeInBytes: 0,
        lastCleanup: DateTime.now(),
      );
    }
  }
  
  Future<bool> _isExpired(String key) async {
    try {
      if (_metadataBox == null) return false;
      
      final metadata = _metadataBox!.get(key) as Map?;
      if (metadata == null) return false;
      
      final expiresAt = metadata['expiresAt'] as int?;
      if (expiresAt == null) return false;
      
      return DateTime.now().millisecondsSinceEpoch > expiresAt;
    } catch (e) {
      _logger.error('Failed to check expiration for key: $key', e);
      return false;
    }
  }
  
  String _serialize<T>(T value) {
    if (value is String) return value;
    if (value is num || value is bool) return value.toString();
    return jsonEncode(value);
  }
  
  T? _deserialize<T>(dynamic value) {
    if (value is T) return value;
    if (value is String) {
      if (T == String) return value as T;
      try {
        return jsonDecode(value) as T;
      } catch (e) {
        return value as T;
      }
    }
    return value as T?;
  }
}