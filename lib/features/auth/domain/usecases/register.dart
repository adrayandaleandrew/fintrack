import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Register use case
///
/// Registers a new user account.
/// This is a single-responsibility class that handles only registration logic.
class Register {
  final AuthRepository repository;

  const Register({required this.repository});

  /// Executes the register use case
  ///
  /// Returns [Right(User)] on successful registration
  /// Returns [Left(Failure)] on error (email already exists, weak password, etc.)
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
      defaultCurrency: params.defaultCurrency,
    );
  }
}

/// Parameters for Register use case
class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String name;
  final String? defaultCurrency;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
    this.defaultCurrency,
  });

  @override
  List<Object?> get props => [email, password, name, defaultCurrency];
}
