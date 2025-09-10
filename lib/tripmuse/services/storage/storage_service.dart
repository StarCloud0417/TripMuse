/// 儲存服務介面定義
/// 
/// 定義 TripMuse 應用的儲存服務介面和實作

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/models.dart';
import 'hive_adapters.dart';

/// 儲存服務介面
abstract class StorageService {
  /// 初始化儲存服務
  Future<void> initialize();
  
  /// 清理儲存服務
  Future<void> dispose();
  
  /// 儲存資料
  Future<void> store<T>(String key, T value);
  
  /// 讀取資料
  Future<T?> retrieve<T>(String key);
  
  /// 刪除資料
  Future<void> delete(String key);
  
  /// 清空所有資料
  Future<void> clear();
  
  /// 檢查是否存在指定 key
  Future<bool> exists(String key);
  
  /// 取得所有 keys
  Future<List<String>> getAllKeys();
  
  /// 取得所有行程
  Future<List<Trip>> getAllTrips();
  
  /// 根據 ID 取得行程
  Future<Trip?> getTrip(String id);
  
  /// 儲存行程
  Future<void> saveTrip(Trip trip);
  
  /// 刪除行程
  Future<void> deleteTrip(String id);
}

/// 安全儲存服務介面（用於敏感資料）
abstract class SecureStorageService {
  /// 儲存敏感資料
  Future<void> storeSecure(String key, String value);
  
  /// 讀取敏感資料
  Future<String?> retrieveSecure(String key);
  
  /// 刪除敏感資料
  Future<void> deleteSecure(String key);
  
  /// 清空所有敏感資料
  Future<void> clearSecure();
  
  /// 檢查敏感資料是否存在
  Future<bool> existsSecure(String key);
}

/// Hive 儲存服務實作
class HiveStorageService implements StorageService {
  static const String _tripsBoxName = 'trips';
  static const String _settingsBoxName = 'settings';
  static const String _cacheBoxName = 'cache';
  
  Box<Trip>? _tripsBox;
  Box<dynamic>? _settingsBox;
  Box<dynamic>? _cacheBox;
  
  @override
  Future<void> initialize() async {
    // 初始化 Hive
    await Hive.initFlutter();
    
    // 註冊 TypeAdapter
    HiveAdapters.registerAdapters();
    
    // 開啟 Box
    _tripsBox = await Hive.openBox<Trip>(_tripsBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
    _cacheBox = await Hive.openBox(_cacheBoxName);
  }
  
  @override
  Future<void> dispose() async {
    await _tripsBox?.close();
    await _settingsBox?.close();
    await _cacheBox?.close();
  }
  
  @override
  Future<void> store<T>(String key, T value) async {
    if (T == Trip) {
      await _tripsBox?.put(key, value as Trip);
    } else {
      await _settingsBox?.put(key, value);
    }
  }
  
  @override
  Future<T?> retrieve<T>(String key) async {
    if (T == Trip) {
      return _tripsBox?.get(key) as T?;
    } else {
      return _settingsBox?.get(key) as T?;
    }
  }
  
  @override
  Future<void> delete(String key) async {
    await _tripsBox?.delete(key);
    await _settingsBox?.delete(key);
  }
  
  @override
  Future<void> clear() async {
    await _tripsBox?.clear();
    await _settingsBox?.clear();
    await _cacheBox?.clear();
  }
  
  @override
  Future<bool> exists(String key) async {
    return _tripsBox?.containsKey(key) == true || 
           _settingsBox?.containsKey(key) == true;
  }
  
  @override
  Future<List<String>> getAllKeys() async {
    final tripKeys = _tripsBox?.keys.cast<String>().toList() ?? [];
    final settingKeys = _settingsBox?.keys.cast<String>().toList() ?? [];
    return [...tripKeys, ...settingKeys];
  }
  
  /// 取得所有行程
  Future<List<Trip>> getAllTrips() async {
    return _tripsBox?.values.toList() ?? [];
  }
  
  /// 儲存行程
  Future<void> saveTrip(Trip trip) async {
    await _tripsBox?.put(trip.id, trip);
  }
  
  /// 取得行程
  Future<Trip?> getTrip(String tripId) async {
    return _tripsBox?.get(tripId);
  }
  
  /// 刪除行程
  Future<void> deleteTrip(String tripId) async {
    await _tripsBox?.delete(tripId);
  }
  
  /// 儲存快取資料
  Future<void> storeCache(String key, dynamic value, {Duration? ttl}) async {
    final cacheData = {
      'value': value,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'ttl': ttl?.inMilliseconds,
    };
    await _cacheBox?.put(key, cacheData);
  }
  
  /// 取得快取資料
  Future<T?> getCache<T>(String key) async {
    final cacheData = _cacheBox?.get(key);
    if (cacheData == null) return null;
    
    final timestamp = cacheData['timestamp'] as int?;
    final ttl = cacheData['ttl'] as int?;
    
    // 檢查是否過期
    if (timestamp != null && ttl != null) {
      final expireTime = timestamp + ttl;
      if (DateTime.now().millisecondsSinceEpoch > expireTime) {
        await _cacheBox?.delete(key);
        return null;
      }
    }
    
    return cacheData['value'] as T?;
  }
  
  /// 清理過期快取
  Future<void> cleanExpiredCache() async {
    final keys = _cacheBox?.keys.toList() ?? [];
    final now = DateTime.now().millisecondsSinceEpoch;
    
    for (final key in keys) {
      final cacheData = _cacheBox?.get(key);
      if (cacheData != null) {
        final timestamp = cacheData['timestamp'] as int?;
        final ttl = cacheData['ttl'] as int?;
        
        if (timestamp != null && ttl != null) {
          final expireTime = timestamp + ttl;
          if (now > expireTime) {
            await _cacheBox?.delete(key);
          }
        }
      }
    }
  }
}

/// Flutter Secure Storage 服務實作
class FlutterSecureStorageService implements SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
  
  @override
  Future<void> storeSecure(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
  
  @override
  Future<String?> retrieveSecure(String key) async {
    return await _storage.read(key: key);
  }
  
  @override
  Future<void> deleteSecure(String key) async {
    await _storage.delete(key: key);
  }
  
  @override
  Future<void> clearSecure() async {
    await _storage.deleteAll();
  }
  
  @override
  Future<bool> existsSecure(String key) async {
    final value = await _storage.read(key: key);
    return value != null;
  }
}

/// 儲存服務常數
class StorageKeys {
  // 使用者相關
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String userAvatarUrl = 'user_avatar_url';
  
  // 認證相關（敏感資料）
  static const String jwtToken = 'jwt_token';
  static const String refreshToken = 'refresh_token';
  static const String googleAccessToken = 'google_access_token';
  
  // 應用設定
  static const String appLanguage = 'app_language';
  static const String appTheme = 'app_theme';
  static const String isFirstLaunch = 'is_first_launch';
  static const String lastSyncTime = 'last_sync_time';
  
  // 快取相關
  static const String tripGenerationCache = 'trip_generation_cache_';
  static const String placesApiCache = 'places_api_cache_';
  static const String mapTileCache = 'map_tile_cache_';
}