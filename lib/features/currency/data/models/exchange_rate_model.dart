import 'package:finance_tracker/features/currency/domain/entities/exchange_rate.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exchange_rate_model.g.dart';

/// ExchangeRate model for data layer
///
/// Extends ExchangeRate entity and adds JSON serialization support.
@JsonSerializable()
class ExchangeRateModel extends ExchangeRate {
  const ExchangeRateModel({
    required super.fromCurrency,
    required super.toCurrency,
    required super.rate,
    required super.lastUpdated,
  });

  /// Creates an ExchangeRateModel from an ExchangeRate entity
  factory ExchangeRateModel.fromEntity(ExchangeRate exchangeRate) {
    return ExchangeRateModel(
      fromCurrency: exchangeRate.fromCurrency,
      toCurrency: exchangeRate.toCurrency,
      rate: exchangeRate.rate,
      lastUpdated: exchangeRate.lastUpdated,
    );
  }

  /// Creates an ExchangeRateModel from JSON
  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateModelFromJson(json);

  /// Converts this model to JSON
  Map<String, dynamic> toJson() => _$ExchangeRateModelToJson(this);

  /// Converts this model to an ExchangeRate entity
  ExchangeRate toEntity() {
    return ExchangeRate(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      rate: rate,
      lastUpdated: lastUpdated,
    );
  }
}
