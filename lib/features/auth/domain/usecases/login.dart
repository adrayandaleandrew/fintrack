import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Login use case
///
/// Logs in a user with email and password.
/// This is a single-responsibility class that handles only login logic.
class Login {
  final AuthRepository repository;

  const Login({required this.repository});

  /// Executes the login use case
  ///
  /// Returns [Right(User)] on successful login
  /// Returns [Left(Failure)] on error (invalid credentials, network error, etc.)
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

/// Parameters for Login use case
class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
