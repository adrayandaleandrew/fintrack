import 'package:equatable/equatable.dart';

/// Base class for all reports events
abstract class ReportsEvent extends Equatable {
  const ReportsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load expense breakdown report
class LoadExpenseBreakdown extends ReportsEvent {
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final String currencyCode;

  const LoadExpenseBreakdown({
    required this.userId,
    required this.startDate,
    required this.endDate,
    this.currencyCode = 'USD',
  });

  @override
  List<Object?> get props => [userId, startDate, endDate, currencyCode];
}

/// Event to load financial trends report
class LoadFinancialTrends extends ReportsEvent {
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final String groupBy;
  final String currencyCode;

  const LoadFinancialTrends({
    required this.userId,
    required this.startDate,
    required this.endDate,
    this.groupBy = 'month',
    this.currencyCode = 'USD',
  });

  @override
  List<Object?> get props => [userId, startDate, endDate, groupBy, currencyCode];
}

/// Event to load monthly comparison report
class LoadMonthlyComparison extends ReportsEvent {
  final String userId;
  final int monthCount;
  final String currencyCode;

  const LoadMonthlyComparison({
    required this.userId,
    this.monthCount = 6,
    this.currencyCode = 'USD',
  });

  @override
  List<Object?> get props => [userId, monthCount, currencyCode];
}

/// Event to export report to CSV
class ExportReportToCsv extends ReportsEvent {
  final String userId;
  final String reportType;
  final DateTime startDate;
  final DateTime endDate;

  const ExportReportToCsv({
    required this.userId,
    required this.reportType,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [userId, reportType, startDate, endDate];
}
