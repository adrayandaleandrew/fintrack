import 'package:uuid/uuid.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../accounts/data/datasources/account_remote_datasource.dart';
import '../../../accounts/data/models/account_model.dart';
import '../models/transaction_model.dart';
import '../../domain/entities/transaction.dart';
import 'transaction_remote_datasource.dart';

/// Mock implementation of transaction remote data source
///
/// Stores transactions in memory and updates account balances automatically.
/// Pre-populated with sample transactions for 'user_1'.
class TransactionRemoteDataSourceMock implements TransactionRemoteDataSource {
  final AccountRemoteDataSource accountDataSource;

  // In-memory storage: Map<userId, List<TransactionModel>>
  final Map<String, List<TransactionModel>> _transactions = {};

  // UUID generator for IDs
  final _uuid = const Uuid();

  TransactionRemoteDataSourceMock({required this.accountDataSource}) {
    _initializeMockData();
  }

  /// Initialize mock data for testing
  void _initializeMockData() {
    final now = DateTime.now();

    // Sample transactions for user_1
    _transactions['user_1'] = [
      // Income transactions
      TransactionModel(
        id: 'txn_1',
        userId: 'user_1',
        accountId: 'account_1', // Checking Account
        categoryId: 'cat_income_1', // Salary
        type: TransactionType.income,
        amount: 5000.00,
        currency: 'USD',
        description: 'Monthly Salary',
        date: DateTime(now.year, now.month, 1),
        notes: 'December salary payment',
        tags: ['salary', 'income'],
        receiptUrl: null,
        toAccountId: null,
        createdAt: DateTime(now.year, now.month, 1),
        updatedAt: DateTime(now.year, now.month, 1),
      ),
      TransactionModel(
        id: 'txn_2',
        userId: 'user_1',
        accountId: 'account_1',
        categoryId: 'cat_income_2', // Freelance
        type: TransactionType.income,
        amount: 1200.00,
        currency: 'USD',
        description: 'Freelance Project Payment',
        date: DateTime(now.year, now.month, 5),
        notes: 'Website development project',
        tags: ['freelance', 'income'],
        receiptUrl: null,
        toAccountId: null,
        createdAt: DateTime(now.year, now.month, 5),
        updatedAt: DateTime(now.year, now.month, 5),
      ),

      // Expense transactions
      TransactionModel(
        id: 'txn_3',
        userId: 'user_1',
        accountId: 'account_1',
        categoryId: 'cat_expense_1', // Food & Dining
        type: TransactionType.expense,
        amount: 45.50,
        currency: 'USD',
        description: 'Grocery Shopping',
        date: DateTime(now.year, now.month, 3),
        notes: 'Weekly groceries at Whole Foods',
        tags: ['groceries', 'food'],
        receiptUrl: null,
        toAccountId: null,
        createdAt: DateTime(now.year, now.month, 3),
        updatedAt: DateTime(now.year, now.month, 3),
      ),
      TransactionModel(
        id: 'txn_4',
        userId: 'user_1',
        accountId: 'account_4', // Credit Card
        categoryId: 'cat_expense_4', // Shopping
        type: TransactionType.expense,
        amount: 125.00,
        currency: 'USD',
        description: 'Amazon Order',
        date: DateTime(now.year, now.month, 7),
        notes: 'Books and electronics',
        tags: ['shopping', 'online'],
        receiptUrl: null,
        toAccountId: null,
        createdAt: DateTime(now.year, now.month, 7),
        updatedAt: DateTime(now.year, now.month, 7),
      ),
      TransactionModel(
        id: 'txn_5',
        userId: 'user_1',
        accountId: 'account_1',
        categoryId: 'cat_expense_6', // Bills & Utilities
        type: TransactionType.expense,
        amount: 85.00,
        currency: 'USD',
        description: 'Internet Bill',
        date: DateTime(now.year, now.month, 2),
        notes: 'Monthly internet service',
        tags: ['bills', 'utilities'],
        receiptUrl: null,
        toAccountId: null,
        createdAt: DateTime(now.year, now.month, 2),
        updatedAt: DateTime(now.year, now.month, 2),
      ),

      // Transfer transaction
      TransactionModel(
        id: 'txn_6',
        userId: 'user_1',
        accountId: 'account_1', // From Checking
        categoryId: 'cat_expense_15', // Other (generic for transfers)
        type: TransactionType.transfer,
        amount: 500.00,
        currency: 'USD',
        description: 'Transfer to Savings',
        date: DateTime(now.year, now.month, 10),
        notes: 'Monthly savings transfer',
        tags: ['transfer', 'savings'],
        receiptUrl: null,
        toAccountId: 'account_2', // To Savings
        createdAt: DateTime(now.year, now.month, 10),
        updatedAt: DateTime(now.year, now.month, 10),
      ),
    ];
  }

