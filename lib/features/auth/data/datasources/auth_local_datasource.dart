import '../models/user_model.dart';

/// Authentication local data source interface
///
/// Defines the contract for local storage of authentication data.
/// Handles tokens, user data caching, and session management.
abstract class AuthLocalDataSource {
  /// Caches user data locally
  ///
  /// Throws [CacheException] on error
  Future<void> cacheUser(UserModel user);

  /// Gets cached user data
  ///
  /// Returns [UserModel] if cached
  /// Throws [CacheException] if not found or error
  Future<UserModel> getCachedUser();

  /// Clears cached user data (logout)
  ///
  /// Throws [CacheException] on error
  Future<void> clearCachedUser();

  /// Checks if user is logged in (has valid token)
  ///
  /// Returns [true] if logged in
  /// Returns [false] if not logged in
  Future<bool> isLoggedIn();

  /// Stores authentication token securely
  ///
  /// Throws [CacheException] on error
  Future<void> storeAuthToken(String token);

  /// Gets stored authentication token
  ///
  /// Returns [String] token if exists
  /// Throws [CacheException] if not found
  Future<String> getAuthToken();

  /// Clears authentication token (logout)
  ///
  /// Throws [CacheException] on error
  Future<void> clearAuthToken();
}
