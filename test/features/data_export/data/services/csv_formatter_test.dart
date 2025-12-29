import 'package:finance_tracker/features/accounts/data/models/account_model.dart';
import 'package:finance_tracker/features/accounts/domain/entities/account.dart';
import 'package:finance_tracker/features/budgets/data/models/budget_model.dart';
import 'package:finance_tracker/features/budgets/domain/entities/budget.dart';
import 'package:finance_tracker/features/categories/data/models/category_model.dart';
import 'package:finance_tracker/features/categories/domain/entities/category.dart';
import 'package:finance_tracker/features/data_export/data/services/csv_formatter.dart';
import 'package:finance_tracker/features/transactions/data/models/transaction_model.dart';
import 'package:finance_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CsvFormatter csvFormatter;

  setUp(() {
    csvFormatter = CsvFormatter();
  });

  group('CsvFormatter - Transactions', () {
    final tTransactions = [
      TransactionModel(
        id: 'txn_1',
        userId: 'user_1',
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.income,
        amount: 5000.00,
        currency: 'USD',
        description: 'Monthly Salary',
        date: DateTime(2025, 12, 1),
        notes: 'December salary',
        tags: ['salary', 'income'],
        receiptUrl: null,
        toAccountId: null,
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      ),
      TransactionModel(
        id: 'txn_2',
        userId: 'user_1',
        accountId: 'acc_1',
        categoryId: 'cat_2',
        type: TransactionType.expense,
        amount: 45.50,
        currency: 'USD',
        description: 'Grocery Shopping',
        date: DateTime(2025, 12, 5),
        notes: null,
        tags: null,
        receiptUrl: null,
        toAccountId: null,
        createdAt: DateTime(2025, 12, 5),
        updatedAt: DateTime(2025, 12, 5),
      ),
    ];

    test('should convert transactions to CSV format', () {
      // Act
      final csvContent = csvFormatter.transactionsToCsv(tTransactions);

      // Assert
      expect(csvContent, isNotEmpty);
      expect(csvContent, contains('id,userId,accountId'));
      expect(csvContent, contains('txn_1,user_1,acc_1'));
      expect(csvContent, contains('Monthly Salary'));
      expect(csvContent, contains('5000.0'));
      expect(csvContent, contains('income'));
    });

    test('should convert CSV to transactions', () {
      // Arrange
      final csvContent = csvFormatter.transactionsToCsv(tTransactions);

      // Act
      final transactions = csvFormatter.csvToTransactions(csvContent);

      // Assert
      expect(transactions, isNotEmpty);
      expect(transactions.length, equals(2));
      expect(transactions[0].id, equals('txn_1'));
      expect(transactions[0].description, equals('Monthly Salary'));
      expect(transactions[0].amount, equals(5000.00));
      expect(transactions[0].type, equals(TransactionType.income));
    });

    test('should handle transactions with null fields', () {
      // Arrange
      final csvContent = csvFormatter.transactionsToCsv(tTransactions);

      // Act
      final transactions = csvFormatter.csvToTransactions(csvContent);

      // Assert
      expect(transactions[1].notes, isNull);
      expect(transactions[1].tags, isNull);
      expect(transactions[1].receiptUrl, isNull);
      expect(transactions[1].toAccountId, isNull);
    });

    test('should handle empty transaction list', () {
      // Act
      final csvContent = csvFormatter.transactionsToCsv([]);

      // Assert
      expect(csvContent, isNotEmpty);
      expect(csvContent, contains('id,userId,accountId'));
    });

    test('should skip invalid rows when parsing CSV', () {
      // Arrange
      // Create two transactions, we'll manually corrupt the CSV for one
      final transaction1 = TransactionModel(
        id: 'txn_1',
        userId: 'user_1',
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.income,
        amount: 5000.0,
        currency: 'USD',
        description: 'Salary',
        date: DateTime(2025, 12, 1),
        notes: null,
        tags: null,
        receiptUrl: null,
        toAccountId: null,
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      );

      final transaction2 = TransactionModel(
        id: 'txn_2',
        userId: 'user_1',
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 100.0,
        currency: 'USD',
        description: 'Shopping',
        date: DateTime(2025, 12, 2),
        notes: null,
        tags: null,
        receiptUrl: null,
        toAccountId: null,
        createdAt: DateTime(2025, 12, 2),
        updatedAt: DateTime(2025, 12, 2),
      );

      // Generate CSV with both transactions
      final validCsv = csvFormatter.transactionsToCsv([transaction1, transaction2]);

      // Replace the second transaction row with an invalid row (only 3 fields)
      final csvLines = validCsv.split('\r\n'); // Windows line endings
      if (csvLines.length < 3) {
        // Fallback to Unix line endings
        csvLines.clear();
        csvLines.addAll(validCsv.split('\n'));
      }

      // Reconstruct CSV with header, valid row, invalid row
      final invalidCsv = '${csvLines[0]}\r\n${csvLines[1]}\r\ninvalid,row,missing_fields';

      // Act
      final transactions = csvFormatter.csvToTransactions(invalidCsv);

      // Assert - should only parse the valid transaction
      expect(transactions.length, equals(1));
      expect(transactions[0].id, equals('txn_1'));
    });
  });

  group('CsvFormatter - Accounts', () {
    final tAccounts = [
      AccountModel(
        id: 'acc_1',
        userId: 'user_1',
        name: 'Checking Account',
        type: AccountType.bank,
        balance: 15000.00,
        currency: 'USD',
        icon: 'account_balance',
        color: '#4CAF50',
        isActive: true,
        creditLimit: null,
        interestRate: null,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 12, 1),
      ),
      AccountModel(
        id: 'acc_2',
        userId: 'user_1',
        name: 'Credit Card',
        type: AccountType.creditCard,
        balance: -2500.00,
        currency: 'USD',
        icon: 'credit_card',
        color: '#F44336',
        isActive: true,
        creditLimit: 10000.00,
        interestRate: 18.5,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 12, 1),
      ),
    ];

    test('should convert accounts to CSV format', () {
      // Act
      final csvContent = csvFormatter.accountsToCsv(tAccounts);

      // Assert
      expect(csvContent, isNotEmpty);
      expect(csvContent, contains('id,userId,name'));
      expect(csvContent, contains('acc_1,user_1,Checking Account'));
      expect(csvContent, contains('15000.0'));
      expect(csvContent, contains('bank'));
    });

    test('should convert CSV to accounts', () {
      // Arrange
      final csvContent = csvFormatter.accountsToCsv(tAccounts);

      // Act
      final accounts = csvFormatter.csvToAccounts(csvContent);

      // Assert
      expect(accounts, isNotEmpty);
      expect(accounts.length, equals(2));
      expect(accounts[0].id, equals('acc_1'));
      expect(accounts[0].name, equals('Checking Account'));
      expect(accounts[0].balance, equals(15000.00));
      expect(accounts[0].type, equals(AccountType.bank));
    });

    test('should handle accounts with optional fields', () {
      // Arrange
      final csvContent = csvFormatter.accountsToCsv(tAccounts);

      // Act
      final accounts = csvFormatter.csvToAccounts(csvContent);

      // Assert
      expect(accounts[0].creditLimit, isNull);
      expect(accounts[0].interestRate, isNull);
      expect(accounts[1].creditLimit, equals(10000.00));
      expect(accounts[1].interestRate, equals(18.5));
    });

    test('should handle empty account list', () {
      // Act
      final csvContent = csvFormatter.accountsToCsv([]);

      // Assert
      expect(csvContent, isNotEmpty);
      expect(csvContent, contains('id,userId,name'));
    });
  });

  group('CsvFormatter - Budgets', () {
    final tBudgets = [
      BudgetModel(
        id: 'budget_1',
        userId: 'user_1',
        categoryId: 'cat_1',
        amount: 500.00,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: DateTime(2025, 12, 1),
        endDate: null,
        alertThreshold: 80.0,
        isActive: true,
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      ),
      BudgetModel(
        id: 'budget_2',
        userId: 'user_1',
        categoryId: 'cat_2',
        amount: 300.00,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: DateTime(2025, 12, 1),
        endDate: DateTime(2025, 12, 31),
        alertThreshold: 90.0,
        isActive: true,
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      ),
    ];

    test('should convert budgets to CSV format', () {
      // Act
      final csvContent = csvFormatter.budgetsToCsv(tBudgets);

      // Assert
      expect(csvContent, isNotEmpty);
      expect(csvContent, contains('id,userId,categoryId'));
      expect(csvContent, contains('budget_1,user_1,cat_1'));
      expect(csvContent, contains('500.0'));
      expect(csvContent, contains('monthly'));
    });

    test('should convert CSV to budgets', () {
      // Arrange
      final csvContent = csvFormatter.budgetsToCsv(tBudgets);

      // Act
      final budgets = csvFormatter.csvToBudgets(csvContent);

      // Assert
      expect(budgets, isNotEmpty);
      expect(budgets.length, equals(2));
      expect(budgets[0].id, equals('budget_1'));
      expect(budgets[0].categoryId, equals('cat_1'));
      expect(budgets[0].amount, equals(500.00));
      expect(budgets[0].period, equals(BudgetPeriod.monthly));
    });

    test('should handle budgets with null end date', () {
      // Arrange
      final csvContent = csvFormatter.budgetsToCsv(tBudgets);

      // Act
      final budgets = csvFormatter.csvToBudgets(csvContent);

      // Assert
      expect(budgets[0].endDate, isNull);
      expect(budgets[1].endDate, isNotNull);
    });

    test('should handle empty budget list', () {
      // Act
      final csvContent = csvFormatter.budgetsToCsv([]);

      // Assert
      expect(csvContent, isNotEmpty);
      expect(csvContent, contains('id,userId,categoryId'));
    });
  });

  group('CsvFormatter - Categories', () {
    final tCategories = [
      CategoryModel(
        id: 'cat_1',
        userId: 'user_1',
        name: 'Salary',
        type: CategoryType.income,
        icon: 'work',
        color: '#4CAF50',
        sortOrder: 1,
        isDefault: true,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      ),
      CategoryModel(
        id: 'cat_2',
        userId: 'user_1',
        name: 'Food & Dining',
        type: CategoryType.expense,
        icon: 'restaurant',
        color: '#FF9800',
        sortOrder: 2,
        isDefault: true,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      ),
    ];

    test('should convert categories to CSV format', () {
      // Act
      final csvContent = csvFormatter.categoriesToCsv(tCategories);

      // Assert
      expect(csvContent, isNotEmpty);
      expect(csvContent, contains('id,userId,name'));
      expect(csvContent, contains('cat_1,user_1,Salary'));
      expect(csvContent, contains('income'));
      expect(csvContent, contains('work'));
    });

    test('should convert CSV to categories', () {
      // Arrange
      final csvContent = csvFormatter.categoriesToCsv(tCategories);

      // Act
      final categories = csvFormatter.csvToCategories(csvContent);

      // Assert
      expect(categories, isNotEmpty);
      expect(categories.length, equals(2));
      expect(categories[0].id, equals('cat_1'));
      expect(categories[0].name, equals('Salary'));
      expect(categories[0].type, equals(CategoryType.income));
      expect(categories[0].isDefault, isTrue);
    });

    test('should handle empty category list', () {
      // Act
      final csvContent = csvFormatter.categoriesToCsv([]);

      // Assert
      expect(csvContent, isNotEmpty);
      expect(csvContent, contains('id,userId,name'));
    });

    test('should preserve category sort order', () {
      // Arrange
      final csvContent = csvFormatter.categoriesToCsv(tCategories);

      // Act
      final categories = csvFormatter.csvToCategories(csvContent);

      // Assert
      expect(categories[0].sortOrder, equals(1));
      expect(categories[1].sortOrder, equals(2));
    });
  });
}
