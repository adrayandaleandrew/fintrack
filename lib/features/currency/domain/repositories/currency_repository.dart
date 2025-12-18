import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/currency/domain/entities/currency.dart';
import 'package:finance_tracker/features/currency/domain/entities/exchange_rate.dart';

/// Currency repository interface
///
/// Defines the contract for currency operations.
/// Implementations should handle fetching currencies, exchange rates, and conversions.
abstract class CurrencyRepository {
  /// Gets all supported currencies
  ///
  /// Returns [Right(List<Currency>)] on success or [Left(Failure)] on error.
  Future<Either<Failure, List<Currency>>> getCurrencies();

  /// Gets a single currency by its code
  ///
  /// Returns [Right(Currency)] on success or [Left(Failure)] on error.
  Future<Either<Failure, Currency>> getCurrencyByCode(String code);

  /// Gets all exchange rates
  ///
  /// Optionally filtered by [baseCurrency].
  /// Returns [Right(List<ExchangeRate>)] on success or [Left(Failure)] on error.
  Future<Either<Failure, List<ExchangeRate>>> getExchangeRates({
    String? baseCurrency,
  });

  /// Gets exchange rate between two currencies
  ///
  /// Returns [Right(ExchangeRate)] on success or [Left(Failure)] on error.
  Future<Either<Failure, ExchangeRate>> getExchangeRate({
    required String fromCurrency,
    required String toCurrency,
  });

  /// Converts an amount from one currency to another
  ///
  /// Returns [Right(double)] converted amount on success or [Left(Failure)] on error.
  Future<Either<Failure, double>> convertCurrency({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  });

  /// Gets the user's base currency code
  ///
  /// Returns [Right(String)] currency code on success or [Left(Failure)] on error.
  Future<Either<Failure, String>> getBaseCurrency(String userId);

  /// Updates the user's base currency
  ///
  /// Returns [Right(void)] on success or [Left(Failure)] on error.
  Future<Either<Failure, void>> updateBaseCurrency({
    required String userId,
    required String currencyCode,
  });

  /// Refreshes exchange rates from remote source
  ///
  /// Returns [Right(void)] on success or [Left(Failure)] on error.
  Future<Either<Failure, void>> refreshExchangeRates();
}
