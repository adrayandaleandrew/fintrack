import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Use case for searching transactions by description
///
/// Performs case-insensitive search in transaction descriptions and notes.
class SearchTransactions {
  final TransactionRepository repository;

  SearchTransactions({required this.repository});

  /// Execute the use case
  ///
  /// [params] contains the user ID and search query
  Future<Either<Failure, List<Transaction>>> call(
    SearchTransactionsParams params,
  ) async {
    // Validate query
    if (params.query.trim().isEmpty) {
      return Left(
        ValidationFailure('Search query cannot be empty'),
      );
    }

    return await repository.searchTransactions(
      userId: params.userId,
      query: params.query,
    );
  }
}

/// Parameters for SearchTransactions use case
class SearchTransactionsParams extends Equatable {
  final String userId;
  final String query;

  const SearchTransactionsParams({
    required this.userId,
    required this.query,
  });

  @override
  List<Object?> get props => [userId, query];
}
