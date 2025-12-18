import 'package:equatable/equatable.dart';

/// ExchangeRate entity
///
/// Represents an exchange rate between two currencies.
/// The rate indicates how much 1 unit of the source currency is worth in the target currency.
class ExchangeRate extends Equatable {
  /// Source currency code (e.g., 'USD')
  final String fromCurrency;

  /// Target currency code (e.g., 'EUR')
  final String toCurrency;

  /// Exchange rate value (e.g., 0.85 means 1 USD = 0.85 EUR)
  final double rate;

  /// When this rate was last updated
  final DateTime lastUpdated;

  const ExchangeRate({
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.lastUpdated,
  });

  /// Creates a copy of this exchange rate with updated fields
  ExchangeRate copyWith({
    String? fromCurrency,
    String? toCurrency,
    double? rate,
    DateTime? lastUpdated,
  }) {
    return ExchangeRate(
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      rate: rate ?? this.rate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Calculates the inverse rate (from target to source)
  ExchangeRate get inverse {
    return ExchangeRate(
      fromCurrency: toCurrency,
      toCurrency: fromCurrency,
      rate: 1 / rate,
      lastUpdated: lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        fromCurrency,
        toCurrency,
        rate,
        lastUpdated,
      ];

  @override
  bool get stringify => true;
}
