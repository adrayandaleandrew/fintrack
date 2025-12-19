import 'dart:math';
import '../../features/accounts/domain/entities/account.dart';
import '../../features/categories/domain/entities/category.dart';
import '../../features/transactions/domain/entities/transaction.dart';

/// Test data generator for performance testing
///
/// Generates large datasets for testing app performance with realistic data volumes.
/// Following bestpractices.md: Test with production-like data volumes.
class TestDataGenerator {
  final Random _random = Random();
  static const String testUserId = 'test_user_performance';

  // Sample data for realistic transactions
  final List<String> _incomeDescriptions = [
    'Monthly Salary',
    'Freelance Project',
    'Bonus Payment',
    'Investment Return',
    'Rental Income',
    'Side Hustle',
    'Commission',
    'Refund',
    'Gift Money',
    'Tax Return',
  ];

  final List<String> _expenseDescriptions = [
    'Grocery Shopping',
    'Restaurant Meal',
    'Gas Station',
    'Coffee Shop',
    'Online Shopping',
    'Utility Bill',
    'Phone Bill',
    'Internet Bill',
    'Gym Membership',
    'Movie Tickets',
    'Book Purchase',
    'Clothing',
    'Electronics',
    'Home Supplies',
    'Car Maintenance',
    'Medical Expense',
    'Pharmacy',
    'Pet Supplies',
    'Haircut',
    'Subscription Service',
  ];

  final List<String> _accountNames = [
    'Main Checking',
    'Savings Account',
    'Emergency Fund',
    'Investment Account',
    'Credit Card',
    'Cash Wallet',
    'Travel Fund',
    'Retirement Account',
  ];

  final List<String> _categoryNames = [
    'Salary',
    'Groceries',
    'Dining',
    'Transportation',
    'Shopping',
    'Bills',
    'Entertainment',
    'Healthcare',
    'Education',
    'Travel',
  ];

  /// Generate test accounts
  List<Account> generateAccounts({int count = 10}) {
    final accounts = <Account>[];
    final accountTypes = AccountType.values;

    for (var i = 0; i < count; i++) {
      final type = accountTypes[i % accountTypes.length];
      final balance = _random.nextDouble() * 10000;

      accounts.add(Account(
        id: 'test_account_$i',
        userId: testUserId,
        name: _accountNames[i % _accountNames.length],
        type: type,
        balance: balance,
        currency: 'USD',
        icon: _getIconForAccountType(type),
        color: _getRandomColor(),
        isActive: true,
        creditLimit: type == AccountType.creditCard ? 5000.0 : null,
        interestRate: type == AccountType.bank ? 0.02 : null,
        createdAt: DateTime.now().subtract(Duration(days: _random.nextInt(365))),
        updatedAt: DateTime.now(),
      ));
    }

    return accounts;
  }

  /// Generate test categories
  List<Category> generateCategories({int count = 20}) {
    final categories = <Category>[];
    final types = [CategoryType.income, CategoryType.expense];

    for (var i = 0; i < count; i++) {
      final type = types[i % 2];

      categories.add(Category(
        id: 'test_category_$i',
        userId: testUserId,
        name: _categoryNames[i % _categoryNames.length],
        type: type,
        icon: type == CategoryType.income ? 'work' : 'shopping_cart',
        color: _getRandomColor(),
        sortOrder: i,
        isDefault: false,
        createdAt: DateTime.now().subtract(Duration(days: _random.nextInt(365))),
        updatedAt: DateTime.now(),
      ));
    }

    return categories;
  }

  /// Generate large number of transactions for performance testing
  ///
  /// Creates realistic transaction data with:
  /// - Random dates over the past year
  /// - Varied amounts (small to large)
  /// - Mix of income, expense, and transfers
  /// - Realistic descriptions
  List<Transaction> generateTransactions({
    required int count,
    required List<Account> accounts,
    required List<Category> categories,
  }) {
    if (accounts.isEmpty || categories.isEmpty) {
      throw ArgumentError('Accounts and categories must not be empty');
    }

    final transactions = <Transaction>[];
    final now = DateTime.now();

    // Separate categories by type for realistic assignment
    final incomeCategories = categories
        .where((c) => c.type == CategoryType.income)
        .toList();
    final expenseCategories = categories
        .where((c) => c.type == CategoryType.expense)
        .toList();

    for (var i = 0; i < count; i++) {
      // 60% expenses, 30% income, 10% transfers
      final rand = _random.nextDouble();
      TransactionType type;
      String description;
      Category category;
      double amount;

      if (rand < 0.60) {
        // Expense
        type = TransactionType.expense;
        description = _expenseDescriptions[
            _random.nextInt(_expenseDescriptions.length)];
        category = expenseCategories.isNotEmpty
            ? expenseCategories[_random.nextInt(expenseCategories.length)]
            : categories[0];
        amount = _generateExpenseAmount();
      } else if (rand < 0.90) {
        // Income
        type = TransactionType.income;
        description = _incomeDescriptions[
            _random.nextInt(_incomeDescriptions.length)];
        category = incomeCategories.isNotEmpty
            ? incomeCategories[_random.nextInt(incomeCategories.length)]
            : categories[0];
        amount = _generateIncomeAmount();
      } else {
        // Transfer
        type = TransactionType.transfer;
        description = 'Transfer between accounts';
        category = categories[0]; // Transfers use first category as placeholder
        amount = _random.nextDouble() * 500 + 50; // $50-$550
      }

      final account = accounts[_random.nextInt(accounts.length)];
      final date = now.subtract(Duration(
        days: _random.nextInt(365),
        hours: _random.nextInt(24),
        minutes: _random.nextInt(60),
      ));

      transactions.add(Transaction(
        id: 'test_txn_$i',
        userId: testUserId,
        accountId: account.id,
        categoryId: category.id,
        type: type,
        amount: amount,
        currency: 'USD',
        description: description,
        date: date,
        notes: _random.nextBool() ? 'Test note for transaction $i' : null,
        toAccountId: type == TransactionType.transfer
            ? _getDifferentAccount(account, accounts)?.id
            : null,
        createdAt: date,
        updatedAt: date,
      ));
    }

    // Sort by date (most recent first)
    transactions.sort((a, b) => b.date.compareTo(a.date));

    return transactions;
  }

