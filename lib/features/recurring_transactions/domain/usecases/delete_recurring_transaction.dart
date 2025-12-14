import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/recurring_transaction_repository.dart';

/// Use case for deleting a recurring transaction
///
/// Removes a recurring transaction template from the system.
class DeleteRecurringTransaction {
  final RecurringTransactionRepository repository;

  const DeleteRecurringTransaction(this.repository);

  /// Execute the use case
  ///
  /// [params] - Parameters containing recurringTransactionId to delete
  /// Returns success or failure
  Future<Either<Failure, void>> call(
    DeleteRecurringTransactionParams params,
  ) async {
    return await repository.deleteRecurringTransaction(
      recurringTransactionId: params.recurringTransactionId,
    );
  }
}

/// Parameters for DeleteRecurringTransaction use case
class DeleteRecurringTransactionParams extends Equatable {
  final String recurringTransactionId;

  const DeleteRecurringTransactionParams({
    required this.recurringTransactionId,
  });

  @override
  List<Object?> get props => [recurringTransactionId];
}
