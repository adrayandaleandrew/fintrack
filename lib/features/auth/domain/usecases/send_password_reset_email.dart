import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Send password reset email use case
///
/// Sends a password reset email to the specified email address.
/// This is a single-responsibility class that handles only password reset logic.
class SendPasswordResetEmail {
  final AuthRepository repository;

  const SendPasswordResetEmail({required this.repository});

  /// Executes the send password reset email use case
  ///
  /// Returns [Right(void)] on success
  /// Returns [Left(Failure)] on error (invalid email, user not found, etc.)
  Future<Either<Failure, void>> call(
    SendPasswordResetEmailParams params,
  ) async {
    return await repository.sendPasswordResetEmail(
      email: params.email,
    );
  }
}

/// Parameters for SendPasswordResetEmail use case
class SendPasswordResetEmailParams extends Equatable {
  final String email;

  const SendPasswordResetEmailParams({required this.email});

  @override
  List<Object?> get props => [email];
}
