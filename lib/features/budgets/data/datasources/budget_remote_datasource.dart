import '../models/budget_model.dart';

/// Budget remote data source interface
///
/// Defines contracts for budget API operations.
/// Can be implemented with mock data or real API.
abstract class BudgetRemoteDataSource {
  /// Get all budgets for a user
  ///
  /// [userId] - User identifier
  /// [activeOnly] - If true, returns only active budgets
  /// Returns list of budget models
  /// Throws ServerException on error
  Future<List<BudgetModel>> getBudgets({
    required String userId,
    bool activeOnly = false,
  });

  /// Get a single budget by ID
  ///
  /// [budgetId] - Budget identifier
  /// Returns budget model
  /// Throws ServerException if not found or on error
  Future<BudgetModel> getBudgetById({
    required String budgetId,
  });

  /// Get budgets for a specific category
  ///
  /// [categoryId] - Category identifier
  /// Returns list of budget models
  /// Throws ServerException on error
  Future<List<BudgetModel>> getBudgetsByCategory({
    required String categoryId,
  });

  /// Create a new budget
  ///
  /// [budget] - Budget model to create
  /// Returns created budget with generated ID
  /// Throws ServerException on error
  Future<BudgetModel> createBudget({
    required BudgetModel budget,
  });

  /// Update an existing budget
  ///
  /// [budget] - Budget model with updated values
  /// Returns updated budget
  /// Throws ServerException if not found or on error
  Future<BudgetModel> updateBudget({
    required BudgetModel budget,
  });

  /// Delete a budget
  ///
  /// [budgetId] - Budget identifier
  /// Throws ServerException if not found or on error
  Future<void> deleteBudget({
    required String budgetId,
  });
}
