import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/account.dart';
import '../repositories/account_repository.dart';

/// Update account use case
///
/// Updates an existing account.
/// This is a single-responsibility class that handles only account updates.
class UpdateAccount {
  final AccountRepository repository;

  const UpdateAccount({required this.repository});

  /// Executes the update account use case
  ///
  /// Returns [Right(Account)] on success with updated account
  /// Returns [Left(NotFoundFailure)] if account doesn't exist
  /// Returns [Left(ValidationFailure)] if validation fails
  /// Returns [Left(Failure)] on other errors
  Future<Either<Failure, Account>> call(UpdateAccountParams params) async {
    return await repository.updateAccount(
      accountId: params.accountId,
      name: params.name,
      type: params.type,
      currency: params.currency,
      icon: params.icon,
      color: params.color,
      isActive: params.isActive,
      notes: params.notes,
      creditLimit: params.creditLimit,
      interestRate: params.interestRate,
    );
  }
}

/// Parameters for UpdateAccount use case
class UpdateAccountParams extends Equatable {
  final String accountId;
  final String? name;
  final AccountType? type;
  final String? currency;
  final String? icon;
  final String? color;
  final bool? isActive;
  final String? notes;
  final double? creditLimit;
  final double? interestRate;

  const UpdateAccountParams({
    required this.accountId,
    this.name,
    this.type,
    this.currency,
    this.icon,
    this.color,
    this.isActive,
    this.notes,
    this.creditLimit,
    this.interestRate,
  });

  @override
  List<Object?> get props => [
        accountId,
        name,
        type,
        currency,
        icon,
        color,
        isActive,
        notes,
        creditLimit,
        interestRate,
      ];
}
