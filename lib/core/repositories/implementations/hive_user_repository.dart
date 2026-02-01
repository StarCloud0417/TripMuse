import '../../exceptions/app_exceptions.dart';
import '../../models/user.dart';
import '../../services/local_storage_service.dart';
import '../../services/logger_service.dart';
import '../../services/secure_storage_service.dart';
import '../user_repository.dart';

/// Hive implementation of UserRepository
class HiveUserRepository implements UserRepository {
  final LocalStorageService _localStorage;
  final SecureStorageService _secureStorage;
  final LoggerService _logger;
  
  static const String _currentUserKey = 'current_user';
  
  HiveUserRepository(this._localStorage, this._secureStorage, this._logger);
  
  @override
  Future<List<User>> getAll() async {
    try {
      final users = _localStorage.usersBox.values.cast<User>().toList();
      _logger.debug('Retrieved ${users.length} users from local storage');
      return users;
    } catch (e) {
      _logger.error('Failed to get all users', e);
      throw StorageException('取得使用者列表失敗');
    }
  }
  
  @override
  Future<User?> getById(String id) async {
    try {
      final user = _localStorage.usersBox.get(id) as User?;
      if (user != null) {
        _logger.debug('Retrieved user: $id');
      }
      return user;
    } catch (e) {
      _logger.error('Failed to get user by id: $id', e);
      return null;
    }
  }
  
  @override
  Future<void> save(User user) async {
    try {
      await _localStorage.usersBox.put(user.id, user);
      _logger.debug('Saved user: ${user.id}');
    } catch (e) {
      _logger.error('Failed to save user: ${user.id}', e);
      throw StorageException('儲存使用者失敗');
    }
  }
  
  @override
  Future<void> delete(String id) async {
    try {
      await _localStorage.usersBox.delete(id);
      _logger.debug('Deleted user: $id');
      
      // Clear current user if it was deleted
      final currentUserId = await _secureStorage.getUserId();
      if (currentUserId == id) {
        await _secureStorage.clearAuthData();
        await _localStorage.usersBox.delete(_currentUserKey);
      }
    } catch (e) {
      _logger.error('Failed to delete user: $id', e);
      throw StorageException('刪除使用者失敗');
    }
  }
  
  @override
  Future<bool> exists(String id) async {
    try {
      return _localStorage.usersBox.containsKey(id);
    } catch (e) {
      _logger.error('Failed to check user existence: $id', e);
      return false;
    }
  }
  
  @override
  Future<void> clear() async {
    try {
      await _localStorage.usersBox.clear();
      await _secureStorage.clearAuthData();
      _logger.info('Cleared all users from local storage');
    } catch (e) {
      _logger.error('Failed to clear users', e);
      throw StorageException('清除使用者失敗');
    }
  }
  
  @override
  Future<User?> getCurrentUser() async {
    try {
      // First try to get from secure storage
      final userId = await _secureStorage.getUserId();
      if (userId != null) {
        final user = await getById(userId);
        if (user != null) {
          _logger.debug('Retrieved current user from secure storage: $userId');
          return user;
        }
      }
      
      // Fallback to local storage
      final user = _localStorage.usersBox.get(_currentUserKey) as User?;
      if (user != null) {
        _logger.debug('Retrieved current user from local storage: ${user.id}');
      }
      return user;
    } catch (e) {
      _logger.error('Failed to get current user', e);
      return null;
    }
  }
  
  @override
  Future<User> signInWithGoogle() async {
    try {
      // This would typically integrate with Google Sign-In
      // For now, we'll create a mock implementation
      throw UnimplementedError('Google Sign-In not implemented in repository layer');
    } catch (e) {
      _logger.error('Failed to sign in with Google', e);
      throw AuthException('Google 登入失敗');
    }
  }
  
  @override
  Future<void> signOut() async {
    try {
      // Clear secure storage
      await _secureStorage.clearAuthData();
      
      // Clear current user from local storage
      await _localStorage.usersBox.delete(_currentUserKey);
      
      _logger.info('User signed out successfully');
    } catch (e) {
      _logger.error('Failed to sign out', e);
      throw AuthException('登出失敗');
    }
  }
  
  @override
  Future<bool> isSignedIn() async {
    try {
      final isAuthenticated = await _secureStorage.isAuthenticated();
      final currentUser = await getCurrentUser();
      
      final signedIn = isAuthenticated && currentUser != null && !currentUser.isGuest;
      _logger.debug('User signed in status: $signedIn');
      return signedIn;
    } catch (e) {
      _logger.error('Failed to check sign in status', e);
      return false;
    }
  }
  
  @override
  Future<void> updateProfile(User user) async {
    try {
      final updatedUser = user.copyWith(
        updatedAt: DateTime.now(),
      );
      
      await save(updatedUser);
      
      // Update current user if it's the same user
      final currentUser = await getCurrentUser();
      if (currentUser?.id == user.id) {
        await _setCurrentUser(updatedUser);
      }
      
      _logger.debug('Updated user profile: ${user.id}');
    } catch (e) {
      _logger.error('Failed to update user profile: ${user.id}', e);
      throw StorageException('更新使用者資料失敗');
    }
  }
  
  @override
  Future<void> syncUserData() async {
    try {
      // This would typically sync with remote server
      // For now, we'll just log the action
      _logger.info('User data sync requested');
      throw UnimplementedError('User data sync not implemented in repository layer');
    } catch (e) {
      _logger.error('Failed to sync user data', e);
      throw SyncException('使用者資料同步失敗');
    }
  }
  
  /// Set current user (internal method)
  Future<void> _setCurrentUser(User user) async {
    try {
      // Store in local storage
      await _localStorage.usersBox.put(_currentUserKey, user);
      
      // Store user ID in secure storage
      await _secureStorage.storeUserId(user.id);
      
      _logger.debug('Set current user: ${user.id}');
    } catch (e) {
      _logger.error('Failed to set current user: ${user.id}', e);
      throw StorageException('設定當前使用者失敗');
    }
  }
  
  /// Create and set guest user
  Future<User> createGuestUser() async {
    try {
      final guestUser = User.guest();
      await save(guestUser);
      await _setCurrentUser(guestUser);
      
      _logger.info('Created guest user: ${guestUser.id}');
      return guestUser;
    } catch (e) {
      _logger.error('Failed to create guest user', e);
      throw StorageException('建立訪客使用者失敗');
    }
  }
  
  /// Switch from guest to authenticated user
  Future<void> upgradeFromGuest(User authenticatedUser) async {
    try {
      final currentUser = await getCurrentUser();
      
      // Save the authenticated user
      await save(authenticatedUser);
      await _setCurrentUser(authenticatedUser);
      
      // Remove guest user if it exists
      if (currentUser != null && currentUser.isGuest) {
        await delete(currentUser.id);
      }
      
      _logger.info('Upgraded from guest to authenticated user: ${authenticatedUser.id}');
    } catch (e) {
      _logger.error('Failed to upgrade from guest user', e);
      throw StorageException('升級使用者帳戶失敗');
    }
  }
}