import 'package:finance_tracker/core/errors/exceptions.dart';
import 'package:finance_tracker/features/currency/data/datasources/currency_local_datasource.dart';
import 'package:finance_tracker/features/currency/data/models/currency_model.dart';
import 'package:finance_tracker/features/currency/data/models/exchange_rate_model.dart';
import 'package:hive/hive.dart';

/// Implementation of CurrencyLocalDataSource using Hive
///
/// Caches currencies, exchange rates, and user base currency preferences.
class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {
  static const String currenciesBoxName = 'currencies';
  static const String exchangeRatesBoxName = 'exchange_rates';
  static const String baseCurrencyBoxName = 'base_currency';

  static const String currenciesKey = 'all_currencies';
  static const String exchangeRatesKey = 'all_exchange_rates';

  @override
  Future<void> cacheCurrencies(List<CurrencyModel> currencies) async {
    try {
      final box = await Hive.openBox(currenciesBoxName);
      final currenciesJson = currencies.map((c) => c.toJson()).toList();
      await box.put(currenciesKey, currenciesJson);
    } catch (e) {
      throw CacheException('Failed to cache currencies: $e');
    }
  }

  @override
  Future<List<CurrencyModel>> getCachedCurrencies() async {
    try {
      final box = await Hive.openBox(currenciesBoxName);
      final currenciesJson = box.get(currenciesKey) as List<dynamic>?;

      if (currenciesJson == null) {
        throw CacheException('No cached currencies found');
      }

      return currenciesJson
          .map((json) => CurrencyModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Failed to get cached currencies: $e');
    }
  }

  @override
  Future<void> cacheExchangeRates(List<ExchangeRateModel> rates) async {
    try {
      final box = await Hive.openBox(exchangeRatesBoxName);
      final ratesJson = rates.map((r) => r.toJson()).toList();
      await box.put(exchangeRatesKey, ratesJson);
    } catch (e) {
      throw CacheException('Failed to cache exchange rates: $e');
    }
  }

  @override
  Future<List<ExchangeRateModel>> getCachedExchangeRates() async {
    try {
      final box = await Hive.openBox(exchangeRatesBoxName);
      final ratesJson = box.get(exchangeRatesKey) as List<dynamic>?;

      if (ratesJson == null) {
        throw CacheException('No cached exchange rates found');
      }

      return ratesJson
          .map(
            (json) => ExchangeRateModel.fromJson(Map<String, dynamic>.from(json)),
          )
          .toList();
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Failed to get cached exchange rates: $e');
    }
  }

  @override
  Future<void> cacheBaseCurrency(String userId, String currencyCode) async {
    try {
      final box = await Hive.openBox(baseCurrencyBoxName);
      await box.put(userId, currencyCode);
    } catch (e) {
      throw CacheException('Failed to cache base currency: $e');
    }
  }

  @override
  Future<String> getCachedBaseCurrency(String userId) async {
    try {
      final box = await Hive.openBox(baseCurrencyBoxName);
      final currencyCode = box.get(userId) as String?;

      if (currencyCode == null) {
        throw CacheException('No cached base currency found for user $userId');
      }

      return currencyCode;
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Failed to get cached base currency: $e');
    }
  }
}
