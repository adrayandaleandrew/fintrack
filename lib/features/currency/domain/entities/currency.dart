import 'package:equatable/equatable.dart';

/// Currency entity
///
/// Represents a currency in the domain layer.
/// Contains all currency metadata including code, name, symbol, and decimal places.
class Currency extends Equatable {
  /// ISO 4217 currency code (e.g., 'USD', 'EUR', 'JPY')
  final String code;

  /// Full currency name (e.g., 'US Dollar', 'Euro', 'Japanese Yen')
  final String name;

  /// Currency symbol (e.g., '$', '€', '¥')
  final String symbol;

  /// Number of decimal places used (e.g., 2 for USD, 0 for JPY)
  final int decimalPlaces;

  /// Flag emoji or icon code (e.g., '🇺🇸', '🇪🇺', '🇯🇵')
  final String flag;

  /// Whether this currency is currently active/supported
  final bool isActive;

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.decimalPlaces,
    required this.flag,
    this.isActive = true,
  });

  /// Creates a copy of this currency with updated fields
  Currency copyWith({
    String? code,
    String? name,
    String? symbol,
    int? decimalPlaces,
    String? flag,
    bool? isActive,
  }) {
    return Currency(
      code: code ?? this.code,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      decimalPlaces: decimalPlaces ?? this.decimalPlaces,
      flag: flag ?? this.flag,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        code,
        name,
        symbol,
        decimalPlaces,
        flag,
        isActive,
      ];

  @override
  bool get stringify => true;
}
