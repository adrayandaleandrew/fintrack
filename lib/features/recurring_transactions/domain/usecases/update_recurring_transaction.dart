import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/recurring_transaction.dart';
import '../repositories/recurring_transaction_repository.dart';

/// Use case for updating an existing recurring transaction
///
/// Validates and updates a recurring transaction template.
class UpdateRecurringTransaction {
  final RecurringTransactionRepository repository;

  const UpdateRecurringTransaction(this.repository);

  /// Execute the use case
  ///
  /// [params] - Parameters containing recurring transaction to update
  /// Returns updated recurring transaction or failure
  Future<Either<Failure, RecurringTransaction>> call(
    UpdateRecurringTransactionParams params,
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

    return await repository.updateRecurringTransaction(
      recurringTransaction: params.recurringTransaction,
    );
  }
}

/// Parameters for UpdateRecurringTransaction use case
class UpdateRecurringTransactionParams extends Equatable {
  final RecurringTransaction recurringTransaction;

  const UpdateRecurringTransactionParams({
    required this.recurringTransaction,
  });

  @override
  List<Object?> get props => [recurringTransaction];
}
