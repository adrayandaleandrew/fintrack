import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Logout use case
///
/// Logs out the current user and clears session data.
/// This is a single-responsibility class that handles only logout logic.
class Logout {
  final AuthRepository repository;

  const Logout({required this.repository});

  /// Executes the logout use case
  ///
  /// Returns [Right(void)] on successful logout
  /// Returns [Left(Failure)] on error
  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}
