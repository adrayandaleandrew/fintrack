import 'package:csv/csv.dart';
import '../../../transactions/data/models/transaction_model.dart';
import '../../../transactions/domain/entities/transaction.dart'; // For TransactionType
import '../../../accounts/data/models/account_model.dart';
import '../../../accounts/domain/entities/account.dart'; // For AccountType
import '../../../budgets/data/models/budget_model.dart';
import '../../../budgets/domain/entities/budget.dart'; // For BudgetPeriod
import '../../../categories/data/models/category_model.dart';
import '../../../categories/domain/entities/category.dart'; // For CategoryType

/// Service for converting entities to/from CSV format
///
/// Handles CSV serialization and deserialization for all entity types.
/// Following bestpractices.md: Single Responsibility Principle.
class CsvFormatter {
  const CsvFormatter();

  // ==================== TRANSACTIONS ====================

  /// Convert transactions to CSV string
  String transactionsToCsv(List<TransactionModel> transactions) {
    if (transactions.isEmpty) {
      return _transactionHeaders().join(',');
    }

    final List<List<dynamic>> rows = [_transactionHeaders()];

    for (final transaction in transactions) {
      rows.add([
        transaction.id,
        transaction.userId,
        transaction.accountId,
        transaction.categoryId,
        transaction.type.name,
        transaction.amount,
        transaction.currency,
        transaction.description,
        transaction.date.toIso8601String(),
        transaction.notes ?? '',
        transaction.tags?.join(';') ?? '',
        transaction.receiptUrl ?? '',
        transaction.toAccountId ?? '',
        transaction.createdAt.toIso8601String(),
        transaction.updatedAt.toIso8601String(),
      ]);
    }

    return const ListToCsvConverter().convert(rows);
  }

  /// Parse CSV string to transactions
  List<TransactionModel> csvToTransactions(String csvContent) {
    final rows = const CsvToListConverter().convert(csvContent);

    if (rows.length < 2) {
      return []; // No data rows (only header or empty)
    }

    final transactions = <TransactionModel>[];

    // Skip header row (index 0)
    for (int i = 1; i < rows.length; i++) {
      try {
        final row = rows[i];
        if (row.length < 15) continue; // Skip invalid rows

        transactions.add(TransactionModel(
          id: row[0].toString(),
          userId: row[1].toString(),
          accountId: row[2].toString(),
          categoryId: row[3].toString(),
          type: _parseTransactionType(row[4].toString()),
          amount: _parseDouble(row[5]),
          currency: row[6].toString(),
          description: row[7].toString(),
          date: DateTime.parse(row[8].toString()),
          notes: row[9].toString().isEmpty ? null : row[9].toString(),
          tags: row[10].toString().isEmpty
              ? null
              : row[10].toString().split(';'),
          receiptUrl: row[11].toString().isEmpty ? null : row[11].toString(),
          toAccountId: row[12].toString().isEmpty ? null : row[12].toString(),
          createdAt: DateTime.parse(row[13].toString()),
          updatedAt: DateTime.parse(row[14].toString()),
        ));
      } catch (e) {
        // Skip invalid row, continue parsing
        continue;
      }
    }

    return transactions;
  }

  List<String> _transactionHeaders() => [
        'id',
        'userId',
        'accountId',
        'categoryId',
        'type',
        'amount',
        'currency',
        'description',
        'date',
        'notes',
        'tags',
        'receiptUrl',
        'toAccountId',
        'createdAt',
        'updatedAt',
      ];

  // ==================== ACCOUNTS ====================

  /// Convert accounts to CSV string
  String accountsToCsv(List<AccountModel> accounts) {
    if (accounts.isEmpty) {
      return _accountHeaders().join(',');
    }

    final List<List<dynamic>> rows = [_accountHeaders()];

    for (final account in accounts) {
      rows.add([
        account.id,
        account.userId,
        account.name,
        account.type.name,
        account.balance,
        account.currency,
        account.icon ?? '',
        account.color ?? '',
        account.isActive ? '1' : '0',
        account.notes ?? '',
        account.creditLimit ?? '',
        account.interestRate ?? '',
        account.createdAt.toIso8601String(),
        account.updatedAt.toIso8601String(),
      ]);
    }

    return const ListToCsvConverter().convert(rows);
  }

  /// Parse CSV string to accounts
  List<AccountModel> csvToAccounts(String csvContent) {
    final rows = const CsvToListConverter().convert(csvContent);

    if (rows.length < 2) return [];

    final accounts = <AccountModel>[];

    for (int i = 1; i < rows.length; i++) {
      try {
        final row = rows[i];
        if (row.length < 14) continue;

        accounts.add(AccountModel(
          id: row[0].toString(),
          userId: row[1].toString(),
          name: row[2].toString(),
          type: _parseAccountType(row[3].toString()),
          balance: _parseDouble(row[4]),
          currency: row[5].toString(),
          icon: row[6].toString().isEmpty ? 'account_balance' : row[6].toString(),
          color: row[7].toString().isEmpty ? '#4CAF50' : row[7].toString(),
          isActive: row[8].toString() == '1',
          notes: row[9].toString().isEmpty ? null : row[9].toString(),
          creditLimit:
              row[10].toString().isEmpty ? null : _parseDouble(row[10]),
          interestRate:
              row[11].toString().isEmpty ? null : _parseDouble(row[11]),
          createdAt: DateTime.parse(row[12].toString()),
          updatedAt: DateTime.parse(row[13].toString()),
        ));
      } catch (e) {
        continue;
      }
    }

    return accounts;
  }

