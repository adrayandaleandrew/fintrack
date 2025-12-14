import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/budget.dart';
import '../entities/budget_usage.dart';

/// Budget repository interface
///
/// Defines contracts for budget data operations.
/// Implementations can use mock data or real API.
abstract class BudgetRepository {
  /// Get all budgets for a user
  ///
  /// [userId] - User identifier
  /// [activeOnly] - If true, returns only active budgets
  /// Returns list of budgets or failure
  Future<Either<Failure, List<Budget>>> getBudgets({
    required String userId,
    bool activeOnly = false,
  });

  /// Get a single budget by ID
  ///
  /// [budgetId] - Budget identifier
  /// Returns budget or failure
  Future<Either<Failure, Budget>> getBudgetById({
    required String budgetId,
  });

  /// Get budgets for a specific category
  ///
  /// [categoryId] - Category identifier
  /// Returns list of budgets or failure
  Future<Either<Failure, List<Budget>>> getBudgetsByCategory({
    required String categoryId,
  });

  /// Create a new budget
  ///
  /// [budget] - Budget entity to create
  /// Returns created budget with generated ID or failure
  Future<Either<Failure, Budget>> createBudget({
    required Budget budget,
  });

  /// Update an existing budget
  ///
  /// [budget] - Budget entity with updated values
  /// Returns updated budget or failure
  Future<Either<Failure, Budget>> updateBudget({
    required Budget budget,
  });

  /// Delete a budget
  ///
  /// [budgetId] - Budget identifier
  /// Returns success or failure
  Future<Either<Failure, void>> deleteBudget({
    required String budgetId,
  });

  /// Calculate budget usage for current period
  ///
  /// [budgetId] - Budget identifier
  /// Returns budget usage with spent amount or failure
  Future<Either<Failure, BudgetUsage>> calculateBudgetUsage({
    required String budgetId,
  });

  /// Get budget usage for multiple budgets
  ///
  /// [budgetIds] - List of budget identifiers
  /// Returns map of budget ID to usage or failure
  Future<Either<Failure, Map<String, BudgetUsage>>> getBudgetUsages({
    required List<String> budgetIds,
  });

  /// Check if budget limit has been reached
  ///
  /// [budgetId] - Budget identifier
  /// Returns true if over budget or at alert threshold
  Future<Either<Failure, bool>> shouldAlert({
    required String budgetId,
  });
}
