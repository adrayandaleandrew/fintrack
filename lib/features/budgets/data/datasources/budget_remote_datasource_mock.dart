import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/budget.dart';
import '../models/budget_model.dart';
import 'budget_remote_datasource.dart';

/// Mock implementation of BudgetRemoteDataSource
///
/// Simulates API calls with in-memory storage and network delay.
/// Used for development and testing before real API integration.
class BudgetRemoteDataSourceMock implements BudgetRemoteDataSource {
  final List<BudgetModel> _budgets = [];
  int _idCounter = 1;

  BudgetRemoteDataSourceMock() {
    _initializeMockData();
  }

  /// Initialize with sample budget data
  void _initializeMockData() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    // Sample budgets for user_1
    _budgets.addAll([
      // Monthly food budget
      BudgetModel(
        id: 'budget_${_idCounter++}',
        userId: 'user_1',
        categoryId: 'cat_1', // Food & Dining
        amount: 500.0,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: monthStart,
        endDate: null,
        alertThreshold: 80.0,
        isActive: true,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 30)),
      ),

      // Monthly transportation budget
      BudgetModel(
        id: 'budget_${_idCounter++}',
        userId: 'user_1',
        categoryId: 'cat_3', // Transportation
        amount: 300.0,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: monthStart,
        endDate: null,
        alertThreshold: 75.0,
        isActive: true,
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now.subtract(const Duration(days: 25)),
      ),

      // Weekly entertainment budget
      BudgetModel(
        id: 'budget_${_idCounter++}',
        userId: 'user_1',
        categoryId: 'cat_5', // Entertainment
        amount: 100.0,
        currency: 'USD',
        period: BudgetPeriod.weekly,
        startDate: monthStart,
        endDate: null,
        alertThreshold: 85.0,
        isActive: true,
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 20)),
      ),

      // Monthly shopping budget (inactive)
      BudgetModel(
        id: 'budget_${_idCounter++}',
        userId: 'user_1',
        categoryId: 'cat_4', // Shopping
        amount: 200.0,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: monthStart.subtract(const Duration(days: 60)),
        endDate: monthStart.subtract(const Duration(days: 1)),
        alertThreshold: 80.0,
        isActive: false,
        createdAt: now.subtract(const Duration(days: 60)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ]);
  }

  /// Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<List<BudgetModel>> getBudgets({
    required String userId,
    bool activeOnly = false,
  }) async {
    await _simulateNetworkDelay();

    var userBudgets = _budgets.where((b) => b.userId == userId);

    if (activeOnly) {
      userBudgets = userBudgets.where((b) => b.isActive);
    }

    return userBudgets.toList();
  }

  @override
  Future<BudgetModel> getBudgetById({required String budgetId}) async {
    await _simulateNetworkDelay();

    try {
      return _budgets.firstWhere((b) => b.id == budgetId);
    } catch (e) {
      throw ServerException('Budget not found: $budgetId');
    }
  }

  @override
  Future<List<BudgetModel>> getBudgetsByCategory({
    required String categoryId,
  }) async {
    await _simulateNetworkDelay();

    return _budgets.where((b) => b.categoryId == categoryId).toList();
  }

  @override
  Future<BudgetModel> createBudget({required BudgetModel budget}) async {
    await _simulateNetworkDelay();

    final now = DateTime.now();
    final newBudget = budget.copyWith(
      id: 'budget_${_idCounter++}',
      createdAt: now,
      updatedAt: now,
    );

    _budgets.add(newBudget);
    return newBudget;
  }

  @override
  Future<BudgetModel> updateBudget({required BudgetModel budget}) async {
    await _simulateNetworkDelay();

    final index = _budgets.indexWhere((b) => b.id == budget.id);
    if (index == -1) {
      throw ServerException('Budget not found: ${budget.id}');
    }

    final updatedBudget = budget.copyWith(updatedAt: DateTime.now());
    _budgets[index] = updatedBudget;
    return updatedBudget;
  }

  @override
  Future<void> deleteBudget({required String budgetId}) async {
    await _simulateNetworkDelay();

    final index = _budgets.indexWhere((b) => b.id == budgetId);
    if (index == -1) {
      throw ServerException('Budget not found: $budgetId');
    }

    _budgets.removeAt(index);
  }
}
