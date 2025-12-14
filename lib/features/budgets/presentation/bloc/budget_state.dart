import 'package:equatable/equatable.dart';
import '../../domain/entities/budget.dart';
import '../../domain/entities/budget_usage.dart';

/// Base class for all budget states
abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any budgets are loaded
class BudgetInitial extends BudgetState {
  const BudgetInitial();
}

/// Loading state when fetching budgets
class BudgetLoading extends BudgetState {
  const BudgetLoading();
}

/// State when budgets are successfully loaded
class BudgetsLoaded extends BudgetState {
  final List<Budget> budgets;
  final Map<String, BudgetUsage> usages;

  const BudgetsLoaded({
    required this.budgets,
    this.usages = const {},
  });

  @override
  List<Object?> get props => [budgets, usages];

  /// Get usage for a specific budget
  BudgetUsage? getUsage(String budgetId) => usages[budgetId];

  /// Check if usage is loaded for a budget
  bool hasUsage(String budgetId) => usages.containsKey(budgetId);

  /// Get budgets that should alert
  List<Budget> get alertBudgets {
    return budgets.where((budget) {
      final usage = usages[budget.id];
      return usage != null && usage.shouldAlert;
    }).toList();
  }

  /// Copy with updated values
  BudgetsLoaded copyWith({
    List<Budget>? budgets,
    Map<String, BudgetUsage>? usages,
  }) {
    return BudgetsLoaded(
      budgets: budgets ?? this.budgets,
      usages: usages ?? this.usages,
    );
  }
}

/// State when a budget action was successful
class BudgetActionSuccess extends BudgetState {
  final String message;

  const BudgetActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when budget usage is loaded
class BudgetUsageLoaded extends BudgetState {
  final BudgetUsage usage;

  const BudgetUsageLoaded({required this.usage});

  @override
  List<Object?> get props => [usage];
}

/// Error state when something goes wrong
class BudgetError extends BudgetState {
  final String message;

  const BudgetError({required this.message});

  @override
  List<Object?> get props => [message];
}
