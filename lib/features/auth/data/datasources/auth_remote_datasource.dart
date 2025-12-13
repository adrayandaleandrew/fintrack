import '../models/user_model.dart';

/// Authentication remote data source interface
///
/// Defines the contract for authentication API calls.
/// Implementations handle actual network requests (mock or real).
abstract class AuthRemoteDataSource {
  /// Logs in a user with email and password
  ///
  /// Returns [UserModel] on success
  /// Throws [ServerException] on API error
  /// Throws [NetworkException] on network error
  Future<UserModel> login({
    required String email,
    required String password,
  });

  /// Registers a new user
  ///
  /// Returns [UserModel] on success
  /// Throws [ServerException] on API error (email already exists, etc.)
  /// Throws [NetworkException] on network error
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    String? defaultCurrency,
  });

  /// Sends a password reset email
  ///
  /// Returns nothing on success
  /// Throws [ServerException] on API error
  /// Throws [NetworkException] on network error
  Future<void> sendPasswordResetEmail({
    required String email,
  });

  /// Updates user profile
  ///
  /// Returns updated [UserModel] on success
  /// Throws [ServerException] on API error
  /// Throws [NetworkException] on network error
  Future<UserModel> updateProfile({
    required String userId,
    String? name,
    String? profilePicture,
    String? defaultCurrency,
  });
}
