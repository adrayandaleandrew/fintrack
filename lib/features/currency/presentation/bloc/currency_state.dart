import 'package:equatable/equatable.dart';
import 'package:finance_tracker/features/currency/domain/entities/currency.dart';
import 'package:finance_tracker/features/currency/domain/entities/exchange_rate.dart';

/// Base class for all currency states
abstract class CurrencyState extends Equatable {
  const CurrencyState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CurrencyInitial extends CurrencyState {
  const CurrencyInitial();
}

/// Loading state
class CurrencyLoading extends CurrencyState {
  const CurrencyLoading();
}

/// Currencies loaded successfully
class CurrenciesLoaded extends CurrencyState {
  final List<Currency> currencies;

  const CurrenciesLoaded({required this.currencies});

  @override
  List<Object?> get props => [currencies];

  /// Helper to get currency by code
  Currency? getCurrencyByCode(String code) {
    try {
      return currencies.firstWhere(
        (currency) => currency.code.toUpperCase() == code.toUpperCase(),
      );
    } catch (e) {
      return null;
    }
  }
}

/// Exchange rates loaded successfully
class ExchangeRatesLoaded extends CurrencyState {
  final List<ExchangeRate> exchangeRates;

  const ExchangeRatesLoaded({required this.exchangeRates});

  @override
  List<Object?> get props => [exchangeRates];
}

/// Currency conversion completed
class CurrencyConverted extends CurrencyState {
  final double originalAmount;
  final String fromCurrency;
  final String toCurrency;
  final double convertedAmount;

  const CurrencyConverted({
    required this.originalAmount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.convertedAmount,
  });

  @override
  List<Object?> get props => [
        originalAmount,
        fromCurrency,
        toCurrency,
        convertedAmount,
      ];
}

/// Base currency loaded successfully
class BaseCurrencyLoaded extends CurrencyState {
  final String currencyCode;

  const BaseCurrencyLoaded({required this.currencyCode});

  @override
  List<Object?> get props => [currencyCode];
}

/// Base currency updated successfully
class BaseCurrencyUpdated extends CurrencyState {
  final String currencyCode;
  final String message;

  const BaseCurrencyUpdated({
    required this.currencyCode,
    required this.message,
  });

  @override
  List<Object?> get props => [currencyCode, message];
}

/// Exchange rates refreshed successfully
class ExchangeRatesRefreshed extends CurrencyState {
  final String message;

  const ExchangeRatesRefreshed({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Error state
class CurrencyError extends CurrencyState {
  final String message;

  const CurrencyError({required this.message});

  @override
  List<Object?> get props => [message];
}