  List<String> _accountHeaders() => [
        'id',
        'userId',
        'name',
        'type',
        'balance',
        'currency',
        'icon',
        'color',
        'isActive',
        'notes',
        'creditLimit',
        'interestRate',
        'createdAt',
        'updatedAt',
      ];

  // ==================== BUDGETS ====================

  /// Convert budgets to CSV string
  String budgetsToCsv(List<BudgetModel> budgets) {
    if (budgets.isEmpty) {
      return _budgetHeaders().join(',');
    }

    final List<List<dynamic>> rows = [_budgetHeaders()];

    for (final budget in budgets) {
      rows.add([
        budget.id,
        budget.userId,
        budget.categoryId,
        budget.amount,
        budget.currency,
        budget.period.name,
        budget.startDate.toIso8601String(),
        budget.endDate?.toIso8601String() ?? '',
        budget.alertThreshold,
        budget.isActive ? '1' : '0',
        budget.createdAt.toIso8601String(),
        budget.updatedAt.toIso8601String(),
      ]);
    }

    return const ListToCsvConverter().convert(rows);
  }

  /// Parse CSV string to budgets
  List<BudgetModel> csvToBudgets(String csvContent) {
    final rows = const CsvToListConverter().convert(csvContent);

    if (rows.length < 2) return [];

    final budgets = <BudgetModel>[];

    for (int i = 1; i < rows.length; i++) {
      try {
        final row = rows[i];
        if (row.length < 12) continue;

        budgets.add(BudgetModel(
          id: row[0].toString(),
          userId: row[1].toString(),
          categoryId: row[2].toString(),
          amount: _parseDouble(row[3]),
          currency: row[4].toString(),
          period: _parseBudgetPeriod(row[5].toString()),
          startDate: DateTime.parse(row[6].toString()),
          endDate:
              row[7].toString().isEmpty ? null : DateTime.parse(row[7].toString()),
          alertThreshold: _parseDouble(row[8]),
          isActive: row[9].toString() == '1',
          createdAt: DateTime.parse(row[10].toString()),
          updatedAt: DateTime.parse(row[11].toString()),
        ));
      } catch (e) {
        continue;
      }
    }

    return budgets;
  }

  List<String> _budgetHeaders() => [
        'id',
        'userId',
        'categoryId',
        'amount',
        'currency',
        'period',
        'startDate',
        'endDate',
        'alertThreshold',
        'isActive',
        'createdAt',
        'updatedAt',
      ];

  // ==================== CATEGORIES ====================

  /// Convert categories to CSV string
  String categoriesToCsv(List<CategoryModel> categories) {
    if (categories.isEmpty) {
      return _categoryHeaders().join(',');
    }

    final List<List<dynamic>> rows = [_categoryHeaders()];

    for (final category in categories) {
      rows.add([
        category.id,
        category.userId,
        category.name,
        category.type.name,
        category.icon,
        category.color,
        category.sortOrder,
        category.isDefault ? '1' : '0',
        category.createdAt.toIso8601String(),
        category.updatedAt.toIso8601String(),
      ]);
    }

    return const ListToCsvConverter().convert(rows);
  }

  /// Parse CSV string to categories
  List<CategoryModel> csvToCategories(String csvContent) {
    final rows = const CsvToListConverter().convert(csvContent);

    if (rows.length < 2) return [];

    final categories = <CategoryModel>[];

    for (int i = 1; i < rows.length; i++) {
      try {
        final row = rows[i];
        if (row.length < 10) continue;

        categories.add(CategoryModel(
          id: row[0].toString(),
          userId: row[1].toString(),
          name: row[2].toString(),
          type: _parseCategoryType(row[3].toString()),
          icon: row[4].toString(),
          color: row[5].toString(),
          sortOrder: int.parse(row[6].toString()),
          isDefault: row[7].toString() == '1',
          createdAt: DateTime.parse(row[8].toString()),
          updatedAt: DateTime.parse(row[9].toString()),
        ));
      } catch (e) {
        continue;
      }
    }

    return categories;
  }

  List<String> _categoryHeaders() => [
        'id',
        'userId',
        'name',
        'type',
        'icon',
        'color',
        'sortOrder',
        'isDefault',
        'createdAt',
        'updatedAt',
      ];

  // ==================== HELPER METHODS ====================

  double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  TransactionType _parseTransactionType(String value) {
    switch (value.toLowerCase()) {
      case 'income':
        return TransactionType.income;
      case 'expense':
        return TransactionType.expense;
      case 'transfer':
        return TransactionType.transfer;
      default:
        return TransactionType.expense;
    }
  }

  AccountType _parseAccountType(String value) {
    switch (value.toLowerCase()) {
      case 'bank':
        return AccountType.bank;
      case 'cash':
        return AccountType.cash;
      case 'creditcard':
        return AccountType.creditCard;
      case 'investment':
        return AccountType.investment;
      default:
        return AccountType.bank;
    }
  }

  BudgetPeriod _parseBudgetPeriod(String value) {
    switch (value.toLowerCase()) {
      case 'daily':
        return BudgetPeriod.daily;
      case 'weekly':
        return BudgetPeriod.weekly;
      case 'monthly':
        return BudgetPeriod.monthly;
      case 'yearly':
        return BudgetPeriod.yearly;
      default:
        return BudgetPeriod.monthly;
    }
  }

  CategoryType _parseCategoryType(String value) {
    switch (value.toLowerCase()) {
      case 'income':
        return CategoryType.income;
      case 'expense':
        return CategoryType.expense;
      default:
        return CategoryType.expense;
    }
  }
}
