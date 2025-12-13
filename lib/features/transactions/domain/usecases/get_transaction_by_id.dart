import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

/// Use case for getting a single transaction by ID
class GetTransactionById {
  final TransactionRepository repository;

  GetTransactionById({required this.repository});

  /// Execute the use case
  ///
  /// [params] contains the transaction ID
  Future<Either<Failure, Transaction>> call(
    GetTransactionByIdParams params,
  ) async {
    return await repository.getTransactionById(params.id);
  }
}

/// Parameters for GetTransactionById use case
class GetTransactionByIdParams extends Equatable {
  final String id;

  const GetTransactionByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}
