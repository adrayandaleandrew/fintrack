import 'package:equatable/equatable.dart';

/// A single data point in a trend chart
///
/// Represents income and/or expense amounts at a specific date.
/// Used for line chart visualization showing trends over time.
class TrendDataPoint extends Equatable {
  final DateTime date;
  final double income;
  final double expense;
  final double net;

  const TrendDataPoint({
    required this.date,
    required this.income,
    required this.expense,
    required this.net,
  });

  @override
  List<Object?> get props => [date, income, expense, net];

  /// Calculate net amount (income - expense)
  double get netAmount => income - expense;

  /// Check if this period had a surplus
  bool get hasSurplus => netAmount > 0;

  /// Check if this period had a deficit
  bool get hasDeficit => netAmount < 0;

  /// Get the label for this data point (e.g., "Jan 2024")
  String get label {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  /// Get short label (e.g., "Jan")
  String get shortLabel {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[date.month - 1];
  }

  TrendDataPoint copyWith({
    DateTime? date,
    double? income,
    double? expense,
    double? net,
  }) {
    return TrendDataPoint(
      date: date ?? this.date,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      net: net ?? this.net,
    );
  }
}
