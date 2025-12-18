import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../../categories/domain/repositories/category_repository.dart';
import '../../domain/entities/category_expense.dart';
import '../../domain/entities/expense_breakdown.dart';
import '../../domain/entities/financial_trends.dart';
import '../../domain/entities/monthly_comparison.dart';
import '../../domain/entities/trend_data_point.dart';
import '../../domain/repositories/reports_repository.dart';

/// Implementation of ReportsRepository
///
/// Calculates reports from transaction data by integrating with
/// TransactionRepository and CategoryRepository.
class ReportsRepositoryImpl implements ReportsRepository {
  final TransactionRepository transactionRepository;
  final CategoryRepository categoryRepository;

  ReportsRepositoryImpl({
    required this.transactionRepository,
    required this.categoryRepository,
  });

  @override
  Future<Either<Failure, ExpenseBreakdown>> getExpenseBreakdown({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    String currencyCode = 'USD',
  }) async {
    try {
      // Get all transactions for user
      final transactionsResult =
          await transactionRepository.getTransactions(userId);

      return transactionsResult.fold(
        (failure) => Left(failure),
        (transactions) async {
          // Filter expense transactions within date range
          final expenseTransactions = transactions
              .where((t) =>
                  t.type == TransactionType.expense &&
                  t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
                  t.date.isBefore(endDate.add(const Duration(days: 1))))
              .toList();

          // Calculate total expense
          final totalExpense = expenseTransactions.fold<double>(
            0.0,
            (sum, t) => sum + t.amount,
          );

          // Group by category
          final Map<String, List<Transaction>> groupedByCategory = {};
          for (final transaction in expenseTransactions) {
            final categoryId = transaction.categoryId;
            if (!groupedByCategory.containsKey(categoryId)) {
              groupedByCategory[categoryId] = [];
            }
            groupedByCategory[categoryId]!.add(transaction);
          }

          // Get categories
          final categoriesResult = await categoryRepository.getCategories(
            userId: userId,
          );

          final categories = categoriesResult.fold(
            (failure) => <String, dynamic>{},
            (cats) => Map.fromEntries(
              cats.map((c) => MapEntry(c.id, c)),
            ),
          );

          // Create CategoryExpense for each category
          final categoryExpenses = groupedByCategory.entries.map((entry) {
            final categoryId = entry.key;
            final categoryTransactions = entry.value;
            final amount = categoryTransactions.fold<double>(
              0.0,
              (sum, t) => sum + t.amount,
            );
            final percentage = totalExpense > 0 ? (amount / totalExpense) * 100 : 0.0;

            final category = categories[categoryId];
            return CategoryExpense(
              categoryId: categoryId,
              categoryName: category?.name ?? 'Unknown',
              categoryIcon: category?.icon ?? 'help_outline',
              categoryColor: category?.color ?? '#9E9E9E',
              amount: amount,
              percentage: percentage,
              transactionCount: categoryTransactions.length,
            );
          }).toList();

          // Sort by amount (highest first)
          categoryExpenses.sort((a, b) => b.amount.compareTo(a.amount));

          return Right(
            ExpenseBreakdown(
              categoryExpenses: categoryExpenses,
              totalExpense: totalExpense,
              startDate: startDate,
              endDate: endDate,
              currencyCode: currencyCode,
            ),
          );
        },
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Failed to get expense breakdown: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, FinancialTrends>> getFinancialTrends({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    String groupBy = 'month',
    String currencyCode = 'USD',
  }) async {
    try {
      // Get all transactions for user
      final transactionsResult =
          await transactionRepository.getTransactions(userId);

      return transactionsResult.fold(
        (failure) => Left(failure),
        (transactions) {
          // Filter transactions within date range (exclude transfers)
          final filteredTransactions = transactions
              .where((t) =>
                  t.type != TransactionType.transfer &&
                  t.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
                  t.date.isBefore(endDate.add(const Duration(days: 1))))
              .toList();

          // Group by period based on groupBy
          final Map<String, List<Transaction>> groupedByPeriod = {};
          for (final transaction in filteredTransactions) {
            String periodKey;
            if (groupBy == 'day') {
              periodKey =
                  '${transaction.date.year}-${transaction.date.month.toString().padLeft(2, '0')}-${transaction.date.day.toString().padLeft(2, '0')}';
            } else if (groupBy == 'week') {
              // Group by week (ISO week)
              final weekStart = transaction.date.subtract(
                Duration(days: transaction.date.weekday - 1),
              );
              periodKey =
                  '${weekStart.year}-${weekStart.month.toString().padLeft(2, '0')}-${weekStart.day.toString().padLeft(2, '0')}';
            } else {
              // Group by month
              periodKey =
                  '${transaction.date.year}-${transaction.date.month.toString().padLeft(2, '0')}';
            }

            if (!groupedByPeriod.containsKey(periodKey)) {
              groupedByPeriod[periodKey] = [];
            }
            groupedByPeriod[periodKey]!.add(transaction);
          }

          // Create TrendDataPoint for each period
          final dataPoints = groupedByPeriod.entries.map((entry) {
            final periodTransactions = entry.value;

            final income = periodTransactions
                .where((t) => t.type == TransactionType.income)
                .fold<double>(0.0, (sum, t) => sum + t.amount);

            final expense = periodTransactions
                .where((t) => t.type == TransactionType.expense)
                .fold<double>(0.0, (sum, t) => sum + t.amount);

            final net = income - expense;

            // Parse date from key
            DateTime date;
            if (groupBy == 'month') {
              final parts = entry.key.split('-');
              date = DateTime(int.parse(parts[0]), int.parse(parts[1]), 1);
            } else {
              final parts = entry.key.split('-');
              date = DateTime(
                int.parse(parts[0]),
                int.parse(parts[1]),
                int.parse(parts[2]),
              );
            }

            return TrendDataPoint(
              date: date,
              income: income,
              expense: expense,
              net: net,
            );
          }).toList();

          // Sort by date
          dataPoints.sort((a, b) => a.date.compareTo(b.date));

          return Right(
            FinancialTrends(
              dataPoints: dataPoints,
              startDate: startDate,
              endDate: endDate,
              currencyCode: currencyCode,
            ),
          );
        },
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Failed to get financial trends: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, MonthlyComparison>> getMonthlyComparison({
    required String userId,
    int monthCount = 6,
    String currencyCode = 'USD',
  }) async {
    try {
      // Get all transactions for user
      final transactionsResult =
          await transactionRepository.getTransactions(userId);

      return transactionsResult.fold(
        (failure) => Left(failure),
        (transactions) {
          // Calculate start date (N months ago from now)
          final now = DateTime.now();
          final startDate = DateTime(now.year, now.month - monthCount + 1, 1);

          // Filter transactions within the last N months (exclude transfers)
          final filteredTransactions = transactions
              .where((t) =>
                  t.type != TransactionType.transfer &&
                  t.date.isAfter(startDate.subtract(const Duration(days: 1))))
              .toList();

          // Group by month
          final Map<String, List<Transaction>> groupedByMonth = {};
          for (final transaction in filteredTransactions) {
            final monthKey =
                '${transaction.date.year}-${transaction.date.month.toString().padLeft(2, '0')}';
            if (!groupedByMonth.containsKey(monthKey)) {
              groupedByMonth[monthKey] = [];
            }
            groupedByMonth[monthKey]!.add(transaction);
          }

          // Create MonthlyComparisonData for each month
          final months = <MonthlyComparisonData>[];
          for (int i = 0; i < monthCount; i++) {
            final date = DateTime(now.year, now.month - monthCount + 1 + i, 1);
            final monthKey =
                '${date.year}-${date.month.toString().padLeft(2, '0')}';
            final monthTransactions = groupedByMonth[monthKey] ?? [];

            final income = monthTransactions
                .where((t) => t.type == TransactionType.income)
                .fold<double>(0.0, (sum, t) => sum + t.amount);

            final expense = monthTransactions
                .where((t) => t.type == TransactionType.expense)
                .fold<double>(0.0, (sum, t) => sum + t.amount);

            final net = income - expense;

            months.add(
              MonthlyComparisonData(
                year: date.year,
                month: date.month,
                income: income,
                expense: expense,
                net: net,
                transactionCount: monthTransactions.length,
              ),
            );
          }

          return Right(
            MonthlyComparison(
              months: months,
              currencyCode: currencyCode,
            ),
          );
        },
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Failed to get monthly comparison: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, String>> exportReportToCsv({
    required String userId,
    required String reportType,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      // TODO: Implement CSV export functionality
      // This will be a simple CSV generation based on report type
      return Left(ServerFailure('CSV export not yet implemented'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(
        ServerFailure('Failed to export report: ${e.toString()}'),
      );
    }
  }
}
