import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../domain/entities/recurring_transaction.dart';
import '../../domain/repositories/recurring_transaction_repository.dart';
import '../datasources/recurring_transaction_remote_datasource.dart';
import '../models/recurring_transaction_model.dart';

/// Implementation of RecurringTransactionRepository
///
/// Handles recurring transaction operations using remote data source
/// and transaction repository for generating actual transactions.
class RecurringTransactionRepositoryImpl
    implements RecurringTransactionRepository {
  final RecurringTransactionRemoteDataSource remoteDataSource;
  final TransactionRepository transactionRepository;

  const RecurringTransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.transactionRepository,
  });

  @override
  Future<Either<Failure, List<RecurringTransaction>>>
      getRecurringTransactions({
    required String userId,
    bool activeOnly = false,
  }) async {
    try {
      final recurring = await remoteDataSource.getRecurringTransactions(
        userId: userId,
        activeOnly: activeOnly,
      );
      return Right(recurring.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Failed to get recurring transactions: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, RecurringTransaction>> getRecurringTransactionById({
    required String recurringTransactionId,
  }) async {
    try {
      final recurring = await remoteDataSource.getRecurringTransactionById(
        recurringTransactionId: recurringTransactionId,
      );
      return Right(recurring.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Failed to get recurring transaction: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<RecurringTransaction>>>
      getRecurringTransactionsByAccount({
    required String accountId,
  }) async {
    try {
      final recurring =
          await remoteDataSource.getRecurringTransactionsByAccount(
        accountId: accountId,
      );
      return Right(recurring.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure(
          'Failed to get recurring transactions by account: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<RecurringTransaction>>>
      getRecurringTransactionsByCategory({
    required String categoryId,
  }) async {
    try {
      final recurring =
          await remoteDataSource.getRecurringTransactionsByCategory(
        categoryId: categoryId,
      );
      return Right(recurring.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure(
          'Failed to get recurring transactions by category: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, RecurringTransaction>> createRecurringTransaction({
    required RecurringTransaction recurringTransaction,
  }) async {
    try {
      final model = RecurringTransactionModel.fromEntity(recurringTransaction);
      final created = await remoteDataSource.createRecurringTransaction(
        recurringTransaction: model,
      );
      return Right(created.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Failed to create recurring transaction: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, RecurringTransaction>> updateRecurringTransaction({
    required RecurringTransaction recurringTransaction,
  }) async {
    try {
      final model = RecurringTransactionModel.fromEntity(recurringTransaction);
      final updated = await remoteDataSource.updateRecurringTransaction(
        recurringTransaction: model,
      );
      return Right(updated.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Failed to update recurring transaction: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecurringTransaction({
    required String recurringTransactionId,
  }) async {
    try {
      await remoteDataSource.deleteRecurringTransaction(
        recurringTransactionId: recurringTransactionId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Failed to delete recurring transaction: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<RecurringTransaction>>>
      getDueRecurringTransactions() async {
    try {
      final recurring = await remoteDataSource.getDueRecurringTransactions();
      return Right(recurring.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Failed to get due recurring transactions: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Transaction>> generateTransaction({
    required String recurringTransactionId,
    required DateTime occurrenceDate,
  }) async {
    try {
      // Generate transaction model from recurring template
      final transactionModel = await remoteDataSource.generateTransaction(
        recurringTransactionId: recurringTransactionId,
        occurrenceDate: occurrenceDate,
      );

      // Create actual transaction using transaction repository
      final result = await transactionRepository.createTransaction(
        transactionModel.toEntity(),
      );

      return result.fold(
        (failure) => Left(failure),
        (transaction) => Right(transaction),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Failed to generate transaction: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>>
      processDueRecurringTransactions() async {
    try {
      // Get all due recurring transactions
      final dueResult = await getDueRecurringTransactions();
      if (dueResult.isLeft()) {
        return Left((dueResult as Left).value);
      }

      final dueRecurring = (dueResult as Right).value as List<RecurringTransaction>;
      final generatedTransactions = <Transaction>[];

      // Generate transaction for each due recurring transaction
      for (final recurring in dueRecurring) {
        final nextOccurrence = recurring.getNextOccurrence();
        if (nextOccurrence != null) {
          final result = await generateTransaction(
            recurringTransactionId: recurring.id,
            occurrenceDate: nextOccurrence,
          );

          result.fold(
            (failure) {
              // Log error but continue processing others
            },
            (transaction) {
              generatedTransactions.add(transaction);
            },
          );
        }
      }

      return Right(generatedTransactions);
    } catch (e) {
      return Left(
        ServerFailure(
          'Failed to process due recurring transactions: ${e.toString()}',
        ),
      );
    }
  }
}
