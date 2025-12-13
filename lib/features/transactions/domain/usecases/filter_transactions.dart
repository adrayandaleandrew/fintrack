import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Use case for filtering transactions by multiple criteria
///
/// Supports filtering by date range, account, category, and type.
class FilterTransactions {
  final TransactionRepository repository;

  FilterTransactions({required this.repository});

  /// Execute the use case
  ///
  /// [params] contains the filter criteria
  Future<Either<Failure, List<Transaction>>> call(
    FilterTransactionsParams params,
  ) async {
    return await repository.filterTransactions(
      userId: params.userId,
      startDate: params.startDate,
      endDate: params.endDate,
      accountId: params.accountId,
      categoryId: params.categoryId,
      type: params.type,
    );
  }
}

/// Parameters for FilterTransactions use case
class FilterTransactionsParams extends Equatable {
  final String userId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? accountId;
  final String? categoryId;
  final TransactionType? type;

  const FilterTransactionsParams({
    required this.userId,
    this.startDate,
    this.endDate,
    this.accountId,
    this.categoryId,
    this.type,
  });

  @override
  List<Object?> get props => [
        userId,
        startDate,
        endDate,
        accountId,
        categoryId,
        type,
      ];
}
