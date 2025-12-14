import 'package:equatable/equatable.dart';
import '../../../transactions/domain/entities/transaction.dart';

/// Recurring frequency enumeration
///
/// Defines how often a recurring transaction should be generated.
enum RecurringFrequency {
  daily,
  weekly,
  biweekly,
  monthly,
  quarterly,
  yearly;

  /// Display name for UI
  String get displayName {
    switch (this) {
      case RecurringFrequency.daily:
        return 'Daily';
      case RecurringFrequency.weekly:
        return 'Weekly';
      case RecurringFrequency.biweekly:
        return 'Every 2 Weeks';
      case RecurringFrequency.monthly:
        return 'Monthly';
      case RecurringFrequency.quarterly:
        return 'Quarterly';
      case RecurringFrequency.yearly:
        return 'Yearly';
    }
  }

  /// Get duration in days for the frequency
  int get durationInDays {
    switch (this) {
      case RecurringFrequency.daily:
        return 1;
      case RecurringFrequency.weekly:
        return 7;
      case RecurringFrequency.biweekly:
        return 14;
      case RecurringFrequency.monthly:
        return 30; // Approximate
      case RecurringFrequency.quarterly:
        return 90; // Approximate
      case RecurringFrequency.yearly:
        return 365;
    }
  }
}

/// Recurring transaction entity
///
/// Represents a template for transactions that should be
/// automatically generated on a recurring schedule.
class RecurringTransaction extends Equatable {
  final String id;
  final String userId;
  final String accountId;
  final String categoryId;
  final TransactionType type;
  final double amount;
  final String currency;
  final String description;
  final String? notes;
  final List<String> tags;
  final RecurringFrequency frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? lastProcessedDate;
  final int? maxOccurrences;
  final int occurrenceCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RecurringTransaction({
    required this.id,
    required this.userId,
    required this.accountId,
    required this.categoryId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.description,
    this.notes,
    this.tags = const [],
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.lastProcessedDate,
    this.maxOccurrences,
    this.occurrenceCount = 0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if recurring transaction is currently active
  bool get isCurrentlyActive {
    if (!isActive) return false;

    final now = DateTime.now();
    if (now.isBefore(startDate)) return false;
    if (endDate != null && now.isAfter(endDate!)) return false;
    if (maxOccurrences != null && occurrenceCount >= maxOccurrences!) {
      return false;
    }

    return true;
  }

  /// Check if recurring transaction has ended
  bool get hasEnded {
    final now = DateTime.now();
    if (endDate != null && now.isAfter(endDate!)) return true;
    if (maxOccurrences != null && occurrenceCount >= maxOccurrences!) {
      return true;
    }
    return false;
  }

  /// Calculate next occurrence date
  DateTime? getNextOccurrence() {
    if (!isCurrentlyActive) return null;

    final baseDate = lastProcessedDate ?? startDate;
    DateTime nextDate;

    switch (frequency) {
      case RecurringFrequency.daily:
        nextDate = DateTime(
          baseDate.year,
          baseDate.month,
          baseDate.day + 1,
        );
        break;
      case RecurringFrequency.weekly:
        nextDate = DateTime(
          baseDate.year,
          baseDate.month,
          baseDate.day + 7,
        );
        break;
      case RecurringFrequency.biweekly:
        nextDate = DateTime(
          baseDate.year,
          baseDate.month,
          baseDate.day + 14,
        );
        break;
      case RecurringFrequency.monthly:
        nextDate = DateTime(
          baseDate.year,
          baseDate.month + 1,
          baseDate.day,
        );
        break;
      case RecurringFrequency.quarterly:
        nextDate = DateTime(
          baseDate.year,
          baseDate.month + 3,
          baseDate.day,
        );
        break;
      case RecurringFrequency.yearly:
        nextDate = DateTime(
          baseDate.year + 1,
          baseDate.month,
          baseDate.day,
        );
        break;
    }

    // Check if next occurrence is beyond end date
    if (endDate != null && nextDate.isAfter(endDate!)) {
      return null;
    }

    // Check if max occurrences reached
    if (maxOccurrences != null && occurrenceCount >= maxOccurrences!) {
      return null;
    }

    return nextDate;
  }

  /// Check if transaction is due to be generated
  bool isDue() {
    final nextOccurrence = getNextOccurrence();
    if (nextOccurrence == null) return false;

    final now = DateTime.now();
    return now.isAfter(nextOccurrence) || now.isAtSameMomentAs(nextOccurrence);
  }

  /// Get remaining occurrences
  int? getRemainingOccurrences() {
    if (maxOccurrences == null) return null;
    final remaining = maxOccurrences! - occurrenceCount;
    return remaining > 0 ? remaining : 0;
  }

  /// Copy with method for creating modified copies
  RecurringTransaction copyWith({
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
    return RecurringTransaction(
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

  @override
  List<Object?> get props => [
        id,
        userId,
        accountId,
        categoryId,
        type,
        amount,
        currency,
        description,
        notes,
        tags,
        frequency,
        startDate,
        endDate,
        lastProcessedDate,
        maxOccurrences,
        occurrenceCount,
        isActive,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'RecurringTransaction(id: $id, description: $description, frequency: $frequency, amount: $amount, isActive: $isActive)';
  }
}
