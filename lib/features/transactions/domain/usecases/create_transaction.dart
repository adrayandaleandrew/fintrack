import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Use case for creating a new transaction
///
/// Validates transaction data and updates account balance(s).
/// For transfer transactions, validates that source and destination accounts exist.
class CreateTransaction {
  final TransactionRepository repository;

  CreateTransaction({required this.repository});

  /// Execute the use case
  ///
  /// [params] contains the transaction to create
  ///
  /// Validation rules:
  /// - Amount must be greater than 0
  /// - Description must not be empty
  /// - For transfers: toAccountId must be provided and different from accountId
  /// - Account and category must exist
  Future<Either<Failure, Transaction>> call(
    CreateTransactionParams params,
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

    // Create transaction
    return await repository.createTransaction(params.transaction);
  }
}

/// Parameters for CreateTransaction use case
class CreateTransactionParams extends Equatable {
  final Transaction transaction;

  const CreateTransactionParams({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}
