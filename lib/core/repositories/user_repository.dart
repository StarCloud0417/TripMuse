import '../models/user.dart';
import 'base_repository.dart';

/// Repository interface for User data management
abstract class UserRepository extends BaseRepository<User, String> {
  /// Get current logged-in user
  Future<User?> getCurrentUser();
  
  /// Sign in with Google
  Future<User> signInWithGoogle();
  
  /// Sign out current user
  Future<void> signOut();
  
  /// Check if user is signed in
  Future<bool> isSignedIn();
  
  /// Update user profile
  Future<void> updateProfile(User user);
  
  /// Sync user data with remote server
  Future<void> syncUserData();
}