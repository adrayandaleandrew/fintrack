import 'package:intl/intl.dart';

/// Utility class for formatting currency values.
///
/// Handles different currencies with their specific symbols, decimal places,
/// and formatting rules.
class CurrencyFormatter {
  /// Formats a currency amount with the appropriate symbol and decimal places.
  ///
  /// [amount] - The numeric amount to format
  /// [currencyCode] - ISO currency code (e.g., 'USD', 'EUR', 'JPY')
  /// [symbol] - Optional custom symbol (defaults to currency code symbol)
  /// [decimalPlaces] - Number of decimal places (defaults to currency standard)
  ///
  /// Returns formatted string like "$1,234.56" or "¥1,234"
  static String format({
    required double amount,
    required String currencyCode,
    String? symbol,
    int? decimalPlaces,
  }) {
    final currency = _getCurrencyInfo(currencyCode);
    final places = decimalPlaces ?? currency.decimalPlaces;
    final sym = symbol ?? currency.symbol;

    final formatter = NumberFormat.currency(
      symbol: sym,
      decimalDigits: places,
      locale: 'en_US',
    );

    return formatter.format(amount);
  }

  /// Formats amount without currency symbol (just the number).
  ///
  /// Useful for input fields where the symbol is shown separately.
  static String formatWithoutSymbol({
    required double amount,
    required String currencyCode,
    int? decimalPlaces,
  }) {
    final currency = _getCurrencyInfo(currencyCode);
    final places = decimalPlaces ?? currency.decimalPlaces;

    final formatter = NumberFormat.currency(
      symbol: '',
      decimalDigits: places,
      locale: 'en_US',
    );

    return formatter.format(amount).trim();
  }

  /// Formats amount as a compact string (e.g., "1.2K", "3.5M").
  ///
  /// Useful for displaying large amounts in limited space.
  static String formatCompact({
    required double amount,
    required String currencyCode,
    String? symbol,
  }) {
    final currency = _getCurrencyInfo(currencyCode);
    final sym = symbol ?? currency.symbol;

    final formatter = NumberFormat.compactCurrency(
      symbol: sym,
      locale: 'en_US',
    );

    return formatter.format(amount);
  }

  /// Formats amount as a compact number without currency symbol (e.g., "1.2K", "3.5M").
  ///
  /// Useful for chart axis labels and displaying numbers in limited space.
  static String formatCompact(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }

  /// Parses a formatted currency string back to a double.
  ///
  /// Removes currency symbols, commas, and other formatting.
  /// Returns null if parsing fails.
  static double? parse(String formattedAmount) {
    try {
      // Remove currency symbols and whitespace
      final cleaned = formattedAmount.replaceAll(RegExp(r'[^\d.-]'), '');
      return double.tryParse(cleaned);
    } catch (e) {
      return null;
    }
  }

  /// Gets currency information for a given currency code.
  static _CurrencyInfo _getCurrencyInfo(String code) {
    return _currencies[code.toUpperCase()] ??
        _CurrencyInfo(
          code: code,
          symbol: code,
          decimalPlaces: 2,
        );
  }

  /// Map of supported currencies with their metadata.
  static final Map<String, _CurrencyInfo> _currencies = {
    'USD': _CurrencyInfo(code: 'USD', symbol: '\$', decimalPlaces: 2),
    'EUR': _CurrencyInfo(code: 'EUR', symbol: '€', decimalPlaces: 2),
    'GBP': _CurrencyInfo(code: 'GBP', symbol: '£', decimalPlaces: 2),
    'JPY': _CurrencyInfo(code: 'JPY', symbol: '¥', decimalPlaces: 0),
    'CNY': _CurrencyInfo(code: 'CNY', symbol: '¥', decimalPlaces: 2),
    'INR': _CurrencyInfo(code: 'INR', symbol: '₹', decimalPlaces: 2),
    'AUD': _CurrencyInfo(code: 'AUD', symbol: 'A\$', decimalPlaces: 2),
    'CAD': _CurrencyInfo(code: 'CAD', symbol: 'C\$', decimalPlaces: 2),
    'CHF': _CurrencyInfo(code: 'CHF', symbol: 'CHF', decimalPlaces: 2),
    'BRL': _CurrencyInfo(code: 'BRL', symbol: 'R\$', decimalPlaces: 2),
    'MXN': _CurrencyInfo(code: 'MXN', symbol: 'MX\$', decimalPlaces: 2),
    'ZAR': _CurrencyInfo(code: 'ZAR', symbol: 'R', decimalPlaces: 2),
    'SGD': _CurrencyInfo(code: 'SGD', symbol: 'S\$', decimalPlaces: 2),
    'HKD': _CurrencyInfo(code: 'HKD', symbol: 'HK\$', decimalPlaces: 2),
    'SEK': _CurrencyInfo(code: 'SEK', symbol: 'kr', decimalPlaces: 2),
    'NOK': _CurrencyInfo(code: 'NOK', symbol: 'kr', decimalPlaces: 2),
    'DKK': _CurrencyInfo(code: 'DKK', symbol: 'kr', decimalPlaces: 2),
    'KRW': _CurrencyInfo(code: 'KRW', symbol: '₩', decimalPlaces: 0),
    'RUB': _CurrencyInfo(code: 'RUB', symbol: '₽', decimalPlaces: 2),
    'TRY': _CurrencyInfo(code: 'TRY', symbol: '₺', decimalPlaces: 2),
  };
}

/// Internal class to hold currency metadata.
class _CurrencyInfo {
  final String code;
  final String symbol;
  final int decimalPlaces;

  _CurrencyInfo({
    required this.code,
    required this.symbol,
    required this.decimalPlaces,
  });
}
