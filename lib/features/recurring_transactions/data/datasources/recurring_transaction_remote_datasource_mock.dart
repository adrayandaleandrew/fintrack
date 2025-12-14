import '../../../../core/errors/exceptions.dart';
import '../../../transactions/data/models/transaction_model.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../domain/entities/recurring_transaction.dart';
import '../models/recurring_transaction_model.dart';
import 'recurring_transaction_remote_datasource.dart';

/// Mock implementation of RecurringTransactionRemoteDataSource
///
/// Simulates API calls with in-memory storage and network delay.
/// Includes logic for auto-generating transactions from templates.
class RecurringTransactionRemoteDataSourceMock
    implements RecurringTransactionRemoteDataSource {
  final List<RecurringTransactionModel> _recurringTransactions = [];
  int _idCounter = 1;
  int _transactionIdCounter = 1;

  RecurringTransactionRemoteDataSourceMock() {
    _initializeMockData();
  }

  /// Initialize with sample recurring transaction data
  void _initializeMockData() {
    final now = DateTime.now();

    // Sample recurring transactions for user_1
    _recurringTransactions.addAll([
      // Monthly salary (income)
      RecurringTransactionModel(
        id: 'recurring_${_idCounter++}',
        userId: 'user_1',
        accountId: 'account_1', // Checking account
        categoryId: 'cat_11', // Salary category
        type: TransactionType.income,
        amount: 5000.0,
        currency: 'USD',
        description: 'Monthly Salary',
        notes: 'Direct deposit paycheck',
        tags: const ['salary', 'income'],
        frequency: RecurringFrequency.monthly,
        startDate: DateTime(now.year, now.month, 1),
        endDate: null,
        lastProcessedDate: DateTime(now.year, now.month, 1),
        maxOccurrences: null,
        occurrenceCount: 1,
        isActive: true,
        createdAt: now.subtract(const Duration(days: 60)),
        updatedAt: now.subtract(const Duration(days: 60)),
      ),

      // Weekly grocery shopping (expense)
      RecurringTransactionModel(
        id: 'recurring_${_idCounter++}',
        userId: 'user_1',
        accountId: 'account_1',
        categoryId: 'cat_10', // Groceries
        type: TransactionType.expense,
        amount: 150.0,
        currency: 'USD',
        description: 'Weekly Groceries',
        notes: 'Supermarket shopping',
        tags: const ['groceries', 'food'],
        frequency: RecurringFrequency.weekly,
        startDate: now.subtract(const Duration(days: 7)),
        endDate: null,
        lastProcessedDate: now.subtract(const Duration(days: 7)),
        maxOccurrences: null,
        occurrenceCount: 8,
        isActive: true,
        createdAt: now.subtract(const Duration(days: 56)),
        updatedAt: now.subtract(const Duration(days: 7)),
      ),

      // Monthly rent (expense)
      RecurringTransactionModel(
        id: 'recurring_${_idCounter++}',
        userId: 'user_1',
        accountId: 'account_1',
        categoryId: 'cat_6', // Bills & Utilities
        type: TransactionType.expense,
        amount: 1500.0,
        currency: 'USD',
        description: 'Monthly Rent',
        notes: 'Apartment rent payment',
        tags: const ['rent', 'housing'],
        frequency: RecurringFrequency.monthly,
        startDate: DateTime(now.year, now.month, 5),
        endDate: null,
        lastProcessedDate: DateTime(now.year, now.month, 5),
        maxOccurrences: null,
        occurrenceCount: 1,
        isActive: true,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 30)),
      ),

      // Quarterly insurance (expense) - inactive
      RecurringTransactionModel(
        id: 'recurring_${_idCounter++}',
        userId: 'user_1',
        accountId: 'account_1',
        categoryId: 'cat_12', // Insurance
        type: TransactionType.expense,
        amount: 450.0,
        currency: 'USD',
        description: 'Car Insurance',
        notes: 'Quarterly premium',
        tags: const ['insurance', 'auto'],
        frequency: RecurringFrequency.quarterly,
        startDate: DateTime(now.year, 1, 15),
        endDate: DateTime(now.year, 12, 31),
        lastProcessedDate: DateTime(now.year, 10, 15),
        maxOccurrences: 4,
        occurrenceCount: 4,
        isActive: false,
        createdAt: DateTime(now.year, 1, 1),
        updatedAt: DateTime(now.year, 10, 15),
      ),
    ]);
  }

  /// Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<List<RecurringTransactionModel>> getRecurringTransactions({
    required String userId,
    bool activeOnly = false,
  }) async {
    await _simulateNetworkDelay();

    var userRecurring =
        _recurringTransactions.where((r) => r.userId == userId);

    if (activeOnly) {
      userRecurring = userRecurring.where((r) => r.isActive);
    }

    return userRecurring.toList();
  }

  @override
  Future<RecurringTransactionModel> getRecurringTransactionById({
    required String recurringTransactionId,
  }) async {
    await _simulateNetworkDelay();

    try {
      return _recurringTransactions
          .firstWhere((r) => r.id == recurringTransactionId);
    } catch (e) {
      throw ServerException(
        'Recurring transaction not found: $recurringTransactionId',
      );
    }
  }

  @override
  Future<List<RecurringTransactionModel>> getRecurringTransactionsByAccount({
    required String accountId,
  }) async {
    await _simulateNetworkDelay();

    return _recurringTransactions
        .where((r) => r.accountId == accountId)
        .toList();
  }

  @override
  Future<List<RecurringTransactionModel>> getRecurringTransactionsByCategory({
    required String categoryId,
  }) async {
    await _simulateNetworkDelay();

    return _recurringTransactions
        .where((r) => r.categoryId == categoryId)
        .toList();
  }

  @override
  Future<RecurringTransactionModel> createRecurringTransaction({
    required RecurringTransactionModel recurringTransaction,
  }) async {
    await _simulateNetworkDelay();

    final now = DateTime.now();
    final newRecurring = recurringTransaction.copyWith(
      id: 'recurring_${_idCounter++}',
      occurrenceCount: 0,
      createdAt: now,
      updatedAt: now,
    );

    _recurringTransactions.add(newRecurring);
    return newRecurring;
  }

  @override
  Future<RecurringTransactionModel> updateRecurringTransaction({
    required RecurringTransactionModel recurringTransaction,
  }) async {
    await _simulateNetworkDelay();

    final index =
        _recurringTransactions.indexWhere((r) => r.id == recurringTransaction.id);
    if (index == -1) {
      throw ServerException(
        'Recurring transaction not found: ${recurringTransaction.id}',
      );
    }

    final updatedRecurring = recurringTransaction.copyWith(
      updatedAt: DateTime.now(),
    );
    _recurringTransactions[index] = updatedRecurring;
    return updatedRecurring;
  }

  @override
  Future<void> deleteRecurringTransaction({
    required String recurringTransactionId,
  }) async {
    await _simulateNetworkDelay();

    final index =
        _recurringTransactions.indexWhere((r) => r.id == recurringTransactionId);
    if (index == -1) {
      throw ServerException(
        'Recurring transaction not found: $recurringTransactionId',
      );
    }

    _recurringTransactions.removeAt(index);
  }

  @override
  Future<List<RecurringTransactionModel>> getDueRecurringTransactions() async {
    await _simulateNetworkDelay();

    final now = DateTime.now();
    return _recurringTransactions.where((r) {
      if (!r.isCurrentlyActive) return false;
      return r.isDue();
    }).toList();
  }

  @override
  Future<TransactionModel> generateTransaction({
    required String recurringTransactionId,
    required DateTime occurrenceDate,
  }) async {
    await _simulateNetworkDelay();

    final recurring = await getRecurringTransactionById(
      recurringTransactionId: recurringTransactionId,
    );

    // Create transaction from recurring template
    final transaction = TransactionModel(
      id: 'transaction_${_transactionIdCounter++}',
      userId: recurring.userId,
      accountId: recurring.accountId,
      categoryId: recurring.categoryId,
      type: recurring.type,
      amount: recurring.amount,
      currency: recurring.currency,
      description: recurring.description,
      notes: recurring.notes ?? 'Auto-generated from recurring transaction',
      tags: [...recurring.tags, 'recurring'],
      date: occurrenceDate,
      receiptUrl: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Update recurring transaction with new occurrence count and last processed date
    final updatedRecurring = recurring.copyWith(
      occurrenceCount: recurring.occurrenceCount + 1,
      lastProcessedDate: occurrenceDate,
      updatedAt: DateTime.now(),
    );

    final index =
        _recurringTransactions.indexWhere((r) => r.id == recurringTransactionId);
    if (index != -1) {
      _recurringTransactions[index] = updatedRecurring;
    }

    return transaction;
  }
}
