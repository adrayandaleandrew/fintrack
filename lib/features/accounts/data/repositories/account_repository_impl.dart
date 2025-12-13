import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_local_datasource.dart';
import '../datasources/account_remote_datasource.dart';

/// Implementation of AccountRepository
///
/// Coordinates between remote and local data sources.
/// Handles data flow and error transformation.
class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource;
  final AccountLocalDataSource localDataSource;

  const AccountRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Account>>> getAccounts({
    required String userId,
    bool activeOnly = false,
  }) async {
    try {
      // Try to get from remote
      final accounts = await remoteDataSource.getAccounts(
        userId: userId,
        activeOnly: activeOnly,
      );

      // Cache the accounts
      await localDataSource.cacheAccounts(accounts);

      return Right(accounts);
    } on ServerException catch (e) {
      // If remote fails, try to get from cache
      try {
        final cachedAccounts = await localDataSource.getCachedAccounts(
          userId: userId,
        );

        if (activeOnly) {
          final filtered = cachedAccounts
              .where((account) => account.isActive)
              .toList();
          return Right(filtered);
        }

        return Right(cachedAccounts);
      } on CacheException {
        return Left(ServerFailure(e.message));
      }
    } on NetworkException catch (e) {
      // Try cache on network error
      try {
        final cachedAccounts = await localDataSource.getCachedAccounts(
          userId: userId,
        );

        if (activeOnly) {
          final filtered = cachedAccounts
              .where((account) => account.isActive)
              .toList();
          return Right(filtered);
        }

        return Right(cachedAccounts);
      } on CacheException {
        return Left(NetworkFailure(e.message));
      }
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Account>> getAccountById({
    required String accountId,
  }) async {
    try {
      final account = await remoteDataSource.getAccountById(
        accountId: accountId,
      );

      // Cache the account
      await localDataSource.cacheAccount(account);

      return Right(account);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      // Try cache on server error
      try {
        final cachedAccount = await localDataSource.getCachedAccount(
          accountId: accountId,
        );
        return Right(cachedAccount);
      } on CacheException {
        return Left(ServerFailure(e.message));
      }
    } on NetworkException catch (e) {
      // Try cache on network error
      try {
        final cachedAccount = await localDataSource.getCachedAccount(
          accountId: accountId,
        );
        return Right(cachedAccount);
      } on CacheException {
        return Left(NetworkFailure(e.message));
      }
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Account>> createAccount({
    required String userId,
    required String name,
    required AccountType type,
    required double initialBalance,
    required String currency,
    String? icon,
    String? color,
    String? notes,
    double? creditLimit,
    double? interestRate,
  }) async {
    try {
      final account = await remoteDataSource.createAccount(
        userId: userId,
        name: name,
        type: type,
        initialBalance: initialBalance,
        currency: currency,
        icon: icon,
        color: color,
        notes: notes,
        creditLimit: creditLimit,
        interestRate: interestRate,
      );

      // Cache the new account
      await localDataSource.cacheAccount(account);

      return Right(account);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Account>> updateAccount({
    required String accountId,
    String? name,
    AccountType? type,
    String? currency,
    String? icon,
    String? color,
    bool? isActive,
    String? notes,
    double? creditLimit,
    double? interestRate,
  }) async {
    try {
      final account = await remoteDataSource.updateAccount(
        accountId: accountId,
        name: name,
        type: type,
        currency: currency,
        icon: icon,
        color: color,
        isActive: isActive,
        notes: notes,
        creditLimit: creditLimit,
        interestRate: interestRate,
      );

      // Update cache
      await localDataSource.cacheAccount(account);

      return Right(account);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount({
    required String accountId,
  }) async {
    try {
      await remoteDataSource.deleteAccount(accountId: accountId);

      // Remove from cache
      await localDataSource.removeCachedAccount(accountId: accountId);

      return const Right(null);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Account>> updateBalance({
    required String accountId,
    required double newBalance,
  }) async {
    try {
      final account = await remoteDataSource.updateBalance(
        accountId: accountId,
        newBalance: newBalance,
      );

      // Update cache
      await localDataSource.cacheAccount(account);

      return Right(account);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalBalance({
    required String userId,
    required String currency,
    bool activeOnly = true,
  }) async {
    try {
      final accounts = await remoteDataSource.getAccounts(
        userId: userId,
        activeOnly: activeOnly,
      );

      // Filter by currency and sum balances
      final totalBalance = accounts
          .where((account) => account.currency == currency)
          .fold(0.0, (sum, account) => sum + account.balance);

      return Right(totalBalance);
    } on ServerException catch (e) {
      // Try cache
      try {
        final cachedAccounts = await localDataSource.getCachedAccounts(
          userId: userId,
        );

        var filtered = cachedAccounts.where(
          (account) => account.currency == currency,
        );

        if (activeOnly) {
          filtered = filtered.where((account) => account.isActive);
        }

        final totalBalance = filtered.fold(
          0.0,
          (sum, account) => sum + account.balance,
        );

        return Right(totalBalance);
      } on CacheException {
        return Left(ServerFailure(e.message));
      }
    } on NetworkException catch (e) {
      // Try cache
      try {
        final cachedAccounts = await localDataSource.getCachedAccounts(
          userId: userId,
        );

        var filtered = cachedAccounts.where(
          (account) => account.currency == currency,
        );

        if (activeOnly) {
          filtered = filtered.where((account) => account.isActive);
        }

        final totalBalance = filtered.fold(
          0.0,
          (sum, account) => sum + account.balance,
        );

        return Right(totalBalance);
      } on CacheException {
        return Left(NetworkFailure(e.message));
      }
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
