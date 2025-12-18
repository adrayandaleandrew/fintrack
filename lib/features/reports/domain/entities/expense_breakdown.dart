import 'package:equatable/equatable.dart';
import 'category_expense.dart';

/// Expense breakdown report data
///
/// Contains expenses grouped by category with percentages.
/// Used for pie chart visualization showing spending distribution.
class ExpenseBreakdown extends Equatable {
  final List<CategoryExpense> categoryExpenses;
  final double totalExpense;
  final DateTime startDate;
  final DateTime endDate;
  final String currencyCode;

  const ExpenseBreakdown({
    required this.categoryExpenses,
    required this.totalExpense,
    required this.startDate,
    required this.endDate,
    required this.currencyCode,
  });

  @override
  List<Object?> get props => [
        categoryExpenses,
        totalExpense,
        startDate,
        endDate,
        currencyCode,
      ];

  /// Get top N categories by spending
  List<CategoryExpense> getTopCategories(int count) {
    final sorted = List<CategoryExpense>.from(categoryExpenses)
      ..sort((a, b) => b.amount.compareTo(a.amount));
    return sorted.take(count).toList();
  }

  /// Check if breakdown has data
  bool get hasData => categoryExpenses.isNotEmpty && totalExpense > 0;

  /// Get category count
  int get categoryCount => categoryExpenses.length;

  /// Get total transaction count
  int get totalTransactionCount {
    return categoryExpenses.fold(
      0,
      (sum, category) => sum + category.transactionCount,
    );
  }

  ExpenseBreakdown copyWith({
    List<CategoryExpense>? categoryExpenses,
    double? totalExpense,
    DateTime? startDate,
    DateTime? endDate,
    String? currencyCode,
  }) {
    return ExpenseBreakdown(
      categoryExpenses: categoryExpenses ?? this.categoryExpenses,
      totalExpense: totalExpense ?? this.totalExpense,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }
}