  @override
  Future<List<TransactionModel>> getTransactions(String userId) async {
    await _simulateNetworkDelay();

    final userTransactions = _transactions[userId] ?? [];

    // Sort by date (newest first)
    userTransactions.sort((a, b) => b.date.compareTo(a.date));

    return userTransactions;
  }

  @override
  Future<TransactionModel> getTransactionById(String id) async {
    await _simulateNetworkDelay();

    for (final transactions in _transactions.values) {
      try {
        return transactions.firstWhere((t) => t.id == id);
      } catch (_) {
        continue;
      }
    }

    throw ServerException('Transaction not found');
  }

  @override
  Future<TransactionModel> createTransaction(TransactionModel transaction) async {
    await _simulateNetworkDelay();

    // Validate transaction
    _validateTransaction(transaction);

    // Verify accounts exist
    await _verifyAccountsExist(transaction);

    // Generate ID if not provided
    final newTransaction = transaction.id.isEmpty
        ? transaction.copyWith(
            id: _uuid.v4(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          )
        : transaction.copyWith(
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

    // Update account balance(s)
    await _updateAccountBalances(newTransaction, isCreate: true);

    // Add to storage
    if (_transactions[transaction.userId] == null) {
      _transactions[transaction.userId] = [];
    }
    _transactions[transaction.userId]!.add(newTransaction);

    return newTransaction;
  }

  @override
  Future<TransactionModel> updateTransaction(TransactionModel transaction) async {
    await _simulateNetworkDelay();

    // Validate transaction
    _validateTransaction(transaction);

    // Find existing transaction
    final existingTransaction = await getTransactionById(transaction.id);

    // Verify accounts exist
    await _verifyAccountsExist(transaction);

    // Reverse old transaction effect on balance
    await _updateAccountBalances(existingTransaction, isCreate: false, isDelete: true);

    // Apply new transaction effect on balance
    await _updateAccountBalances(transaction, isCreate: false);

    // Update in storage
    final userTransactions = _transactions[transaction.userId]!;
    final index = userTransactions.indexWhere((t) => t.id == transaction.id);

    if (index == -1) {
      throw ServerException('Transaction not found');
    }

    final updatedTransaction = transaction.copyWith(
      createdAt: existingTransaction.createdAt,
      updatedAt: DateTime.now(),
    );

    userTransactions[index] = updatedTransaction;

    return updatedTransaction;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _simulateNetworkDelay();

    // Find transaction
    final transaction = await getTransactionById(id);

    // Reverse transaction effect on balance
    await _updateAccountBalances(transaction, isCreate: false, isDelete: true);

    // Remove from storage
    final userTransactions = _transactions[transaction.userId]!;
    userTransactions.removeWhere((t) => t.id == id);
  }

  @override
  Future<List<TransactionModel>> filterTransactions({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    String? accountId,
    String? categoryId,
    TransactionType? type,
  }) async {
    await _simulateNetworkDelay();

    var transactions = _transactions[userId] ?? [];

    // Apply filters
    if (startDate != null) {
      transactions = transactions.where((t) => t.date.isAfter(startDate) || t.date.isAtSameMomentAs(startDate)).toList();
    }

    if (endDate != null) {
      transactions = transactions.where((t) => t.date.isBefore(endDate) || t.date.isAtSameMomentAs(endDate)).toList();
    }

    if (accountId != null) {
      transactions = transactions.where((t) => t.accountId == accountId || t.toAccountId == accountId).toList();
    }

    if (categoryId != null) {
      transactions = transactions.where((t) => t.categoryId == categoryId).toList();
    }

    if (type != null) {
      transactions = transactions.where((t) => t.type == type).toList();
    }

    // Sort by date (newest first)
    transactions.sort((a, b) => b.date.compareTo(a.date));

    return transactions;
  }

  @override
  Future<List<TransactionModel>> searchTransactions({
    required String userId,
    required String query,
  }) async {
    await _simulateNetworkDelay();

    final transactions = _transactions[userId] ?? [];
    final lowerQuery = query.toLowerCase();

    final results = transactions.where((t) {
      final matchesDescription = t.description.toLowerCase().contains(lowerQuery);
      final matchesNotes = t.notes?.toLowerCase().contains(lowerQuery) ?? false;
      return matchesDescription || matchesNotes;
    }).toList();

    // Sort by date (newest first)
    results.sort((a, b) => b.date.compareTo(a.date));

    return results;
  }

  @override
  Future<List<TransactionModel>> getTransactionsByAccount(String accountId) async {
    await _simulateNetworkDelay();

    final allTransactions = <TransactionModel>[];

    for (final transactions in _transactions.values) {
      allTransactions.addAll(
        transactions.where((t) => t.accountId == accountId || t.toAccountId == accountId),
      );
    }

    // Sort by date (newest first)
    allTransactions.sort((a, b) => b.date.compareTo(a.date));

    return allTransactions;
  }

  @override
  Future<List<TransactionModel>> getTransactionsByCategory(String categoryId) async {
    await _simulateNetworkDelay();

    final allTransactions = <TransactionModel>[];

    for (final transactions in _transactions.values) {
      allTransactions.addAll(
        transactions.where((t) => t.categoryId == categoryId),
      );
    }

    // Sort by date (newest first)
    allTransactions.sort((a, b) => b.date.compareTo(a.date));

    return allTransactions;
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return filterTransactions(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  @override
  Future<double> getTotalByType({
    required String userId,
    required TransactionType type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final transactions = await filterTransactions(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
      type: type,
    );

    return transactions.fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions({
    required String userId,
    int limit = 10,
  }) async {
    final transactions = await getTransactions(userId);
    return transactions.take(limit).toList();
  }

  // ==================== Private Helper Methods ====================

  /// Validate transaction data
  void _validateTransaction(TransactionModel transaction) {
    if (transaction.amount <= 0) {
      throw ServerException('Amount must be greater than 0');
    }

    if (transaction.description.trim().isEmpty) {
      throw ServerException('Description cannot be empty');
    }

    if (transaction.isTransfer) {
      if (transaction.toAccountId == null) {
        throw ServerException('Destination account is required for transfers');
      }

      if (transaction.toAccountId == transaction.accountId) {
        throw ServerException('Cannot transfer to the same account');
      }
    }
  }

  /// Verify that accounts exist
  Future<void> _verifyAccountsExist(TransactionModel transaction) async {
    try {
      // Verify source account exists
      await accountDataSource.getAccountById(accountId: transaction.accountId);

      // Verify destination account exists (for transfers)
      if (transaction.isTransfer && transaction.toAccountId != null) {
        await accountDataSource.getAccountById(accountId: transaction.toAccountId!);
      }
    } on ServerException {
      throw ServerException('Account not found');
    }
  }

  /// Update account balances based on transaction
  ///
  /// This is the critical logic for maintaining balance consistency.
  Future<void> _updateAccountBalances(
    TransactionModel transaction, {
    required bool isCreate,
    bool isDelete = false,
  }) async {
    if (transaction.isIncome) {
      // Income: Add to account balance
      await _updateAccountBalance(
        transaction.accountId,
        transaction.amount,
        isIncrease: !isDelete,
      );
    } else if (transaction.isExpense) {
      // Expense: Subtract from account balance
      await _updateAccountBalance(
        transaction.accountId,
        transaction.amount,
        isIncrease: isDelete,
      );
    } else if (transaction.isTransfer && transaction.toAccountId != null) {
      // Transfer: Subtract from source, add to destination
      await _updateAccountBalance(
        transaction.accountId,
        transaction.amount,
        isIncrease: isDelete,
      );
      await _updateAccountBalance(
        transaction.toAccountId!,
        transaction.amount,
        isIncrease: !isDelete,
      );
    }
  }

  /// Update a single account's balance
  Future<void> _updateAccountBalance(
    String accountId,
    double amount, {
    required bool isIncrease,
  }) async {
    try {
      // Fetch current account
      final account = await accountDataSource.getAccountById(accountId: accountId);

      // Calculate new balance
      final newBalance = isIncrease
          ? account.balance + amount
          : account.balance - amount;

      // Update account balance
      await accountDataSource.updateBalance(
        accountId: accountId,
        newBalance: newBalance,
      );
    } on ServerException {
      throw ServerException('Failed to update account balance');
    }
  }

  /// Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
