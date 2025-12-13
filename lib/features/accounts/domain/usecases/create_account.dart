import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/account.dart';
import '../repositories/account_repository.dart';

/// Create account use case
///
/// Creates a new account.
/// This is a single-responsibility class that handles only account creation.
class CreateAccount {
  final AccountRepository repository;

  const CreateAccount({required this.repository});

  /// Executes the create account use case
  ///
  /// Returns [Right(Account)] on success with created account
  /// Returns [Left(ValidationFailure)] if validation fails
  /// Returns [Left(Failure)] on other errors
  Future<Either<Failure, Account>> call(CreateAccountParams params) async {
    return await repository.createAccount(
      userId: params.userId,
      name: params.name,
      type: params.type,
      initialBalance: params.initialBalance,
      currency: params.currency,
      icon: params.icon,
      color: params.color,
      notes: params.notes,
      creditLimit: params.creditLimit,
      interestRate: params.interestRate,
    );
  }
}

/// Parameters for CreateAccount use case
class CreateAccountParams extends Equatable {
  final String userId;
  final String name;
  final AccountType type;
  final double initialBalance;
  final String currency;
  final String? icon;
  final String? color;
  final String? notes;
  final double? creditLimit;
  final double? interestRate;

  const CreateAccountParams({
    required this.userId,
    required this.name,
    required this.type,
    required this.initialBalance,
    required this.currency,
    this.icon,
    this.color,
    this.notes,
    this.creditLimit,
    this.interestRate,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        type,
        initialBalance,
        currency,
        icon,
        color,
        notes,
        creditLimit,
        interestRate,
      ];
}
