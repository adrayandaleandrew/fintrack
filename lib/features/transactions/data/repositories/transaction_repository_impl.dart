import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_datasource.dart';
import '../datasources/transaction_remote_datasource.dart';
import '../models/transaction_model.dart';

/// Implementation of TransactionRepository
///
/// Coordinates between remote and local data sources.
/// Uses cache-first strategy for reads, remote-first for writes.
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions(
    String userId,
  ) async {
    try {
      // Try remote first
      final remoteTransactions = await remoteDataSource.getTransactions(userId);

      // Cache the result
      await localDataSource.cacheTransactions(userId, remoteTransactions);

      return Right(remoteTransactions);
    } on ServerException catch (e) {
      // Fallback to cache on server error
      try {
        final cachedTransactions =
            await localDataSource.getCachedTransactions(userId);
        return Right(cachedTransactions);
      } on CacheException {
        return Left(ServerFailure(e.message));
      }
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getTransactionById(String id) async {
    try {
      // Try remote first
      final remoteTransaction = await remoteDataSource.getTransactionById(id);

      // Cache the result
      await localDataSource.cacheTransaction(remoteTransaction);

      return Right(remoteTransaction);
    } on ServerException catch (e) {
      // Fallback to cache on server error
      try {
        final cachedTransaction =
            await localDataSource.getCachedTransactionById(id);
        return Right(cachedTransaction);
      } on CacheException {
        return Left(ServerFailure(e.message));
      }
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Transaction>> createTransaction(
    Transaction transaction,
  ) async {
    try {
      // Create in remote (includes balance updates)
      final transactionModel = TransactionModel.fromEntity(transaction);
      final createdTransaction =
          await remoteDataSource.createTransaction(transactionModel);

      // Cache the result
      await localDataSource.cacheTransaction(createdTransaction);

      return Right(createdTransaction);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Transaction>> updateTransaction(
    Transaction transaction,
  ) async {
    try {
      // Update in remote (includes balance recalculation)
      final transactionModel = TransactionModel.fromEntity(transaction);
      final updatedTransaction =
          await remoteDataSource.updateTransaction(transactionModel);

      // Update cache
      await localDataSource.updateCachedTransaction(updatedTransaction);

      return Right(updatedTransaction);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      // Delete from remote (includes balance restoration)
      await remoteDataSource.deleteTransaction(id);

      // Delete from cache
      try {
        await localDataSource.deleteCachedTransaction(id);
      } on CacheException {
        // Ignore cache errors on delete
      }

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> filterTransactions({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    String? accountId,
    String? categoryId,
    TransactionType? type,
  }) async {
    try {
      // Try remote first
      final remoteTransactions = await remoteDataSource.filterTransactions(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
        accountId: accountId,
        categoryId: categoryId,
        type: type,
      );

      return Right(remoteTransactions);
    } on ServerException catch (e) {
      // Fallback to cache on server error
      try {
        final cachedTransactions =
            await localDataSource.filterCachedTransactions(
          userId: userId,
          startDate: startDate,
          endDate: endDate,
          accountId: accountId,
          categoryId: categoryId,
          type: type,
        );
        return Right(cachedTransactions);
      } on CacheException {
        return Left(ServerFailure(e.message));
      }
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> searchTransactions({
    required String userId,
    required String query,
  }) async {
    try {
      // Try remote first
      final remoteTransactions = await remoteDataSource.searchTransactions(
        userId: userId,
        query: query,
      );

      return Right(remoteTransactions);
    } on ServerException catch (e) {
      // Fallback to cache on server error
      try {
        final cachedTransactions =
            await localDataSource.searchCachedTransactions(
          userId: userId,
          query: query,
        );
        return Right(cachedTransactions);
      } on CacheException {
        return Left(ServerFailure(e.message));
      }
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByAccount(
    String accountId,
  ) async {
    try {
      final remoteTransactions =
          await remoteDataSource.getTransactionsByAccount(accountId);
      return Right(remoteTransactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByCategory(
    String categoryId,
  ) async {
    try {
      final remoteTransactions =
          await remoteDataSource.getTransactionsByCategory(categoryId);
      return Right(remoteTransactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return filterTransactions(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<Either<Failure, double>> getTotalByType({
    required String userId,
    required TransactionType type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final total = await remoteDataSource.getTotalByType(
        userId: userId,
        type: type,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(total);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getRecentTransactions({
    required String userId,
    int limit = 10,
  }) async {
    try {
      final remoteTransactions = await remoteDataSource.getRecentTransactions(
        userId: userId,
        limit: limit,
      );

      return Right(remoteTransactions);
    } on ServerException catch (e) {
      // Fallback to cache on server error
      try {
        final cachedTransactions =
            await localDataSource.getCachedTransactions(userId);
        final recentTransactions = cachedTransactions.take(limit).toList();
        return Right(recentTransactions);
      } on CacheException {
        return Left(ServerFailure(e.message));
      }
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred: $e'));
    }
  }
}
