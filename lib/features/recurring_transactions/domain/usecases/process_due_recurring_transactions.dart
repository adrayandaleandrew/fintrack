import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../repositories/recurring_transaction_repository.dart';

/// Use case for processing all due recurring transactions
///
/// Generates transactions from all recurring transactions that are due.
class ProcessDueRecurringTransactions {
  final RecurringTransactionRepository repository;

  const ProcessDueRecurringTransactions(this.repository);

  /// Execute the use case
  ///
  /// Returns list of generated transactions or failure
  Future<Either<Failure, List<Transaction>>> call() async {
    return await repository.processDueRecurringTransactions();
  }
}
