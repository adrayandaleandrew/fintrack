import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Is user logged in use case
///
/// Checks if a user is currently logged in.
/// This is a single-responsibility class that handles only login status check.
class IsUserLoggedIn {
  final AuthRepository repository;

  const IsUserLoggedIn({required this.repository});

  /// Executes the is user logged in use case
  ///
  /// Returns [Right(true)] if user is logged in
  /// Returns [Right(false)] if user is not logged in
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, bool>> call() async {
    return await repository.isUserLoggedIn();
  }
}
