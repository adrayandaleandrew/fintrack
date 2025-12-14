// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringTransactionModel _$RecurringTransactionModelFromJson(
        Map<String, dynamic> json) =>
    RecurringTransactionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      accountId: json['accountId'] as String,
      categoryId: json['categoryId'] as String,
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      description: json['description'] as String,
      notes: json['notes'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      frequency: $enumDecode(_$RecurringFrequencyEnumMap, json['frequency']),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      lastProcessedDate: json['lastProcessedDate'] == null
          ? null
          : DateTime.parse(json['lastProcessedDate'] as String),
      maxOccurrences: (json['maxOccurrences'] as num?)?.toInt(),
      occurrenceCount: (json['occurrenceCount'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RecurringTransactionModelToJson(
        RecurringTransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'accountId': instance.accountId,
      'categoryId': instance.categoryId,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'amount': instance.amount,
      'currency': instance.currency,
      'description': instance.description,
      'notes': instance.notes,
      'tags': instance.tags,
      'frequency': _$RecurringFrequencyEnumMap[instance.frequency]!,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'lastProcessedDate': instance.lastProcessedDate?.toIso8601String(),
      'maxOccurrences': instance.maxOccurrences,
      'occurrenceCount': instance.occurrenceCount,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
  TransactionType.transfer: 'transfer',
};

const _$RecurringFrequencyEnumMap = {
  RecurringFrequency.daily: 'daily',
  RecurringFrequency.weekly: 'weekly',
  RecurringFrequency.biweekly: 'biweekly',
  RecurringFrequency.monthly: 'monthly',
  RecurringFrequency.quarterly: 'quarterly',
  RecurringFrequency.yearly: 'yearly',
};
