import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/account_repository.dart';

/// Delete account use case
///
/// Deletes an account.
/// This is a single-responsibility class that handles only account deletion.
class DeleteAccount {
  final AccountRepository repository;

  const DeleteAccount({required this.repository});

  /// Executes the delete account use case
  ///
  /// Returns [Right(void)] on success
  /// Returns [Left(NotFoundFailure)] if account doesn't exist
  /// Returns [Left(ValidationFailure)] if account has transactions
  /// Returns [Left(Failure)] on other errors
  Future<Either<Failure, void>> call(DeleteAccountParams params) async {
    return await repository.deleteAccount(
      accountId: params.accountId,
    );
  }
}

/// Parameters for DeleteAccount use case
class DeleteAccountParams extends Equatable {
  final String accountId;

  const DeleteAccountParams({required this.accountId});

  @override
  List<Object?> get props => [accountId];
}
