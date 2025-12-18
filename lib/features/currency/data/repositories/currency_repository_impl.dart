import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/exceptions.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/currency/data/datasources/currency_local_datasource.dart';
import 'package:finance_tracker/features/currency/data/datasources/currency_remote_datasource.dart';
import 'package:finance_tracker/features/currency/domain/entities/currency.dart';
import 'package:finance_tracker/features/currency/domain/entities/exchange_rate.dart';
import 'package:finance_tracker/features/currency/domain/repositories/currency_repository.dart';

/// Implementation of CurrencyRepository
///
/// Implements cache-first strategy: tries cache first, falls back to remote.
/// Mutations go to remote first, then update cache.
class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;
  final CurrencyLocalDataSource localDataSource;

  CurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Currency>>> getCurrencies() async {
    try {
      // Try cache first
      try {
        final cachedCurrencies = await localDataSource.getCachedCurrencies();
        return Right(cachedCurrencies.map((m) => m.toEntity()).toList());
      } on CacheException {
        // Cache miss, fetch from remote
        final currencies = await remoteDataSource.getCurrencies();
        // Cache for next time
        await localDataSource.cacheCurrencies(currencies);
        return Right(currencies.map((m) => m.toEntity()).toList());
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Currency>> getCurrencyByCode(String code) async {
    try {
      final currencyModel = await remoteDataSource.getCurrencyByCode(code);
      return Right(currencyModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ExchangeRate>>> getExchangeRates({
    String? baseCurrency,
  }) async {
    try {
      // Try cache first if no filter
      if (baseCurrency == null) {
        try {
          final cachedRates = await localDataSource.getCachedExchangeRates();
          return Right(cachedRates.map((m) => m.toEntity()).toList());
        } on CacheException {
          // Cache miss, fetch from remote
          final rates = await remoteDataSource.getExchangeRates();
          // Cache for next time
          await localDataSource.cacheExchangeRates(rates);
          return Right(rates.map((m) => m.toEntity()).toList());
        }
      }

      // If filtered, always fetch fresh
      final rates =
          await remoteDataSource.getExchangeRates(baseCurrency: baseCurrency);
      return Right(rates.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExchangeRate>> getExchangeRate({
    required String fromCurrency,
    required String toCurrency,
  }) async {
    try {
      final rate = await remoteDataSource.getExchangeRate(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
      );
      return Right(rate.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> convertCurrency({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    try {
      final convertedAmount = await remoteDataSource.convertCurrency(
        amount: amount,
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
      );
      return Right(convertedAmount);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getBaseCurrency(String userId) async {
    try {
      // Try cache first
      try {
        final cachedCurrency =
            await localDataSource.getCachedBaseCurrency(userId);
        return Right(cachedCurrency);
      } on CacheException {
        // No cached base currency, return default
        const defaultCurrency = 'USD';
        // Cache it for next time
        await localDataSource.cacheBaseCurrency(userId, defaultCurrency);
        return const Right(defaultCurrency);
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBaseCurrency({
    required String userId,
    required String currencyCode,
  }) async {
    try {
      // Validate currency exists
      await remoteDataSource.getCurrencyByCode(currencyCode);
      // Cache the new base currency
      await localDataSource.cacheBaseCurrency(userId, currencyCode);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> refreshExchangeRates() async {
    try {
      // Refresh from remote
      await remoteDataSource.refreshExchangeRates();
      // Fetch fresh rates
      final rates = await remoteDataSource.getExchangeRates();
      // Update cache
      await localDataSource.cacheExchangeRates(rates);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
