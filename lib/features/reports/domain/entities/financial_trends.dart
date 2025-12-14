import 'package:equatable/equatable.dart';
import 'trend_data_point.dart';

/// Financial trends over time
///
/// Contains a series of data points showing income and expense trends.
/// Used for line chart visualization showing trends over a period.
class FinancialTrends extends Equatable {
  final List<TrendDataPoint> dataPoints;
  final DateTime startDate;
  final DateTime endDate;
  final String currencyCode;

  const FinancialTrends({
    required this.dataPoints,
    required this.startDate,
    required this.endDate,
    required this.currencyCode,
  });

  @override
  List<Object?> get props => [dataPoints, startDate, endDate, currencyCode];

  /// Check if trends have data
  bool get hasData => dataPoints.isNotEmpty;

  /// Get total income across all data points
  double get totalIncome {
    return dataPoints.fold(0.0, (sum, point) => sum + point.income);
  }

  /// Get total expense across all data points
  double get totalExpense {
    return dataPoints.fold(0.0, (sum, point) => sum + point.expense);
  }

  /// Get total net across all data points
  double get totalNet => totalIncome - totalExpense;

  /// Get average income per period
  double get averageIncome {
    if (dataPoints.isEmpty) return 0.0;
    return totalIncome / dataPoints.length;
  }

  /// Get average expense per period
  double get averageExpense {
    if (dataPoints.isEmpty) return 0.0;
    return totalExpense / dataPoints.length;
  }

  /// Get highest income period
  TrendDataPoint? get highestIncomePeriod {
    if (dataPoints.isEmpty) return null;
    return dataPoints.reduce(
      (current, next) => next.income > current.income ? next : current,
    );
  }

  /// Get highest expense period
  TrendDataPoint? get highestExpensePeriod {
    if (dataPoints.isEmpty) return null;
    return dataPoints.reduce(
      (current, next) => next.expense > current.expense ? next : current,
    );
  }

  /// Count periods with surplus
  int get surplusPeriodsCount {
    return dataPoints.where((point) => point.hasSurplus).length;
  }

  /// Count periods with deficit
  int get deficitPeriodsCount {
    return dataPoints.where((point) => point.hasDeficit).length;
  }

  FinancialTrends copyWith({
    List<TrendDataPoint>? dataPoints,
    DateTime? startDate,
    DateTime? endDate,
    String? currencyCode,
  }) {
    return FinancialTrends(
      dataPoints: dataPoints ?? this.dataPoints,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }
}
