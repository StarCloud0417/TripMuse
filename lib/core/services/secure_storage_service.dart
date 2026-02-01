import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../exceptions/app_exceptions.dart';
import 'logger_service.dart';

/// Service for secure storage of sensitive data
class SecureStorageService {
  final FlutterSecureStorage _secureStorage;
  final LoggerService _logger;
  
  // Storage keys
  static const String _jwtTokenKey = 'jwt_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _googleTokenKey = 'google_token';
  
  SecureStorageService(this._secureStorage, this._logger);
  
  /// Store JWT token
  Future<void> storeJwtToken(String token) async {
    try {
      await _secureStorage.write(key: _jwtTokenKey, value: token);
      _logger.debug('JWT token stored securely');
    } catch (e) {
      _logger.error('Failed to store JWT token', e);
      throw StorageException('JWT token 儲存失敗');
    }
  }
  
  /// Get JWT token
  Future<String?> getJwtToken() async {
    try {
      final token = await _secureStorage.read(key: _jwtTokenKey);
      if (token != null) {
        _logger.debug('JWT token retrieved from secure storage');
      }
      return token;
    } catch (e) {
      _logger.error('Failed to retrieve JWT token', e);
      return null;
    }
  }
  
  /// Store refresh token
  Future<void> storeRefreshToken(String token) async {
    try {
      await _secureStorage.write(key: _refreshTokenKey, value: token);
      _logger.debug('Refresh token stored securely');
    } catch (e) {
      _logger.error('Failed to store refresh token', e);
      throw StorageException('Refresh token 儲存失敗');
    }
  }
  
  /// Get refresh token
  Future<String?> getRefreshToken() async {
    try {
      final token = await _secureStorage.read(key: _refreshTokenKey);
      if (token != null) {
        _logger.debug('Refresh token retrieved from secure storage');
      }
      return token;
    } catch (e) {
      _logger.error('Failed to retrieve refresh token', e);
      return null;
    }
  }
  
  /// Store user ID
  Future<void> storeUserId(String userId) async {
    try {
      await _secureStorage.write(key: _userIdKey, value: userId);
      _logger.debug('User ID stored securely');
    } catch (e) {
      _logger.error('Failed to store user ID', e);
      throw StorageException('User ID 儲存失敗');
    }
  }
  
  /// Get user ID
  Future<String?> getUserId() async {
    try {
      final userId = await _secureStorage.read(key: _userIdKey);
      if (userId != null) {
        _logger.debug('User ID retrieved from secure storage');
      }
      return userId;
    } catch (e) {
      _logger.error('Failed to retrieve user ID', e);
      return null;
    }
  }
  
  /// Store Google token
  Future<void> storeGoogleToken(String token) async {
    try {
      await _secureStorage.write(key: _googleTokenKey, value: token);
      _logger.debug('Google token stored securely');
    } catch (e) {
      _logger.error('Failed to store Google token', e);
      throw StorageException('Google token 儲存失敗');
    }
  }
  
  /// Get Google token
  Future<String?> getGoogleToken() async {
    try {
      final token = await _secureStorage.read(key: _googleTokenKey);
      if (token != null) {
        _logger.debug('Google token retrieved from secure storage');
      }
      return token;
    } catch (e) {
      _logger.error('Failed to retrieve Google token', e);
      return null;
    }
  }
  
  /// Store encrypted data
  Future<void> storeEncrypted<T>(String key, T data) async {
    try {
      final jsonString = jsonEncode(data);
      await _secureStorage.write(key: key, value: jsonString);
      _logger.debug('Encrypted data stored for key: $key');
    } catch (e) {
      _logger.error('Failed to store encrypted data for key: $key', e);
      throw StorageException('加密資料儲存失敗');
    }
  }
  
  /// Get encrypted data
  Future<T?> getEncrypted<T>(String key) async {
    try {
      final jsonString = await _secureStorage.read(key: key);
      if (jsonString == null) return null;
      
      final data = jsonDecode(jsonString) as T;
      _logger.debug('Encrypted data retrieved for key: $key');
      return data;
    } catch (e) {
      _logger.error('Failed to retrieve encrypted data for key: $key', e);
      return null;
    }
  }
  
  /// Check if key exists
  Future<bool> containsKey(String key) async {
    try {
      return await _secureStorage.containsKey(key: key);
    } catch (e) {
      _logger.error('Failed to check key existence: $key', e);
      return false;
    }
  }
  
  /// Delete specific key
  Future<void> delete(String key) async {
    try {
      await _secureStorage.delete(key: key);
      _logger.debug('Deleted secure storage key: $key');
    } catch (e) {
      _logger.error('Failed to delete key: $key', e);
      throw StorageException('安全儲存刪除失敗');
    }
  }
  
  /// Clear all secure storage
  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
      _logger.info('Cleared all secure storage');
    } catch (e) {
      _logger.error('Failed to clear secure storage', e);
      throw StorageException('清除安全儲存失敗');
    }
  }
  
  /// Get all stored keys
  Future<Map<String, String>> getAllData() async {
    try {
      final allData = await _secureStorage.readAll();
      _logger.debug('Retrieved all secure storage data');
      return allData;
    } catch (e) {
      _logger.error('Failed to retrieve all secure storage data', e);
      return {};
    }
  }
  
  /// Check if user is authenticated (has valid tokens)
  Future<bool> isAuthenticated() async {
    try {
      final jwtToken = await getJwtToken();
      final userId = await getUserId();
      return jwtToken != null && userId != null;
    } catch (e) {
      _logger.error('Failed to check authentication status', e);
      return false;
    }
  }
  
  /// Clear authentication data
  Future<void> clearAuthData() async {
    try {
      await Future.wait([
        delete(_jwtTokenKey),
        delete(_refreshTokenKey),
        delete(_userIdKey),
        delete(_googleTokenKey),
      ]);
      _logger.info('Cleared authentication data');
    } catch (e) {
      _logger.error('Failed to clear authentication data', e);
      throw StorageException('清除認證資料失敗');
    }
  }
}