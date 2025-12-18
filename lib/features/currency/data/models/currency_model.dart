import 'package:finance_tracker/features/currency/domain/entities/currency.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency_model.g.dart';

/// Currency model for data layer
///
/// Extends Currency entity and adds JSON serialization support.
@JsonSerializable()
class CurrencyModel extends Currency {
  const CurrencyModel({
    required super.code,
    required super.name,
    required super.symbol,
    required super.decimalPlaces,
    required super.flag,
    super.isActive,
  });

  /// Creates a CurrencyModel from a Currency entity
  factory CurrencyModel.fromEntity(Currency currency) {
    return CurrencyModel(
      code: currency.code,
      name: currency.name,
      symbol: currency.symbol,
      decimalPlaces: currency.decimalPlaces,
      flag: currency.flag,
      isActive: currency.isActive,
    );
  }

  /// Creates a CurrencyModel from JSON
  factory CurrencyModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyModelFromJson(json);

  /// Converts this model to JSON
  Map<String, dynamic> toJson() => _$CurrencyModelToJson(this);

  /// Converts this model to a Currency entity
  Currency toEntity() {
    return Currency(
      code: code,
      name: name,
      symbol: symbol,
      decimalPlaces: decimalPlaces,
      flag: flag,
      isActive: isActive,
    );
  }
}
