import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/transaction_repository.dart';

/// Use case for deleting a transaction
///
/// Restores account balance(s) by reversing the transaction effect.
class DeleteTransaction {
  final TransactionRepository repository;

  DeleteTransaction({required this.repository});

  /// Execute the use case
  ///
  /// [params] contains the transaction ID to delete
  Future<Either<Failure, void>> call(
    DeleteTransactionParams params,
  ) async {
    return await repository.deleteTransaction(params.id);
  }
}

/// Parameters for DeleteTransaction use case
class DeleteTransactionParams extends Equatable {
  final String id;

  const DeleteTransactionParams({required this.id});

  @override
  List<Object?> get props => [id];
}
