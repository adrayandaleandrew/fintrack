import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/expense_breakdown.dart';
import '../entities/financial_trends.dart';
import '../entities/monthly_comparison.dart';

/// Repository interface for reports data
///
/// Defines contracts for retrieving various financial reports and analytics.
abstract class ReportsRepository {
  /// Get expense breakdown by category for a date range
  ///
  /// Returns a breakdown of expenses grouped by category with percentages.
  /// Used for pie chart visualization.
  ///
  /// [userId] - User ID to get expenses for
  /// [startDate] - Start of date range
  /// [endDate] - End of date range
  /// [currencyCode] - Currency to display amounts in
  Future<Either<Failure, ExpenseBreakdown>> getExpenseBreakdown({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    String currencyCode = 'USD',
  });

  /// Get financial trends (income vs expense) over time
  ///
  /// Returns a series of data points showing income and expense trends.
  /// Used for line chart visualization.
  ///
  /// [userId] - User ID to get trends for
  /// [startDate] - Start of date range
  /// [endDate] - End of date range
  /// [groupBy] - How to group data (day, week, month)
  /// [currencyCode] - Currency to display amounts in
  Future<Either<Failure, FinancialTrends>> getFinancialTrends({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    String groupBy = 'month', // day, week, month
    String currencyCode = 'USD',
  });

  /// Get monthly comparison for the last N months
  ///
  /// Returns financial data for each month for comparison.
  /// Used for bar chart visualization.
  ///
  /// [userId] - User ID to get comparison for
  /// [monthCount] - Number of months to include (default 6)
  /// [currencyCode] - Currency to display amounts in
  Future<Either<Failure, MonthlyComparison>> getMonthlyComparison({
    required String userId,
    int monthCount = 6,
    String currencyCode = 'USD',
  });

  /// Export report data to CSV format
  ///
  /// [userId] - User ID to export data for
  /// [reportType] - Type of report (expense_breakdown, trends, monthly)
  /// [startDate] - Start of date range
  /// [endDate] - End of date range
  Future<Either<Failure, String>> exportReportToCsv({
    required String userId,
    required String reportType,
    required DateTime startDate,
    required DateTime endDate,
  });
}
