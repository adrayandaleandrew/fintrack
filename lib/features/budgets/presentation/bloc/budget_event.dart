import 'package:equatable/equatable.dart';
import '../../domain/entities/budget.dart';

/// Base class for all budget events
abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all budgets for a user
class LoadBudgets extends BudgetEvent {
  final String userId;
  final bool activeOnly;

  const LoadBudgets({
    required this.userId,
    this.activeOnly = false,
  });

  @override
  List<Object?> get props => [userId, activeOnly];
}

/// Event to refresh budgets
class RefreshBudgets extends BudgetEvent {
  final String userId;
  final bool activeOnly;

  const RefreshBudgets({
    required this.userId,
    this.activeOnly = false,
  });

  @override
  List<Object?> get props => [userId, activeOnly];
}

/// Event to create a new budget
class CreateBudget extends BudgetEvent {
  final Budget budget;

  const CreateBudget({required this.budget});

  @override
  List<Object?> get props => [budget];
}

/// Event to update an existing budget
class UpdateBudget extends BudgetEvent {
  final Budget budget;

  const UpdateBudget({required this.budget});

  @override
  List<Object?> get props => [budget];
}

/// Event to delete a budget
class DeleteBudget extends BudgetEvent {
  final String budgetId;

  const DeleteBudget({required this.budgetId});

  @override
  List<Object?> get props => [budgetId];
}

/// Event to load budget usage (spent amount)
class LoadBudgetUsage extends BudgetEvent {
  final String budgetId;

  const LoadBudgetUsage({required this.budgetId});

  @override
  List<Object?> get props => [budgetId];
}

/// Event to filter budgets
class FilterBudgets extends BudgetEvent {
  final String userId;
  final bool? activeOnly;
  final String? categoryId;

  const FilterBudgets({
    required this.userId,
    this.activeOnly,
    this.categoryId,
  });

  @override
  List<Object?> get props => [userId, activeOnly, categoryId];
}
