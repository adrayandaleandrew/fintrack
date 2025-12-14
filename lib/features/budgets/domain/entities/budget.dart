import 'package:equatable/equatable.dart';

/// Budget period enumeration
///
/// Defines the time period for which a budget is set.
enum BudgetPeriod {
  daily,
  weekly,
  monthly,
  yearly;

  /// Display name for UI
  String get displayName {
    switch (this) {
      case BudgetPeriod.daily:
        return 'Daily';
      case BudgetPeriod.weekly:
        return 'Weekly';
      case BudgetPeriod.monthly:
        return 'Monthly';
      case BudgetPeriod.yearly:
        return 'Yearly';
    }
  }

  /// Get duration in days for the period
  int get durationInDays {
    switch (this) {
      case BudgetPeriod.daily:
        return 1;
      case BudgetPeriod.weekly:
        return 7;
      case BudgetPeriod.monthly:
        return 30; // Approximate
      case BudgetPeriod.yearly:
        return 365;
    }
  }
}

/// Budget entity representing a spending limit
///
/// Defines a budget for a specific category with a spending limit
/// and time period. Tracks alert thresholds and active status.
class Budget extends Equatable {
  final String id;
  final String userId;
  final String categoryId;
  final double amount;
  final String currency;
  final BudgetPeriod period;
  final DateTime startDate;
  final DateTime? endDate;
  final double alertThreshold; // Percentage (0-100)
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Budget({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.currency,
    required this.period,
    required this.startDate,
    this.endDate,
    this.alertThreshold = 80.0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if budget is currently active based on dates
  bool get isCurrentlyActive {
    if (!isActive) return false;

    final now = DateTime.now();
    if (now.isBefore(startDate)) return false;
    if (endDate != null && now.isAfter(endDate!)) return false;

    return true;
  }

  /// Get the end date for the current period
  DateTime getCurrentPeriodEnd() {
    final now = DateTime.now();

    switch (period) {
      case BudgetPeriod.daily:
        return DateTime(now.year, now.month, now.day, 23, 59, 59);
      case BudgetPeriod.weekly:
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        return weekStart
            .add(const Duration(days: 6))
            .copyWith(hour: 23, minute: 59, second: 59);
      case BudgetPeriod.monthly:
        return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
      case BudgetPeriod.yearly:
        return DateTime(now.year, 12, 31, 23, 59, 59);
    }
  }

  /// Get the start date for the current period
  DateTime getCurrentPeriodStart() {
    final now = DateTime.now();

    switch (period) {
      case BudgetPeriod.daily:
        return DateTime(now.year, now.month, now.day, 0, 0, 0);
      case BudgetPeriod.weekly:
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        return DateTime(weekStart.year, weekStart.month, weekStart.day, 0, 0, 0);
      case BudgetPeriod.monthly:
        return DateTime(now.year, now.month, 1, 0, 0, 0);
      case BudgetPeriod.yearly:
        return DateTime(now.year, 1, 1, 0, 0, 0);
    }
  }

  /// Check if the budget has an end date
  bool get hasEndDate => endDate != null;

  /// Check if alert threshold has been reached
  bool shouldAlert(double spentPercentage) {
    return spentPercentage >= alertThreshold;
  }

  /// Copy with method for creating modified copies
  Budget copyWith({
    String? id,
    String? userId,
    String? categoryId,
    double? amount,
    String? currency,
    BudgetPeriod? period,
    DateTime? startDate,
    DateTime? endDate,
    double? alertThreshold,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Budget(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      alertThreshold: alertThreshold ?? this.alertThreshold,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        categoryId,
        amount,
        currency,
        period,
        startDate,
        endDate,
        alertThreshold,
        isActive,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Budget(id: $id, categoryId: $categoryId, amount: $amount, period: $period, isActive: $isActive)';
  }
}
