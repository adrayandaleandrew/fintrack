import 'package:equatable/equatable.dart';

/// Monthly comparison data point
///
/// Represents financial data for a specific month.
class MonthlyComparisonData extends Equatable {
  final int year;
  final int month;
  final double income;
  final double expense;
  final double net;
  final int transactionCount;

  const MonthlyComparisonData({
    required this.year,
    required this.month,
    required this.income,
    required this.expense,
    required this.net,
    required this.transactionCount,
  });

  @override
  List<Object?> get props => [
        year,
        month,
        income,
        expense,
        net,
        transactionCount,
      ];

  /// Get month name
  String get monthName {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  /// Get short month name
  String get shortMonthName {
    const months = [
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
      'Dec',
    ];
    return months[month - 1];
  }

  /// Get month label (e.g., "Jan 2024")
  String get label => '$shortMonthName $year';

  /// Check if month had surplus
  bool get hasSurplus => net > 0;

  /// Check if month had deficit
  bool get hasDeficit => net < 0;

  /// Get savings rate (percentage of income saved)
  double get savingsRate {
    if (income == 0) return 0.0;
    return (net / income) * 100;
  }

  MonthlyComparisonData copyWith({
    int? year,
    int? month,
    double? income,
    double? expense,
    double? net,
    int? transactionCount,
  }) {
    return MonthlyComparisonData(
      year: year ?? this.year,
      month: month ?? this.month,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      net: net ?? this.net,
      transactionCount: transactionCount ?? this.transactionCount,
    );
  }
}

/// Monthly comparison report
///
/// Contains a comparison of financial data across multiple months.
/// Used for bar chart visualization.
class MonthlyComparison extends Equatable {
  final List<MonthlyComparisonData> months;
  final String currencyCode;

  const MonthlyComparison({
    required this.months,
    required this.currencyCode,
  });

  @override
  List<Object?> get props => [months, currencyCode];

  /// Check if comparison has data
  bool get hasData => months.isNotEmpty;

  /// Get total income across all months
  double get totalIncome {
    return months.fold(0.0, (sum, month) => sum + month.income);
  }

  /// Get total expense across all months
  double get totalExpense {
    return months.fold(0.0, (sum, month) => sum + month.expense);
  }

  /// Get total net across all months
  double get totalNet => totalIncome - totalExpense;

  /// Get average monthly income
  double get averageIncome {
    if (months.isEmpty) return 0.0;
    return totalIncome / months.length;
  }

  /// Get average monthly expense
  double get averageExpense {
    if (months.isEmpty) return 0.0;
    return totalExpense / months.length;
  }

  /// Get month with highest income
  MonthlyComparisonData? get highestIncomeMonth {
    if (months.isEmpty) return null;
    return months.reduce(
      (current, next) => next.income > current.income ? next : current,
    );
  }

  /// Get month with highest expense
  MonthlyComparisonData? get highestExpenseMonth {
    if (months.isEmpty) return null;
    return months.reduce(
      (current, next) => next.expense > current.expense ? next : current,
    );
  }

  /// Count months with surplus
  int get surplusMonthsCount {
    return months.where((month) => month.hasSurplus).length;
  }

  /// Count months with deficit
  int get deficitMonthsCount {
    return months.where((month) => month.hasDeficit).length;
  }

  MonthlyComparison copyWith({
    List<MonthlyComparisonData>? months,
    String? currencyCode,
  }) {
    return MonthlyComparison(
      months: months ?? this.months,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }
}
