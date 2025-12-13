import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Use case for updating an existing transaction
///
/// Recalculates account balances based on the difference between old and new values.
/// Cannot change transaction type (income/expense/transfer).
class UpdateTransaction {
  final TransactionRepository repository;

  UpdateTransaction({required this.repository});

  /// Execute the use case
  ///
  /// [params] contains the updated transaction
  ///
  /// Validation rules:
  /// - Amount must be greater than 0
  /// - Description must not be empty
  /// - For transfers: toAccountId must be provided and different from accountId
  /// - Cannot change transaction type
  Future<Either<Failure, Transaction>> call(
    UpdateTransactionParams params,
  ) async {
    // Validate amount
    if (params.transaction.amount <= 0) {
      return Left(
        ValidationFailure('Amount must be greater than 0'),
      );
    }

    // Validate description
    if (params.transaction.description.trim().isEmpty) {
      return Left(
        ValidationFailure('Description cannot be empty'),
      );
    }

    // Validate transfer-specific rules
    if (params.transaction.isTransfer) {
      if (params.transaction.toAccountId == null) {
        return Left(
          ValidationFailure('Destination account is required for transfers'),
        );
      }

      if (params.transaction.toAccountId == params.transaction.accountId) {
        return Left(
          ValidationFailure('Cannot transfer to the same account'),
        );
      }
    }

    // Update transaction
    return await repository.updateTransaction(params.transaction);
  }
}

/// Parameters for UpdateTransaction use case
class UpdateTransactionParams extends Equatable {
  final Transaction transaction;

  const UpdateTransactionParams({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}
