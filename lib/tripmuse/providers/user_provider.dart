/// TripMuse 使用者狀態管理
/// 
/// 提供使用者認證狀態和偏好設定管理

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/services.dart';
import '../models/models.dart';

/// 使用者 Repository Provider（從 StorageManager 取得）
final userRepositoryProvider = Provider<UserRepositoryImpl>((ref) {
  final storageManager = ref.watch(storageManagerProvider);
  return storageManager.userRepository;
});

/// 當前使用者 Provider
final currentUserProvider = FutureProvider<User?>((ref) async {
  final userRepository = ref.watch(userRepositoryProvider);
  return await userRepository.getCurrentUser();
});

/// 使用者登入狀態 Provider
final isSignedInProvider = FutureProvider<bool>((ref) async {
  final userRepository = ref.watch(userRepositoryProvider);
  return await userRepository.isSignedIn();
});

/// 是否為訪客模式 Provider
final isGuestModeProvider = FutureProvider<bool>((ref) async {
  final userRepository = ref.watch(userRepositoryProvider);
  return await userRepository.isGuestMode();
});

/// 使用者偏好設定 Provider
final userPreferencesProvider = FutureProvider<UserPreferences>((ref) async {
  final userRepository = ref.watch(userRepositoryProvider);
  return await userRepository.getUserPreferences();
});

/// 使用者偏好設定 Notifier
class UserPreferencesNotifier extends StateNotifier<AsyncValue<UserPreferences>> {
  UserPreferencesNotifier(this._userRepository) : super(const AsyncValue.loading()) {
    _loadPreferences();
  }
  
  final UserRepositoryImpl _userRepository;
  
  /// 載入使用者偏好設定
  Future<void> _loadPreferences() async {
    try {
      final preferences = await _userRepository.getUserPreferences();
      state = AsyncValue.data(preferences);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 更新語言設定
  Future<void> updateLanguage(String language) async {
    final currentPrefs = state.value;
    if (currentPrefs == null) return;
    
    try {
      final updatedPrefs = currentPrefs.copyWith(
        language: language,
        updatedAt: DateTime.now(),
      );
      await _userRepository.saveUserPreferences(updatedPrefs);
      state = AsyncValue.data(updatedPrefs);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 更新主題設定
  Future<void> updateTheme(String theme) async {
    final currentPrefs = state.value;
    if (currentPrefs == null) return;
    
    try {
      final updatedPrefs = currentPrefs.copyWith(
        theme: theme,
        updatedAt: DateTime.now(),
      );
      await _userRepository.saveUserPreferences(updatedPrefs);
      state = AsyncValue.data(updatedPrefs);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 更新貨幣設定
  Future<void> updateCurrency(String currency) async {
    final currentPrefs = state.value;
    if (currentPrefs == null) return;
    
    try {
      final updatedPrefs = currentPrefs.copyWith(
        defaultCurrency: currency,
        updatedAt: DateTime.now(),
      );
      await _userRepository.saveUserPreferences(updatedPrefs);
      state = AsyncValue.data(updatedPrefs);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 更新地圖樣式設定
  Future<void> updateMapStyle(String mapStyle) async {
    final currentPrefs = state.value;
    if (currentPrefs == null) return;
    
    try {
      final updatedPrefs = currentPrefs.copyWith(
        defaultMapStyle: mapStyle,
        updatedAt: DateTime.now(),
      );
      await _userRepository.saveUserPreferences(updatedPrefs);
      state = AsyncValue.data(updatedPrefs);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 更新通知設定
  Future<void> updateNotifications(bool enabled) async {
    final currentPrefs = state.value;
    if (currentPrefs == null) return;
    
    try {
      final updatedPrefs = currentPrefs.copyWith(
        enableNotifications: enabled,
        updatedAt: DateTime.now(),
      );
      await _userRepository.saveUserPreferences(updatedPrefs);
      state = AsyncValue.data(updatedPrefs);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 更新位置追蹤設定
  Future<void> updateLocationTracking(bool enabled) async {
    final currentPrefs = state.value;
    if (currentPrefs == null) return;
    
    try {
      final updatedPrefs = currentPrefs.copyWith(
        enableLocationTracking: enabled,
        updatedAt: DateTime.now(),
      );
      await _userRepository.saveUserPreferences(updatedPrefs);
      state = AsyncValue.data(updatedPrefs);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 更新離線模式設定
  Future<void> updateOfflineMode(bool enabled) async {
    final currentPrefs = state.value;
    if (currentPrefs == null) return;
    
    try {
      final updatedPrefs = currentPrefs.copyWith(
        enableOfflineMode: enabled,
        updatedAt: DateTime.now(),
      );
      await _userRepository.saveUserPreferences(updatedPrefs);
      state = AsyncValue.data(updatedPrefs);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 重設為預設設定
  Future<void> resetToDefaults() async {
    try {
      final defaultPrefs = UserPreferences.defaultPreferences();
      await _userRepository.saveUserPreferences(defaultPrefs);
      state = AsyncValue.data(defaultPrefs);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// 使用者偏好設定 Notifier Provider
final userPreferencesNotifierProvider = StateNotifierProvider<UserPreferencesNotifier, AsyncValue<UserPreferences>>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return UserPreferencesNotifier(userRepository);
});

/// 使用者認證 Notifier
class UserAuthNotifier extends StateNotifier<AsyncValue<User?>> {
  UserAuthNotifier(this._userRepository) : super(const AsyncValue.loading()) {
    _loadCurrentUser();
  }
  
  final UserRepositoryImpl _userRepository;
  
  /// 載入當前使用者
  Future<void> _loadCurrentUser() async {
    try {
      final user = await _userRepository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 以訪客模式繼續
  Future<void> continueAsGuest() async {
    try {
      state = const AsyncValue.loading();
      final guestUser = await _userRepository.continueAsGuest();
      state = AsyncValue.data(guestUser);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// Google 登入
  Future<void> signInWithGoogle() async {
    try {
      state = const AsyncValue.loading();
      final user = await _userRepository.signInWithGoogle();
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 登出
  Future<void> signOut() async {
    try {
      await _userRepository.signOut();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 更新使用者資料
  Future<void> updateUser(User user) async {
    try {
      await _userRepository.updateUser(user);
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  /// 刪除使用者帳號
  Future<void> deleteUser() async {
    try {
      await _userRepository.deleteUser();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// 使用者認證 Notifier Provider
final userAuthNotifierProvider = StateNotifierProvider<UserAuthNotifier, AsyncValue<User?>>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return UserAuthNotifier(userRepository);
});

/// 主題模式 Provider（基於使用者偏好）
final themeModeProvider = Provider<String>((ref) {
  final preferencesAsync = ref.watch(userPreferencesNotifierProvider);
  return preferencesAsync.when(
    data: (preferences) => preferences.theme,
    loading: () => 'system',
    error: (_, __) => 'system',
  );
});

/// 語言 Provider（基於使用者偏好）
final languageProvider = Provider<String>((ref) {
  final preferencesAsync = ref.watch(userPreferencesNotifierProvider);
  return preferencesAsync.when(
    data: (preferences) => preferences.language,
    loading: () => 'zh-TW',
    error: (_, __) => 'zh-TW',
  );
});