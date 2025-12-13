import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/transaction.dart';

part 'transaction_model.g.dart';

/// Transaction model for JSON serialization
///
/// Extends the domain Transaction entity and adds JSON conversion capabilities.
@JsonSerializable(explicitToJson: true)
class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.userId,
    required super.accountId,
    required super.categoryId,
    required super.type,
    required super.amount,
    required super.currency,
    required super.description,
    required super.date,
    super.notes,
    super.tags,
    super.receiptUrl,
    super.toAccountId,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Creates a TransactionModel from JSON
  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  /// Converts this model to JSON
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  /// Creates a TransactionModel from a Transaction entity
  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      userId: transaction.userId,
      accountId: transaction.accountId,
      categoryId: transaction.categoryId,
      type: transaction.type,
      amount: transaction.amount,
      currency: transaction.currency,
      description: transaction.description,
      date: transaction.date,
      notes: transaction.notes,
      tags: transaction.tags,
      receiptUrl: transaction.receiptUrl,
      toAccountId: transaction.toAccountId,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
    );
  }

  /// Converts this model to a Transaction entity
  Transaction toEntity() {
    return Transaction(
      id: id,
      userId: userId,
      accountId: accountId,
      categoryId: categoryId,
      type: type,
      amount: amount,
      currency: currency,
      description: description,
      date: date,
      notes: notes,
      tags: tags,
      receiptUrl: receiptUrl,
      toAccountId: toAccountId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Creates a copy with updated fields
  @override
  TransactionModel copyWith({
    String? id,
    String? userId,
    String? accountId,
    String? categoryId,
    TransactionType? type,
    double? amount,
    String? currency,
    String? description,
    DateTime? date,
    String? notes,
    List<String>? tags,
    String? receiptUrl,
    String? toAccountId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      toAccountId: toAccountId ?? this.toAccountId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
