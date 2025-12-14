import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/recurring_transaction.dart';
import '../repositories/recurring_transaction_repository.dart';

/// Use case for getting all recurring transactions for a user
///
/// Retrieves all recurring transactions with optional filtering for active only.
class GetRecurringTransactions {
  final RecurringTransactionRepository repository;

  const GetRecurringTransactions(this.repository);

  /// Execute the use case
  ///
  /// [params] - Parameters containing userId and filter options
  /// Returns list of recurring transactions or failure
  Future<Either<Failure, List<RecurringTransaction>>> call(
    GetRecurringTransactionsParams params,
  ) async {
    return await repository.getRecurringTransactions(
      userId: params.userId,
      activeOnly: params.activeOnly,
    );
  }
}

/// Parameters for GetRecurringTransactions use case
class GetRecurringTransactionsParams extends Equatable {
  final String userId;
  final bool activeOnly;

  const GetRecurringTransactionsParams({
    required this.userId,
    this.activeOnly = false,
  });

  @override
  List<Object?> get props => [userId, activeOnly];
}
