import 'package:equatable/equatable.dart';

/// Base class for all currency events
abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all currencies
class LoadCurrencies extends CurrencyEvent {
  const LoadCurrencies();
}

/// Event to load exchange rates
class LoadExchangeRates extends CurrencyEvent {
  final String? baseCurrency;

  const LoadExchangeRates({this.baseCurrency});

  @override
  List<Object?> get props => [baseCurrency];
}

/// Event to convert currency
class ConvertCurrencyRequested extends CurrencyEvent {
  final double amount;
  final String fromCurrency;
  final String toCurrency;

  const ConvertCurrencyRequested({
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
  });

  @override
  List<Object?> get props => [amount, fromCurrency, toCurrency];
}

/// Event to get user's base currency
class LoadBaseCurrency extends CurrencyEvent {
  final String userId;

  const LoadBaseCurrency({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Event to update user's base currency
class UpdateBaseCurrencyRequested extends CurrencyEvent {
  final String userId;
  final String currencyCode;

  const UpdateBaseCurrencyRequested({
    required this.userId,
    required this.currencyCode,
  });

  @override
  List<Object?> get props => [userId, currencyCode];
}

/// Event to refresh exchange rates
class RefreshExchangeRates extends CurrencyEvent {
  const RefreshExchangeRates();
}
