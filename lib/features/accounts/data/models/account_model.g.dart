// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$AccountTypeEnumMap, json['type']),
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      notes: json['notes'] as String?,
      creditLimit: (json['creditLimit'] as num?)?.toDouble(),
      interestRate: (json['interestRate'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'type': _$AccountTypeEnumMap[instance.type]!,
      'balance': instance.balance,
      'currency': instance.currency,
      'icon': instance.icon,
      'color': instance.color,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'notes': instance.notes,
      'creditLimit': instance.creditLimit,
      'interestRate': instance.interestRate,
    };

const _$AccountTypeEnumMap = {
  AccountType.bank: 'bank',
  AccountType.cash: 'cash',
  AccountType.creditCard: 'creditCard',
  AccountType.investment: 'investment',
};
