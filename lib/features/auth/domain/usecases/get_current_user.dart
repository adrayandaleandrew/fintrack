import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Get current user use case
///
/// Retrieves the currently logged-in user.
/// This is a single-responsibility class that handles only getting current user logic.
class GetCurrentUser {
  final AuthRepository repository;

  const GetCurrentUser({required this.repository});

  /// Executes the get current user use case
  ///
  /// Returns [Right(User)] if user is logged in
  /// Returns [Left(AuthFailure)] if no user is logged in
  /// Returns [Left(Failure)] on other errors
  Future<Either<Failure, User>> call() async {
    return await repository.getCurrentUser();
  }
}
