// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyModel _$CurrencyModelFromJson(Map<String, dynamic> json) =>
    CurrencyModel(
      code: json['code'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      decimalPlaces: (json['decimalPlaces'] as num).toInt(),
      flag: json['flag'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$CurrencyModelToJson(CurrencyModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'symbol': instance.symbol,
      'decimalPlaces': instance.decimalPlaces,
      'flag': instance.flag,
      'isActive': instance.isActive,
    };
