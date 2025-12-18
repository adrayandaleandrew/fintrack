import 'package:finance_tracker/features/currency/data/models/currency_model.dart';
import 'package:finance_tracker/features/currency/data/models/exchange_rate_model.dart';

/// Local data source for currency operations
///
/// Defines the contract for caching currency data locally (Hive).
abstract class CurrencyLocalDataSource {
  /// Caches all currencies
  ///
  /// Throws [CacheException] on error.
  Future<void> cacheCurrencies(List<CurrencyModel> currencies);

  /// Gets cached currencies
  ///
  /// Throws [CacheException] if no data cached.
  Future<List<CurrencyModel>> getCachedCurrencies();

  /// Caches exchange rates
  ///
  /// Throws [CacheException] on error.
  Future<void> cacheExchangeRates(List<ExchangeRateModel> rates);

  /// Gets cached exchange rates
  ///
  /// Throws [CacheException] if no data cached.
  Future<List<ExchangeRateModel>> getCachedExchangeRates();

  /// Caches base currency for a user
  ///
  /// Throws [CacheException] on error.
  Future<void> cacheBaseCurrency(String userId, String currencyCode);

  /// Gets cached base currency for a user
  ///
  /// Throws [CacheException] if no data cached.
  Future<String> getCachedBaseCurrency(String userId);
}
