import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Use case for getting all transactions for a user
///
/// Returns transactions ordered by date (newest first).
class GetTransactions {
  final TransactionRepository repository;

  GetTransactions({required this.repository});

  /// Execute the use case
  ///
  /// [params] contains the userId
  Future<Either<Failure, List<Transaction>>> call(
    GetTransactionsParams params,
  ) async {
    return await repository.getTransactions(params.userId);
  }
}

/// Parameters for GetTransactions use case
class GetTransactionsParams extends Equatable {
  final String userId;

  const GetTransactionsParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
