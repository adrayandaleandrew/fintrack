import 'package:equatable/equatable.dart';
import 'budget.dart';

/// Budget usage status
///
/// Represents the current spending status against a budget,
/// including amount spent, remaining, and percentage used.
class BudgetUsage extends Equatable {
  final Budget budget;
  final double spent;
  final DateTime periodStart;
  final DateTime periodEnd;

  const BudgetUsage({
    required this.budget,
    required this.spent,
    required this.periodStart,
    required this.periodEnd,
  });

  /// Amount remaining in budget
  double get remaining => budget.amount - spent;

  /// Percentage of budget used (0-100+)
  double get percentageUsed {
    if (budget.amount == 0) return 0;
    return (spent / budget.amount) * 100;
  }

  /// Check if budget is exceeded
  bool get isOverBudget => spent > budget.amount;

  /// Check if alert threshold has been reached
  bool get shouldAlert => percentageUsed >= budget.alertThreshold;

  /// Status color indicator
  BudgetStatus get status {
    if (isOverBudget) return BudgetStatus.overBudget;
    if (shouldAlert) return BudgetStatus.nearLimit;
    if (percentageUsed >= 50) return BudgetStatus.onTrack;
    return BudgetStatus.safe;
  }

  /// Get status message
  String get statusMessage {
    switch (status) {
      case BudgetStatus.safe:
        return 'Well within budget';
      case BudgetStatus.onTrack:
        return 'On track';
      case BudgetStatus.nearLimit:
        return 'Approaching limit';
      case BudgetStatus.overBudget:
        return 'Over budget';
    }
  }

  /// Days remaining in current period
  int get daysRemaining {
    final now = DateTime.now();
    if (now.isAfter(periodEnd)) return 0;
    return periodEnd.difference(now).inDays;
  }

  /// Check if in current period
  bool get isCurrentPeriod {
    final now = DateTime.now();
    return now.isAfter(periodStart) && now.isBefore(periodEnd);
  }

  @override
  List<Object?> get props => [budget, spent, periodStart, periodEnd];

  @override
  String toString() {
    return 'BudgetUsage(budgetId: ${budget.id}, spent: $spent, remaining: $remaining, percentageUsed: ${percentageUsed.toStringAsFixed(1)}%)';
  }
}

/// Budget status enumeration
enum BudgetStatus {
  safe,      // < 50%
  onTrack,   // 50-80%
  nearLimit, // >= alertThreshold
  overBudget // > 100%
}
