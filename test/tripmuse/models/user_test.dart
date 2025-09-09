/// TripMuse 使用者模型測試
/// 
/// 測試使用者資料模型的建立和序列化功能

import 'package:flutter_test/flutter_test.dart';
import '../../../lib/tripmuse/models/models.dart';

void main() {
  group('User Model Tests', () {
    group('User Creation Tests', () {
      test('should create guest user successfully', () {
        // Act
        final guestUser = User.guest();
        
        // Assert
        expect(guestUser.isGuest, isTrue);
        expect(guestUser.name, equals('訪客使用者'));
        expect(guestUser.email, equals('guest@tripmuse.local'));
        expect(guestUser.id, startsWith('guest_'));
        expect(guestUser.googleId, isNull);
        expect(guestUser.avatarUrl, isNull);
      });

      test('should create Google user successfully', () {
        // Arrange
        const googleId = 'google_123456789';
        const email = 'test@gmail.com';
        const name = 'Test User';
        const avatarUrl = 'https://example.com/avatar.jpg';
        
        // Act
        final googleUser = User.fromGoogle(
          googleId: googleId,
          email: email,
          name: name,
          avatarUrl: avatarUrl,
        );
        
        // Assert
        expect(googleUser.isGuest, isFalse);
        expect(googleUser.googleId, equals(googleId));
        expect(googleUser.email, equals(email));
        expect(googleUser.name, equals(name));
        expect(googleUser.avatarUrl, equals(avatarUrl));
        expect(googleUser.id, equals(googleId));
      });

      test('should create Google user without avatar', () {
        // Arrange
        const googleId = 'google_987654321';
        const email = 'test2@gmail.com';
        const name = 'Test User 2';
        
        // Act
        final googleUser = User.fromGoogle(
          googleId: googleId,
          email: email,
          name: name,
        );
        
        // Assert
        expect(googleUser.isGuest, isFalse);
        expect(googleUser.googleId, equals(googleId));
        expect(googleUser.email, equals(email));
        expect(googleUser.name, equals(name));
        expect(googleUser.avatarUrl, isNull);
      });
    });

    group('User Serialization Tests', () {
      test('should serialize and deserialize guest user correctly', () {
        // Arrange
        final originalUser = User.guest();
        
        // Act
        final json = originalUser.toJson();
        final deserializedUser = User.fromJson(json);
        
        // Assert
        expect(deserializedUser.id, equals(originalUser.id));
        expect(deserializedUser.name, equals(originalUser.name));
        expect(deserializedUser.email, equals(originalUser.email));
        expect(deserializedUser.isGuest, equals(originalUser.isGuest));
        expect(deserializedUser.googleId, equals(originalUser.googleId));
        expect(deserializedUser.avatarUrl, equals(originalUser.avatarUrl));
        expect(deserializedUser.createdAt, equals(originalUser.createdAt));
        expect(deserializedUser.updatedAt, equals(originalUser.updatedAt));
      });

      test('should serialize and deserialize Google user correctly', () {
        // Arrange
        final originalUser = User.fromGoogle(
          googleId: 'google_test_123',
          email: 'test@gmail.com',
          name: 'Test User',
          avatarUrl: 'https://example.com/avatar.jpg',
        );
        
        // Act
        final json = originalUser.toJson();
        final deserializedUser = User.fromJson(json);
        
        // Assert
        expect(deserializedUser.id, equals(originalUser.id));
        expect(deserializedUser.name, equals(originalUser.name));
        expect(deserializedUser.email, equals(originalUser.email));
        expect(deserializedUser.isGuest, equals(originalUser.isGuest));
        expect(deserializedUser.googleId, equals(originalUser.googleId));
        expect(deserializedUser.avatarUrl, equals(originalUser.avatarUrl));
        expect(deserializedUser.createdAt, equals(originalUser.createdAt));
        expect(deserializedUser.updatedAt, equals(originalUser.updatedAt));
      });
    });

    group('User Modification Tests', () {
      test('should copy user with updated fields', () {
        // Arrange
        final originalUser = User.guest();
        const newName = '更新的使用者名稱';
        const newEmail = 'updated@example.com';
        final newUpdatedAt = DateTime.now().add(const Duration(seconds: 1));
        
        // Act
        final updatedUser = originalUser.copyWith(
          name: newName,
          email: newEmail,
          updatedAt: newUpdatedAt,
        );
        
        // Assert
        expect(updatedUser.id, equals(originalUser.id));
        expect(updatedUser.name, equals(newName));
        expect(updatedUser.email, equals(newEmail));
        expect(updatedUser.isGuest, equals(originalUser.isGuest));
        expect(updatedUser.googleId, equals(originalUser.googleId));
        expect(updatedUser.createdAt, equals(originalUser.createdAt));
        expect(updatedUser.updatedAt.isAfter(originalUser.updatedAt), isTrue);
      });
    });
  });

  group('UserPreferences Model Tests', () {
    group('UserPreferences Creation Tests', () {
      test('should create default preferences successfully', () {
        // Act
        final defaultPrefs = UserPreferences.defaultPreferences();
        
        // Assert
        expect(defaultPrefs.language, equals('zh-TW'));
        expect(defaultPrefs.theme, equals('system'));
        expect(defaultPrefs.defaultCurrency, equals('TWD'));
        expect(defaultPrefs.defaultMapStyle, equals('streets'));
        expect(defaultPrefs.enableNotifications, isTrue);
        expect(defaultPrefs.enableLocationTracking, isTrue);
        expect(defaultPrefs.enableOfflineMode, isTrue);
      });

      test('should create custom preferences successfully', () {
        // Arrange
        final now = DateTime.now();
        
        // Act
        final customPrefs = UserPreferences(
          language: 'en-US',
          theme: 'dark',
          defaultCurrency: 'USD',
          defaultMapStyle: 'satellite',
          enableNotifications: false,
          enableLocationTracking: false,
          enableOfflineMode: true,
          updatedAt: now,
        );
        
        // Assert
        expect(customPrefs.language, equals('en-US'));
        expect(customPrefs.theme, equals('dark'));
        expect(customPrefs.defaultCurrency, equals('USD'));
        expect(customPrefs.defaultMapStyle, equals('satellite'));
        expect(customPrefs.enableNotifications, isFalse);
        expect(customPrefs.enableLocationTracking, isFalse);
        expect(customPrefs.enableOfflineMode, isTrue);
        expect(customPrefs.updatedAt, equals(now));
      });
    });

    group('UserPreferences Serialization Tests', () {
      test('should serialize and deserialize preferences correctly', () {
        // Arrange
        final originalPrefs = UserPreferences.defaultPreferences();
        
        // Act
        final json = originalPrefs.toJson();
        final deserializedPrefs = UserPreferences.fromJson(json);
        
        // Assert
        expect(deserializedPrefs.language, equals(originalPrefs.language));
        expect(deserializedPrefs.theme, equals(originalPrefs.theme));
        expect(deserializedPrefs.defaultCurrency, equals(originalPrefs.defaultCurrency));
        expect(deserializedPrefs.defaultMapStyle, equals(originalPrefs.defaultMapStyle));
        expect(deserializedPrefs.enableNotifications, equals(originalPrefs.enableNotifications));
        expect(deserializedPrefs.enableLocationTracking, equals(originalPrefs.enableLocationTracking));
        expect(deserializedPrefs.enableOfflineMode, equals(originalPrefs.enableOfflineMode));
        expect(deserializedPrefs.updatedAt, equals(originalPrefs.updatedAt));
      });
    });

    group('UserPreferences Modification Tests', () {
      test('should copy preferences with updated fields', () {
        // Arrange
        final originalPrefs = UserPreferences.defaultPreferences();
        const newLanguage = 'ja-JP';
        const newTheme = 'light';
        final newUpdatedAt = DateTime.now();
        
        // Act
        final updatedPrefs = originalPrefs.copyWith(
          language: newLanguage,
          theme: newTheme,
          updatedAt: newUpdatedAt,
        );
        
        // Assert
        expect(updatedPrefs.language, equals(newLanguage));
        expect(updatedPrefs.theme, equals(newTheme));
        expect(updatedPrefs.defaultCurrency, equals(originalPrefs.defaultCurrency));
        expect(updatedPrefs.defaultMapStyle, equals(originalPrefs.defaultMapStyle));
        expect(updatedPrefs.enableNotifications, equals(originalPrefs.enableNotifications));
        expect(updatedPrefs.enableLocationTracking, equals(originalPrefs.enableLocationTracking));
        expect(updatedPrefs.enableOfflineMode, equals(originalPrefs.enableOfflineMode));
        expect(updatedPrefs.updatedAt, equals(newUpdatedAt));
      });
    });
  });
}