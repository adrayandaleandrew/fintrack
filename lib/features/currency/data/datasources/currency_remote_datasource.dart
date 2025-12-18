import 'package:finance_tracker/features/currency/data/models/currency_model.dart';
import 'package:finance_tracker/features/currency/data/models/exchange_rate_model.dart';

/// Remote data source for currency operations
///
/// Defines the contract for fetching currency data from remote API.
abstract class CurrencyRemoteDataSource {
  /// Gets all supported currencies
  ///
  /// Throws [ServerException] on error.
  Future<List<CurrencyModel>> getCurrencies();

  /// Gets a single currency by code
  ///
  /// Throws [ServerException] on error or if currency not found.
  Future<CurrencyModel> getCurrencyByCode(String code);

  /// Gets all exchange rates
  ///
  /// Optionally filtered by [baseCurrency].
  /// Throws [ServerException] on error.
  Future<List<ExchangeRateModel>> getExchangeRates({String? baseCurrency});

  /// Gets exchange rate between two currencies
  ///
  /// Throws [ServerException] on error or if rate not found.
  Future<ExchangeRateModel> getExchangeRate({
    required String fromCurrency,
    required String toCurrency,
  });

  /// Converts an amount from one currency to another
  ///
  /// Throws [ServerException] on error.
  Future<double> convertCurrency({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  });

  /// Refreshes exchange rates from remote source
  ///
  /// Throws [ServerException] on error.
  Future<void> refreshExchangeRates();
}
