import 'package:finance_tracker/core/errors/exceptions.dart';
import 'package:finance_tracker/features/currency/data/datasources/currency_remote_datasource.dart';
import 'package:finance_tracker/features/currency/data/models/currency_model.dart';
import 'package:finance_tracker/features/currency/data/models/exchange_rate_model.dart';

/// Mock implementation of CurrencyRemoteDataSource
///
/// Provides in-memory currency and exchange rate data for development/testing.
class CurrencyRemoteDataSourceMock implements CurrencyRemoteDataSource {
  // Base currency for all exchange rates (USD)
  static const String baseCurrency = 'USD';

  // Mock currencies (20+ major world currencies)
  static final List<CurrencyModel> _currencies = [
    const CurrencyModel(
      code: 'USD',
      name: 'US Dollar',
      symbol: '\$',
      decimalPlaces: 2,
      flag: '🇺🇸',
    ),
    const CurrencyModel(
      code: 'EUR',
      name: 'Euro',
      symbol: '€',
      decimalPlaces: 2,
      flag: '🇪🇺',
    ),
    const CurrencyModel(
      code: 'GBP',
      name: 'British Pound',
      symbol: '£',
      decimalPlaces: 2,
      flag: '🇬🇧',
    ),
    const CurrencyModel(
      code: 'JPY',
      name: 'Japanese Yen',
      symbol: '¥',
      decimalPlaces: 0,
      flag: '🇯🇵',
    ),
    const CurrencyModel(
      code: 'CNY',
      name: 'Chinese Yuan',
      symbol: '¥',
      decimalPlaces: 2,
      flag: '🇨🇳',
    ),
    const CurrencyModel(
      code: 'INR',
      name: 'Indian Rupee',
      symbol: '₹',
      decimalPlaces: 2,
      flag: '🇮🇳',
    ),
    const CurrencyModel(
      code: 'AUD',
      name: 'Australian Dollar',
      symbol: 'A\$',
      decimalPlaces: 2,
      flag: '🇦🇺',
    ),
    const CurrencyModel(
      code: 'CAD',
      name: 'Canadian Dollar',
      symbol: 'C\$',
      decimalPlaces: 2,
      flag: '🇨🇦',
    ),
    const CurrencyModel(
      code: 'CHF',
      name: 'Swiss Franc',
      symbol: 'CHF',
      decimalPlaces: 2,
      flag: '🇨🇭',
    ),
    const CurrencyModel(
      code: 'BRL',
      name: 'Brazilian Real',
      symbol: 'R\$',
      decimalPlaces: 2,
      flag: '🇧🇷',
    ),
    const CurrencyModel(
      code: 'MXN',
      name: 'Mexican Peso',
      symbol: 'MX\$',
      decimalPlaces: 2,
      flag: '🇲🇽',
    ),
    const CurrencyModel(
      code: 'ZAR',
      name: 'South African Rand',
      symbol: 'R',
      decimalPlaces: 2,
      flag: '🇿🇦',
    ),
    const CurrencyModel(
      code: 'SGD',
      name: 'Singapore Dollar',
      symbol: 'S\$',
      decimalPlaces: 2,
      flag: '🇸🇬',
    ),
    const CurrencyModel(
      code: 'HKD',
      name: 'Hong Kong Dollar',
      symbol: 'HK\$',
      decimalPlaces: 2,
      flag: '🇭🇰',
    ),
    const CurrencyModel(
      code: 'SEK',
      name: 'Swedish Krona',
      symbol: 'kr',
      decimalPlaces: 2,
      flag: '🇸🇪',
    ),
    const CurrencyModel(
      code: 'NOK',
      name: 'Norwegian Krone',
      symbol: 'kr',
      decimalPlaces: 2,
      flag: '🇳🇴',
    ),
    const CurrencyModel(
      code: 'DKK',
      name: 'Danish Krone',
      symbol: 'kr',
      decimalPlaces: 2,
      flag: '🇩🇰',
    ),
    const CurrencyModel(
      code: 'KRW',
      name: 'South Korean Won',
      symbol: '₩',
      decimalPlaces: 0,
      flag: '🇰🇷',
    ),
    const CurrencyModel(
      code: 'RUB',
      name: 'Russian Ruble',
      symbol: '₽',
      decimalPlaces: 2,
      flag: '🇷🇺',
    ),
    const CurrencyModel(
      code: 'TRY',
      name: 'Turkish Lira',
      symbol: '₺',
      decimalPlaces: 2,
      flag: '🇹🇷',
    ),
    const CurrencyModel(
      code: 'NZD',
      name: 'New Zealand Dollar',
      symbol: 'NZ\$',
      decimalPlaces: 2,
      flag: '🇳🇿',
    ),
    const CurrencyModel(
      code: 'AED',
      name: 'UAE Dirham',
      symbol: 'د.إ',
      decimalPlaces: 2,
      flag: '🇦🇪',
    ),
    const CurrencyModel(
      code: 'SAR',
      name: 'Saudi Riyal',
      symbol: '﷼',
      decimalPlaces: 2,
      flag: '🇸🇦',
    ),
  ];

