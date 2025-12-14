import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/recurring_transaction.dart';
import '../repositories/recurring_transaction_repository.dart';

/// Use case for creating a new recurring transaction
///
/// Validates and creates a new recurring transaction template.
class CreateRecurringTransaction {
  final RecurringTransactionRepository repository;

  const CreateRecurringTransaction(this.repository);

  /// Execute the use case
  ///
  /// [params] - Parameters containing recurring transaction to create
  /// Returns created recurring transaction with generated ID or failure
  Future<Either<Failure, RecurringTransaction>> call(
    CreateRecurringTransactionParams params,
  ) async {
    // Validation
    if (params.recurringTransaction.amount <= 0) {
      return Left(
        ValidationFailure('Amount must be greater than zero'),
      );
    }

    if (params.recurringTransaction.endDate != null &&
        params.recurringTransaction.endDate!
            .isBefore(params.recurringTransaction.startDate)) {
      return Left(ValidationFailure('End date must be after start date'));
    }

    if (params.recurringTransaction.maxOccurrences != null &&
        params.recurringTransaction.maxOccurrences! <= 0) {
      return Left(
        ValidationFailure('Max occurrences must be greater than zero'),
      );
    }

    return await repository.createRecurringTransaction(
      recurringTransaction: params.recurringTransaction,
    );
  }
}

/// Parameters for CreateRecurringTransaction use case
class CreateRecurringTransactionParams extends Equatable {
  final RecurringTransaction recurringTransaction;

  const CreateRecurringTransactionParams({
    required this.recurringTransaction,
  });

  @override
  List<Object?> get props => [recurringTransaction];
}
