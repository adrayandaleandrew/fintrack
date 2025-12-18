import 'package:equatable/equatable.dart';

/// Represents expense data for a specific category
///
/// Used in expense breakdown reports to show spending per category
/// with both absolute amounts and percentage of total.
class CategoryExpense extends Equatable {
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final String categoryColor;
  final double amount;
  final double percentage;
  final int transactionCount;

  const CategoryExpense({
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.amount,
    required this.percentage,
    required this.transactionCount,
  });

  @override
  List<Object?> get props => [
        categoryId,
        categoryName,
        categoryIcon,
        categoryColor,
        amount,
        percentage,
        transactionCount,
      ];

  CategoryExpense copyWith({
    String? categoryId,
    String? categoryName,
    String? categoryIcon,
    String? categoryColor,
    double? amount,
    double? percentage,
    int? transactionCount,
  }) {
    return CategoryExpense(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      categoryColor: categoryColor ?? this.categoryColor,
      amount: amount ?? this.amount,
      percentage: percentage ?? this.percentage,
      transactionCount: transactionCount ?? this.transactionCount,
    );
  }
}
