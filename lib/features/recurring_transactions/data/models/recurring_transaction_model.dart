import 'package:json_annotation/json_annotation.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../domain/entities/recurring_transaction.dart';

part 'recurring_transaction_model.g.dart';

/// Recurring transaction model for JSON serialization
///
/// Extends RecurringTransaction entity with JSON serialization capabilities.
@JsonSerializable(explicitToJson: true)
class RecurringTransactionModel extends RecurringTransaction {
  const RecurringTransactionModel({
    required super.id,
    required super.userId,
    required super.accountId,
    required super.categoryId,
    required super.type,
    required super.amount,
    required super.currency,
    required super.description,
    super.notes,
    super.tags,
    required super.frequency,
    required super.startDate,
    super.endDate,
    super.lastProcessedDate,
    super.maxOccurrences,
    super.occurrenceCount,
    super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Create RecurringTransactionModel from RecurringTransaction entity
  factory RecurringTransactionModel.fromEntity(RecurringTransaction recurring) {
    return RecurringTransactionModel(
      id: recurring.id,
      userId: recurring.userId,
      accountId: recurring.accountId,
      categoryId: recurring.categoryId,
      type: recurring.type,
      amount: recurring.amount,
      currency: recurring.currency,
      description: recurring.description,
      notes: recurring.notes,
      tags: recurring.tags,
      frequency: recurring.frequency,
      startDate: recurring.startDate,
      endDate: recurring.endDate,
      lastProcessedDate: recurring.lastProcessedDate,
      maxOccurrences: recurring.maxOccurrences,
      occurrenceCount: recurring.occurrenceCount,
      isActive: recurring.isActive,
      createdAt: recurring.createdAt,
      updatedAt: recurring.updatedAt,
    );
  }

  /// Create RecurringTransactionModel from JSON
  factory RecurringTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$RecurringTransactionModelFromJson(json);

  /// Convert RecurringTransactionModel to JSON
  Map<String, dynamic> toJson() => _$RecurringTransactionModelToJson(this);

  /// Convert to RecurringTransaction entity
  RecurringTransaction toEntity() {
    return RecurringTransaction(
      id: id,
      userId: userId,
      accountId: accountId,
      categoryId: categoryId,
      type: type,
      amount: amount,
      currency: currency,
      description: description,
      notes: notes,
      tags: tags,
      frequency: frequency,
      startDate: startDate,
      endDate: endDate,
      lastProcessedDate: lastProcessedDate,
      maxOccurrences: maxOccurrences,
      occurrenceCount: occurrenceCount,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create a copy with updated fields
  @override
  RecurringTransactionModel copyWith({
    String? id,
    String? userId,
    String? accountId,
    String? categoryId,
    TransactionType? type,
    double? amount,
    String? currency,
    String? description,
    String? notes,
    List<String>? tags,
    RecurringFrequency? frequency,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? lastProcessedDate,
    int? maxOccurrences,
    int? occurrenceCount,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RecurringTransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      tags: tags ?? this.tags,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      lastProcessedDate: lastProcessedDate ?? this.lastProcessedDate,
      maxOccurrences: maxOccurrences ?? this.maxOccurrences,
      occurrenceCount: occurrenceCount ?? this.occurrenceCount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