  // Mock exchange rates (all relative to USD as base)
  static List<ExchangeRateModel> _exchangeRates = [
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'EUR',
      rate: 0.92,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'GBP',
      rate: 0.79,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'JPY',
      rate: 149.50,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'CNY',
      rate: 7.24,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'INR',
      rate: 83.12,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'AUD',
      rate: 1.52,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'CAD',
      rate: 1.36,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'CHF',
      rate: 0.88,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'BRL',
      rate: 4.98,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'MXN',
      rate: 17.05,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'ZAR',
      rate: 18.45,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'SGD',
      rate: 1.34,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'HKD',
      rate: 7.82,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'SEK',
      rate: 10.38,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'NOK',
      rate: 10.72,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'DKK',
      rate: 6.87,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'KRW',
      rate: 1308.50,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'RUB',
      rate: 92.50,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'TRY',
      rate: 32.25,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'NZD',
      rate: 1.63,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'AED',
      rate: 3.67,
      lastUpdated: DateTime.now(),
    ),
    ExchangeRateModel(
      fromCurrency: 'USD',
      toCurrency: 'SAR',
      rate: 3.75,
      lastUpdated: DateTime.now(),
    ),
  ];

  @override
  Future<List<CurrencyModel>> getCurrencies() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _currencies;
  }

  @override
  Future<CurrencyModel> getCurrencyByCode(String code) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return _currencies.firstWhere(
        (currency) => currency.code.toUpperCase() == code.toUpperCase(),
      );
    } catch (e) {
      throw ServerException('Currency not found: $code');
    }
  }

  @override
  Future<List<ExchangeRateModel>> getExchangeRates({
    String? baseCurrency,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (baseCurrency == null) {
      return _exchangeRates;
    }

    // Filter rates by base currency
    return _exchangeRates
        .where((rate) => rate.fromCurrency == baseCurrency.toUpperCase())
        .toList();
  }

  @override
  Future<ExchangeRateModel> getExchangeRate({
    required String fromCurrency,
    required String toCurrency,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final from = fromCurrency.toUpperCase();
    final to = toCurrency.toUpperCase();

    // Same currency, rate is 1.0
    if (from == to) {
      return ExchangeRateModel(
        fromCurrency: from,
        toCurrency: to,
        rate: 1.0,
        lastUpdated: DateTime.now(),
      );
    }

    // Try direct rate
    try {
      return _exchangeRates.firstWhere(
        (rate) => rate.fromCurrency == from && rate.toCurrency == to,
      );
    } catch (e) {
      // Try inverse rate
      try {
        final inverseRate = _exchangeRates.firstWhere(
          (rate) => rate.fromCurrency == to && rate.toCurrency == from,
        );
        return ExchangeRateModel(
          fromCurrency: from,
          toCurrency: to,
          rate: 1 / inverseRate.rate,
          lastUpdated: inverseRate.lastUpdated,
        );
      } catch (e) {
        // Try cross-rate through USD
        try {
          final fromUsdRate = _exchangeRates.firstWhere(
            (rate) => rate.fromCurrency == 'USD' && rate.toCurrency == from,
          );
          final toUsdRate = _exchangeRates.firstWhere(
            (rate) => rate.fromCurrency == 'USD' && rate.toCurrency == to,
          );
          return ExchangeRateModel(
            fromCurrency: from,
            toCurrency: to,
            rate: toUsdRate.rate / fromUsdRate.rate,
            lastUpdated: DateTime.now(),
          );
        } catch (e) {
          throw ServerException(
            'Exchange rate not found: $from to $to',
          );
        }
      }
    }
  }

  @override
  Future<double> convertCurrency({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    final rate = await getExchangeRate(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
    );

    return amount * rate.rate;
  }

  @override
  Future<void> refreshExchangeRates() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real app, this would fetch fresh rates from an API
    // For mock, we just update the timestamps
    _exchangeRates = _exchangeRates
        .map(
          (rate) => ExchangeRateModel(
            fromCurrency: rate.fromCurrency,
            toCurrency: rate.toCurrency,
            rate: rate.rate,
            lastUpdated: DateTime.now(),
          ),
        )
        .toList();
  }
}
