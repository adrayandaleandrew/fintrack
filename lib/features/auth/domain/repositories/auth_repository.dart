import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// Authentication repository interface
///
/// Defines the contract for authentication operations.
/// Implementations will handle actual authentication logic
/// (mock or real API).
abstract class AuthRepository {
  /// Logs in a user with email and password
  ///
  /// Returns [Right(User)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Registers a new user
  ///
  /// Returns [Right(User)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
    String? defaultCurrency,
  });

  /// Logs out the current user
  ///
  /// Returns [Right(void)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, void>> logout();

  /// Gets the currently logged-in user
  ///
  /// Returns [Right(User)] if user is logged in
  /// Returns [Left(AuthFailure)] if not logged in
  Future<Either<Failure, User>> getCurrentUser();

  /// Checks if a user is currently logged in
  ///
  /// Returns [Right(true)] if logged in
  /// Returns [Right(false)] if not logged in
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, bool>> isUserLoggedIn();

  /// Sends a password reset email
  ///
  /// Returns [Right(void)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  });

  /// Updates user profile
  ///
  /// Returns [Right(User)] on success
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, User>> updateProfile({
    required String userId,
    String? name,
    String? profilePicture,
    String? defaultCurrency,
  });
}
