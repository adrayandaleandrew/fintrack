import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_budgets.dart';
import '../../domain/usecases/create_budget.dart' as usecases;
import '../../domain/usecases/update_budget.dart' as usecases;
import '../../domain/usecases/delete_budget.dart' as usecases;
import '../../domain/usecases/calculate_budget_usage.dart';
import '../../domain/entities/budget_usage.dart';
import 'budget_event.dart';
import 'budget_state.dart';

/// BLoC for managing budget state
///
/// Handles budget CRUD operations and usage calculations.
class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final GetBudgets getBudgets;
  final usecases.CreateBudget createBudget;
  final usecases.UpdateBudget updateBudget;
  final usecases.DeleteBudget deleteBudget;
  final CalculateBudgetUsage calculateBudgetUsage;

  BudgetBloc({
    required this.getBudgets,
    required this.createBudget,
    required this.updateBudget,
    required this.deleteBudget,
    required this.calculateBudgetUsage,
  }) : super(const BudgetInitial()) {
    on<LoadBudgets>(_onLoadBudgets);
    on<RefreshBudgets>(_onRefreshBudgets);
    on<CreateBudget>(_onCreateBudget);
    on<UpdateBudget>(_onUpdateBudget);
    on<DeleteBudget>(_onDeleteBudget);
    on<LoadBudgetUsage>(_onLoadBudgetUsage);
    on<FilterBudgets>(_onFilterBudgets);
  }

  /// Load all budgets for a user
  Future<void> _onLoadBudgets(
    LoadBudgets event,
    Emitter<BudgetState> emit,
  ) async {
    emit(const BudgetLoading());

    final result = await getBudgets(
      GetBudgetsParams(
        userId: event.userId,
        activeOnly: event.activeOnly,
      ),
    );

    result.fold(
      (failure) => emit(BudgetError(message: failure.message)),
      (budgets) async {
        // Load usage for all budgets
        final usages = <String, BudgetUsage>{};
        for (final budget in budgets) {
          final usageResult = await calculateBudgetUsage(
            CalculateBudgetUsageParams(budgetId: budget.id),
          );
          usageResult.fold(
            (_) {}, // Ignore errors for individual budgets
            (usage) => usages[budget.id] = usage,
          );
        }

        emit(BudgetsLoaded(budgets: budgets, usages: usages));
      },
    );
  }

  /// Refresh budgets without showing loading state
  Future<void> _onRefreshBudgets(
    RefreshBudgets event,
    Emitter<BudgetState> emit,
  ) async {
    final result = await getBudgets(
      GetBudgetsParams(
        userId: event.userId,
        activeOnly: event.activeOnly,
      ),
    );

    result.fold(
      (failure) => emit(BudgetError(message: failure.message)),
      (budgets) async {
        // Load usage for all budgets
        final usages = <String, BudgetUsage>{};
        for (final budget in budgets) {
          final usageResult = await calculateBudgetUsage(
            CalculateBudgetUsageParams(budgetId: budget.id),
          );
          usageResult.fold(
            (_) {}, // Ignore errors for individual budgets
            (usage) => usages[budget.id] = usage,
          );
        }

        emit(BudgetsLoaded(budgets: budgets, usages: usages));
      },
    );
  }

  /// Create a new budget
  Future<void> _onCreateBudget(
    CreateBudget event,
    Emitter<BudgetState> emit,
  ) async {
    final currentState = state;

    final result = await createBudget(
      usecases.CreateBudgetParams(budget: event.budget),
    );

    result.fold(
      (failure) => emit(BudgetError(message: failure.message)),
      (budget) {
        emit(const BudgetActionSuccess(message: 'Budget created successfully'));

        // Reload budgets if we were in a loaded state
        if (currentState is BudgetsLoaded) {
          add(LoadBudgets(userId: budget.userId));
        }
      },
    );
  }

  /// Update an existing budget
  Future<void> _onUpdateBudget(
    UpdateBudget event,
    Emitter<BudgetState> emit,
  ) async {
    final currentState = state;

    final result = await updateBudget(
      usecases.UpdateBudgetParams(budget: event.budget),
    );

    result.fold(
      (failure) => emit(BudgetError(message: failure.message)),
      (budget) {
        emit(const BudgetActionSuccess(message: 'Budget updated successfully'));

        // Reload budgets if we were in a loaded state
        if (currentState is BudgetsLoaded) {
          add(LoadBudgets(userId: budget.userId));
        }
      },
    );
  }

  /// Delete a budget
  Future<void> _onDeleteBudget(
    DeleteBudget event,
    Emitter<BudgetState> emit,
  ) async {
    final currentState = state;

    final result = await deleteBudget(
      usecases.DeleteBudgetParams(budgetId: event.budgetId),
    );

    result.fold(
      (failure) => emit(BudgetError(message: failure.message)),
      (_) {
        emit(const BudgetActionSuccess(message: 'Budget deleted successfully'));

        // Reload budgets if we were in a loaded state
        if (currentState is BudgetsLoaded) {
          final budgets = currentState.budgets
              .where((b) => b.id != event.budgetId)
              .toList();
          final usages = Map<String, BudgetUsage>.from(currentState.usages)
            ..remove(event.budgetId);
          emit(BudgetsLoaded(budgets: budgets, usages: usages));
        }
      },
    );
  }

  /// Load usage for a specific budget
  Future<void> _onLoadBudgetUsage(
    LoadBudgetUsage event,
    Emitter<BudgetState> emit,
  ) async {
    final result = await calculateBudgetUsage(
      CalculateBudgetUsageParams(budgetId: event.budgetId),
    );

    result.fold(
      (failure) => emit(BudgetError(message: failure.message)),
      (usage) {
        // Update usages in current state if loaded
        if (state is BudgetsLoaded) {
          final currentState = state as BudgetsLoaded;
          final updatedUsages = Map<String, BudgetUsage>.from(currentState.usages);
          updatedUsages[event.budgetId] = usage;
          emit(currentState.copyWith(usages: updatedUsages));
        } else {
          emit(BudgetUsageLoaded(usage: usage));
        }
      },
    );
  }

  /// Filter budgets
  Future<void> _onFilterBudgets(
    FilterBudgets event,
    Emitter<BudgetState> emit,
  ) async {
    emit(const BudgetLoading());

    final result = await getBudgets(
      GetBudgetsParams(
        userId: event.userId,
        activeOnly: event.activeOnly ?? false,
      ),
    );

    result.fold(
      (failure) => emit(BudgetError(message: failure.message)),
      (budgets) async {
        // Apply category filter if provided
        var filteredBudgets = budgets;
        if (event.categoryId != null) {
          filteredBudgets = budgets
              .where((b) => b.categoryId == event.categoryId)
              .toList();
        }

        // Load usage for filtered budgets
        final usages = <String, BudgetUsage>{};
        for (final budget in filteredBudgets) {
          final usageResult = await calculateBudgetUsage(
            CalculateBudgetUsageParams(budgetId: budget.id),
          );
          usageResult.fold(
            (_) {}, // Ignore errors for individual budgets
            (usage) => usages[budget.id] = usage,
          );
        }

        emit(BudgetsLoaded(budgets: filteredBudgets, usages: usages));
      },
    );
  }
}
