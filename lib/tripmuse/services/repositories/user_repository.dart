/// 使用者資料存取層
/// 
/// 實作使用者資料的 CRUD 操作和認證管理

import '../storage/storage_service.dart';

/// 使用者資料模型
class User {
  final String id;
  final String? googleId;
  final String email;
  final String name;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isGuest;
  
  const User({
    required this.id,
    this.googleId,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isGuest = false,
  });
  
  /// 從 JSON 建立使用者
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      googleId: json['googleId'] as String?,
      email: json['email'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isGuest: json['isGuest'] as bool? ?? false,
    );
  }
  
  /// 轉換為 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'googleId': googleId,
      'email': email,
      'name': name,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isGuest': isGuest,
    };
  }
  
  /// 建立訪客使用者
  factory User.guest() {
    final now = DateTime.now();
    return User(
      id: 'guest_${now.millisecondsSinceEpoch}',
      email: 'guest@tripmuse.local',
      name: '訪客使用者',
      createdAt: now,
      updatedAt: now,
      isGuest: true,
    );
  }
  
  /// 複製並更新使用者資料
  User copyWith({
    String? id,
    String? googleId,
    String? email,
    String? name,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isGuest,
  }) {
    return User(
      id: id ?? this.id,
      googleId: googleId ?? this.googleId,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}

/// 使用者 Repository 介面
abstract class UserRepository {
  /// 取得當前使用者
  Future<User?> getCurrentUser();
  
  /// 儲存使用者資料
  Future<void> saveUser(User user);
  
  /// 使用 Google 登入
  Future<User> signInWithGoogle();
  
  /// 以訪客模式繼續
  Future<User> continueAsGuest();
  
  /// 登出
  Future<void> signOut();
  
  /// 檢查是否已登入
  Future<bool> isSignedIn();
  
  /// 檢查是否為訪客模式
  Future<bool> isGuestMode();
  
  /// 更新使用者資料
  Future<void> updateUser(User user);
  
  /// 刪除使用者資料
  Future<void> deleteUser();
}

/// 使用者 Repository 實作
class UserRepositoryImpl implements UserRepository {
  final HiveStorageService _localStorage;
  final FlutterSecureStorageService _secureStorage;
  
  User? _currentUser;
  
  UserRepositoryImpl({
    required HiveStorageService localStorage,
    required FlutterSecureStorageService secureStorage,
  }) : _localStorage = localStorage,
       _secureStorage = secureStorage;
  
  @override
  Future<User?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;
    
    try {
      // 從本地儲存讀取使用者資料
      final userData = await _localStorage.retrieve<Map<String, dynamic>>(StorageKeys.userId);
      if (userData != null) {
        _currentUser = User.fromJson(userData);
        return _currentUser;
      }
      
      // 檢查是否有儲存的認證 token
      final hasToken = await _secureStorage.existsSecure(StorageKeys.jwtToken);
      if (hasToken) {
        // 嘗試從 token 恢復使用者資訊
        // 這裡可以實作 JWT token 解析或呼叫 API 驗證
        // 暫時返回 null，需要重新登入
      }
      
      return null;
    } catch (e) {
      throw UserRepositoryException('取得當前使用者失敗: $e');
    }
  }
  
  @override
  Future<void> saveUser(User user) async {
    try {
      await _localStorage.store(StorageKeys.userId, user.toJson());
      _currentUser = user;
    } catch (e) {
      throw UserRepositoryException('儲存使用者資料失敗: $e');
    }
  }
  
  @override
  Future<User> signInWithGoogle() async {
    try {
      // 這裡應該整合 Google Sign-In
      // 暫時返回模擬的使用者資料
      final now = DateTime.now();
      final user = User(
        id: 'google_user_123',
        googleId: 'google_123456789',
        email: 'user@gmail.com',
        name: 'Google 使用者',
        avatarUrl: 'https://example.com/avatar.jpg',
        createdAt: now,
        updatedAt: now,
        isGuest: false,
      );
      
      await saveUser(user);
      
      // 儲存認證 token（模擬）
      await _secureStorage.storeSecure(StorageKeys.jwtToken, 'mock_jwt_token');
      await _secureStorage.storeSecure(StorageKeys.refreshToken, 'mock_refresh_token');
      
      return user;
    } catch (e) {
      throw UserRepositoryException('Google 登入失敗: $e');
    }
  }
  
  @override
  Future<User> continueAsGuest() async {
    try {
      final guestUser = User.guest();
      await saveUser(guestUser);
      return guestUser;
    } catch (e) {
      throw UserRepositoryException('訪客模式登入失敗: $e');
    }
  }
  
  @override
  Future<void> signOut() async {
    try {
      // 清除使用者資料
      await _localStorage.delete(StorageKeys.userId);
      
      // 清除認證 token
      await _secureStorage.deleteSecure(StorageKeys.jwtToken);
      await _secureStorage.deleteSecure(StorageKeys.refreshToken);
      await _secureStorage.deleteSecure(StorageKeys.googleAccessToken);
      
      _currentUser = null;
    } catch (e) {
      throw UserRepositoryException('登出失敗: $e');
    }
  }
  
  @override
  Future<bool> isSignedIn() async {
    try {
      final user = await getCurrentUser();
      return user != null;
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<bool> isGuestMode() async {
    try {
      final user = await getCurrentUser();
      return user?.isGuest ?? false;
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<void> updateUser(User user) async {
    try {
      final updatedUser = user.copyWith(updatedAt: DateTime.now());
      await saveUser(updatedUser);
    } catch (e) {
      throw UserRepositoryException('更新使用者資料失敗: $e');
    }
  }
  
  @override
  Future<void> deleteUser() async {
    try {
      await signOut();
      
      // 可以選擇是否刪除使用者的所有行程資料
      // await _localStorage.clear();
    } catch (e) {
      throw UserRepositoryException('刪除使用者失敗: $e');
    }
  }
  
  /// 取得使用者偏好設定
  Future<UserPreferences> getUserPreferences() async {
    try {
      final prefsData = await _localStorage.retrieve<Map<String, dynamic>>('user_preferences');
      if (prefsData != null) {
        return UserPreferences.fromJson(prefsData);
      }
      return UserPreferences.defaultPreferences();
    } catch (e) {
      return UserPreferences.defaultPreferences();
    }
  }
  
  /// 儲存使用者偏好設定
  Future<void> saveUserPreferences(UserPreferences preferences) async {
    try {
      await _localStorage.store('user_preferences', preferences.toJson());
    } catch (e) {
      throw UserRepositoryException('儲存使用者偏好失敗: $e');
    }
  }
}

/// 使用者偏好設定
class UserPreferences {
  final String language;
  final String theme;
  final bool enableNotifications;
  final bool enableLocationTracking;
  final bool enableOfflineMode;
  final String defaultCurrency;
  final String defaultMapStyle;
  
  const UserPreferences({
    required this.language,
    required this.theme,
    required this.enableNotifications,
    required this.enableLocationTracking,
    required this.enableOfflineMode,
    required this.defaultCurrency,
    required this.defaultMapStyle,
  });
  
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      language: json['language'] as String,
      theme: json['theme'] as String,
      enableNotifications: json['enableNotifications'] as bool,
      enableLocationTracking: json['enableLocationTracking'] as bool,
      enableOfflineMode: json['enableOfflineMode'] as bool,
      defaultCurrency: json['defaultCurrency'] as String,
      defaultMapStyle: json['defaultMapStyle'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'language': language,
      'theme': theme,
      'enableNotifications': enableNotifications,
      'enableLocationTracking': enableLocationTracking,
      'enableOfflineMode': enableOfflineMode,
      'defaultCurrency': defaultCurrency,
      'defaultMapStyle': defaultMapStyle,
    };
  }
  
  factory UserPreferences.defaultPreferences() {
    return const UserPreferences(
      language: 'zh-TW',
      theme: 'system',
      enableNotifications: true,
      enableLocationTracking: true,
      enableOfflineMode: true,
      defaultCurrency: 'TWD',
      defaultMapStyle: 'streets',
    );
  }
  
  UserPreferences copyWith({
    String? language,
    String? theme,
    bool? enableNotifications,
    bool? enableLocationTracking,
    bool? enableOfflineMode,
    String? defaultCurrency,
    String? defaultMapStyle,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableLocationTracking: enableLocationTracking ?? this.enableLocationTracking,
      enableOfflineMode: enableOfflineMode ?? this.enableOfflineMode,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      defaultMapStyle: defaultMapStyle ?? this.defaultMapStyle,
    );
  }
}

/// 使用者 Repository 例外
class UserRepositoryException implements Exception {
  final String message;
  
  const UserRepositoryException(this.message);
  
  @override
  String toString() => 'UserRepositoryException: $message';
}