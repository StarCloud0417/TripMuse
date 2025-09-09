/// TripMuse 使用者模型
/// 
/// 支援 Guest 模式和 Google 登入，為 Firebase Authentication 預留介面

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    required bool isGuest,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? googleId,
    String? avatarUrl,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  
  /// 建立訪客使用者
  factory User.guest() {
    final now = DateTime.now();
    return User(
      id: 'guest_${now.millisecondsSinceEpoch}',
      name: '訪客使用者',
      email: 'guest@tripmuse.local',
      isGuest: true,
      createdAt: now,
      updatedAt: now,
    );
  }
  
  /// 建立 Google 使用者
  factory User.fromGoogle({
    required String googleId,
    required String email,
    required String name,
    String? avatarUrl,
  }) {
    final now = DateTime.now();
    return User(
      id: googleId,
      googleId: googleId,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
      isGuest: false,
      createdAt: now,
      updatedAt: now,
    );
  }
}

@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    required String language,
    required String theme,
    required String defaultCurrency,
    required String defaultMapStyle,
    required bool enableNotifications,
    required bool enableLocationTracking,
    required bool enableOfflineMode,
    required DateTime updatedAt,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) => 
      _$UserPreferencesFromJson(json);
  
  /// 預設偏好設定
  factory UserPreferences.defaultPreferences() {
    return UserPreferences(
      language: 'zh-TW',
      theme: 'system',
      defaultCurrency: 'TWD',
      defaultMapStyle: 'streets',
      enableNotifications: true,
      enableLocationTracking: true,
      enableOfflineMode: true,
      updatedAt: DateTime.now(),
    );
  }
}