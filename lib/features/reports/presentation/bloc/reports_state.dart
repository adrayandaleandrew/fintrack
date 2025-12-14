import 'package:equatable/equatable.dart';
import '../../domain/entities/expense_breakdown.dart';
import '../../domain/entities/financial_trends.dart';
import '../../domain/entities/monthly_comparison.dart';

/// Base class for all reports states
abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any reports are loaded
class ReportsInitial extends ReportsState {
  const ReportsInitial();
}

/// Loading state when fetching reports
class ReportsLoading extends ReportsState {
  const ReportsLoading();
}

/// State when expense breakdown is loaded
class ExpenseBreakdownLoaded extends ReportsState {
  final ExpenseBreakdown breakdown;

  const ExpenseBreakdownLoaded({required this.breakdown});

  @override
  List<Object?> get props => [breakdown];
}

/// State when financial trends are loaded
class FinancialTrendsLoaded extends ReportsState {
  final FinancialTrends trends;

  const FinancialTrendsLoaded({required this.trends});

  @override
  List<Object?> get props => [trends];
}

/// State when monthly comparison is loaded
class MonthlyComparisonLoaded extends ReportsState {
  final MonthlyComparison comparison;

  const MonthlyComparisonLoaded({required this.comparison});

  @override
  List<Object?> get props => [comparison];
}

/// State when report export is successful
class ReportExported extends ReportsState {
  final String csvData;
  final String message;

  const ReportExported({
    required this.csvData,
    required this.message,
  });

  @override
  List<Object?> get props => [csvData, message];
}

/// Error state when something goes wrong
class ReportsError extends ReportsState {
  final String message;

  const ReportsError({required this.message});

  @override
  List<Object?> get props => [message];
}
