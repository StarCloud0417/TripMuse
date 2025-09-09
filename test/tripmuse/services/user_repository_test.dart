/// TripMuse 使用者 Repository 測試
/// 
/// 測試使用者資料存取和認證功能

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../lib/tripmuse/services/services.dart';
import '../../../lib/tripmuse/models/models.dart';

void main() {
  group('UserRepository Tests', () {
    late UserRepositoryImpl userRepository;
    late HiveStorageService localStorage;
    late FlutterSecureStorageService secureStorage;

    setUpAll(() async {
      // 初始化 Hive 測試環境
      Hive.init('./test/hive_test_db');
      
      // 註冊 Hive 適配器
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(TripAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(DayPlanAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(ActivityAdapter());
      }
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(DestinationAdapter());
      }
      if (!Hive.isAdapterRegistered(4)) {
        Hive.registerAdapter(UserPreferenceAnalysisAdapter());
      }
    });

    setUp(() async {
      // 建立測試用的儲存服務
      localStorage = HiveStorageService();
      await localStorage.initialize();
      
      secureStorage = FlutterSecureStorageService();
      
      userRepository = UserRepositoryImpl(
        localStorage: localStorage,
        secureStorage: secureStorage,
      );
    });

    tearDown(() async {
      // 清理測試資料
      await localStorage.clear();
      await localStorage.dispose();
    });

    group('Guest User Tests', () {
      test('should create guest user successfully', () async {
        // Act
        final guestUser = await userRepository.continueAsGuest();
        
        // Assert
        expect(guestUser.isGuest, isTrue);
        expect(guestUser.name, equals('訪客使用者'));
        expect(guestUser.email, equals('guest@tripmuse.local'));
        expect(guestUser.id, startsWith('guest_'));
        expect(guestUser.googleId, isNull);
      });

      test('should save and retrieve guest user', () async {
        // Arrange
        final guestUser = await userRepository.continueAsGuest();
        
        // Act
        final retrievedUser = await userRepository.getCurrentUser();
        
        // Assert
        expect(retrievedUser, isNotNull);
        expect(retrievedUser!.id, equals(guestUser.id));
        expect(retrievedUser.isGuest, isTrue);
      });

      test('should check guest mode correctly', () async {
        // Arrange
        await userRepository.continueAsGuest();
        
        // Act
        final isGuest = await userRepository.isGuestMode();
        final isSignedIn = await userRepository.isSignedIn();
        
        // Assert
        expect(isGuest, isTrue);
        expect(isSignedIn, isTrue);
      });
    });

    group('Google User Tests', () {
      test('should create Google user successfully', () async {
        // Act
        final googleUser = await userRepository.signInWithGoogle();
        
        // Assert
        expect(googleUser.isGuest, isFalse);
        expect(googleUser.googleId, isNotNull);
        expect(googleUser.email, contains('@'));
        expect(googleUser.name, isNotEmpty);
      });

      test('should save and retrieve Google user', () async {
        // Arrange
        final googleUser = await userRepository.signInWithGoogle();
        
        // Act
        final retrievedUser = await userRepository.getCurrentUser();
        
        // Assert
        expect(retrievedUser, isNotNull);
        expect(retrievedUser!.id, equals(googleUser.id));
        expect(retrievedUser.isGuest, isFalse);
        expect(retrievedUser.googleId, equals(googleUser.googleId));
      });

      test('should check signed in status correctly', () async {
        // Arrange
        await userRepository.signInWithGoogle();
        
        // Act
        final isGuest = await userRepository.isGuestMode();
        final isSignedIn = await userRepository.isSignedIn();
        
        // Assert
        expect(isGuest, isFalse);
        expect(isSignedIn, isTrue);
      });
    });

    group('User Management Tests', () {
      test('should update user successfully', () async {
        // Arrange
        final originalUser = await userRepository.continueAsGuest();
        final updatedUser = originalUser.copyWith(
          name: '更新的使用者名稱',
        );
        
        // Act
        await userRepository.updateUser(updatedUser);
        final retrievedUser = await userRepository.getCurrentUser();
        
        // Assert
        expect(retrievedUser, isNotNull);
        expect(retrievedUser!.name, equals('更新的使用者名稱'));
        expect(retrievedUser.updatedAt.isAfter(originalUser.updatedAt), isTrue);
      });

      test('should sign out successfully', () async {
        // Arrange
        await userRepository.continueAsGuest();
        expect(await userRepository.isSignedIn(), isTrue);
        
        // Act
        await userRepository.signOut();
        
        // Assert
        expect(await userRepository.isSignedIn(), isFalse);
        expect(await userRepository.getCurrentUser(), isNull);
      });

      test('should delete user successfully', () async {
        // Arrange
        await userRepository.continueAsGuest();
        expect(await userRepository.isSignedIn(), isTrue);
        
        // Act
        await userRepository.deleteUser();
        
        // Assert
        expect(await userRepository.isSignedIn(), isFalse);
        expect(await userRepository.getCurrentUser(), isNull);
      });
    });

    group('User Preferences Tests', () {
      test('should return default preferences when none exist', () async {
        // Act
        final preferences = await userRepository.getUserPreferences();
        
        // Assert
        expect(preferences.language, equals('zh-TW'));
        expect(preferences.theme, equals('system'));
        expect(preferences.defaultCurrency, equals('TWD'));
        expect(preferences.defaultMapStyle, equals('streets'));
        expect(preferences.enableNotifications, isTrue);
        expect(preferences.enableLocationTracking, isTrue);
        expect(preferences.enableOfflineMode, isTrue);
      });

      test('should save and retrieve user preferences', () async {
        // Arrange
        final customPreferences = UserPreferences.defaultPreferences().copyWith(
          language: 'en-US',
          theme: 'dark',
          defaultCurrency: 'USD',
          enableNotifications: false,
        );
        
        // Act
        await userRepository.saveUserPreferences(customPreferences);
        final retrievedPreferences = await userRepository.getUserPreferences();
        
        // Assert
        expect(retrievedPreferences.language, equals('en-US'));
        expect(retrievedPreferences.theme, equals('dark'));
        expect(retrievedPreferences.defaultCurrency, equals('USD'));
        expect(retrievedPreferences.enableNotifications, isFalse);
        expect(retrievedPreferences.enableLocationTracking, isTrue);
      });
    });

    group('Error Handling Tests', () {
      test('should handle storage errors gracefully', () async {
        // Arrange
        await localStorage.dispose(); // 關閉儲存以模擬錯誤
        
        // Act & Assert
        expect(
          () => userRepository.getCurrentUser(),
          throwsA(isA<UserRepositoryException>()),
        );
      });
    });
  });
}