  /// Generate expense amount (realistic distribution)
  /// Most expenses are small ($5-$100), some larger ($100-$500)
  double _generateExpenseAmount() {
    final rand = _random.nextDouble();
    if (rand < 0.70) {
      // 70% small expenses ($5-$100)
      return _random.nextDouble() * 95 + 5;
    } else if (rand < 0.95) {
      // 25% medium expenses ($100-$500)
      return _random.nextDouble() * 400 + 100;
    } else {
      // 5% large expenses ($500-$2000)
      return _random.nextDouble() * 1500 + 500;
    }
  }

  /// Generate income amount (realistic distribution)
  double _generateIncomeAmount() {
    final rand = _random.nextDouble();
    if (rand < 0.60) {
      // 60% regular income ($2000-$5000)
      return _random.nextDouble() * 3000 + 2000;
    } else if (rand < 0.90) {
      // 30% side income ($100-$1000)
      return _random.nextDouble() * 900 + 100;
    } else {
      // 10% large income ($5000-$10000)
      return _random.nextDouble() * 5000 + 5000;
    }
  }

  /// Get a different account for transfers
  Account? _getDifferentAccount(Account current, List<Account> accounts) {
    final others = accounts.where((a) => a.id != current.id).toList();
    return others.isNotEmpty ? others[_random.nextInt(others.length)] : null;
  }

  /// Get icon for account type
  String _getIconForAccountType(AccountType type) {
    switch (type) {
      case AccountType.bank:
        return 'account_balance';
      case AccountType.cash:
        return 'account_balance_wallet';
      case AccountType.creditCard:
        return 'credit_card';
      case AccountType.investment:
        return 'trending_up';
    }
  }

  /// Get random hex color
  String _getRandomColor() {
    final colors = [
      '#2196F3', // Blue
      '#4CAF50', // Green
      '#FF9800', // Orange
      '#9C27B0', // Purple
      '#F44336', // Red
      '#00BCD4', // Cyan
      '#FF5722', // Deep Orange
      '#3F51B5', // Indigo
    ];
    return colors[_random.nextInt(colors.length)];
  }

  /// Generate complete test dataset
  ///
  /// Returns a map with:
  /// - accounts: List of test accounts
  /// - categories: List of test categories
  /// - transactions: List of test transactions
  Map<String, dynamic> generateCompleteDataset({
    int accountCount = 10,
    int categoryCount = 20,
    int transactionCount = 1000,
  }) {
    final accounts = generateAccounts(count: accountCount);
    final categories = generateCategories(count: categoryCount);
    final transactions = generateTransactions(
      count: transactionCount,
      accounts: accounts,
      categories: categories,
    );

    return {
      'accounts': accounts,
      'categories': categories,
      'transactions': transactions,
      'summary': {
        'accountCount': accounts.length,
        'categoryCount': categories.length,
        'transactionCount': transactions.length,
        'dateRange': {
          'earliest': transactions.last.date,
          'latest': transactions.first.date,
        },
        'totalAmount': transactions.fold<double>(
          0,
          (sum, txn) => sum + txn.amount,
        ),
      },
    };
  }

  /// Print dataset summary for verification
  void printDatasetSummary(Map<String, dynamic> dataset) {
    final summary = dataset['summary'] as Map<String, dynamic>;
    final dateRange = summary['dateRange'] as Map<String, dynamic>;

    print('=== Test Dataset Summary ===');
    print('Accounts: ${summary['accountCount']}');
    print('Categories: ${summary['categoryCount']}');
    print('Transactions: ${summary['transactionCount']}');
    print('Date Range: ${dateRange['earliest']} to ${dateRange['latest']}');
    print('Total Amount: \$${(summary['totalAmount'] as double).toStringAsFixed(2)}');
    print('===========================');
  }
}
