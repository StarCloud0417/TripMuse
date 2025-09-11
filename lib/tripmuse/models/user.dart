import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// 使用者資料模型
@freezed
class User with _$User {
  const factory User({
    /// 使用者唯一識別碼
    required String id,
    
    /// 使用者名稱
    required String name,
    
    /// 電子郵件
    required String email,
    
    /// 頭像 URL
    String? avatarUrl,
    
    /// Google ID（如果是 Google 登入）
    String? googleId,
    
    /// 是否為訪客模式
    @Default(false) bool isGuest,
    
    /// 建立時間
    required DateTime createdAt,
    
    /// 更新時間
    required DateTime updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  
  /// 建立 Google 登入使用者
  factory User.fromGoogle({
    required String googleId,
    required String email,
    required String name,
    String? avatarUrl,
  }) {
    final now = DateTime.now();
    return User(
      id: 'google_$googleId',
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      googleId: googleId,
      isGuest: false,
      createdAt: now,
      updatedAt: now,
    );
  }
  
  /// 建立訪客使用者
  factory User.guest() {
    final now = DateTime.now();
    final guestId = 'guest_${now.millisecondsSinceEpoch}';
    return User(
      id: guestId,
      name: '訪客',
      email: '',
      isGuest: true,
      createdAt: now,
      updatedAt: now,
    );
  }
}

/// 使用者偏好設定
@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    /// 偏好的語言
    @Default('zh-TW') String language,
    
    /// 主題設定
    @Default('system') String theme,
    
    /// 預設貨幣
    @Default('TWD') String defaultCurrency,
    
    /// 預設地圖樣式
    @Default('standard') String defaultMapStyle,
    
    /// 偏好的旅行節奏
    @Default('moderate') String travelPace,
    
    /// 偏好的預算範圍
    @Default('medium') String budgetRange,
    
    /// 偏好的旅行風格
    @Default('balanced') String travelStyle,
    
    /// 是否啟用推播通知
    @Default(true) bool enableNotifications,
    
    /// 是否啟用位置追蹤
    @Default(true) bool enableLocationTracking,
    
    /// 是否啟用離線模式
    @Default(true) bool enableOfflineMode,
    
    /// 是否自動同步
    @Default(true) bool autoSync,
    
    /// 建立時間
    required DateTime createdAt,
    
    /// 更新時間
    required DateTime updatedAt,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) => 
      _$UserPreferencesFromJson(json);
  
  /// 建立預設偏好設定
  factory UserPreferences.defaultPreferences() {
    final now = DateTime.now();
    return UserPreferences(
      createdAt: now,
      updatedAt: now,
    );
  }
}