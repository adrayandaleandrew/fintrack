import 'package:equatable/equatable.dart';

/// Category entity for organizing transactions
///
/// Pure Dart class with no external dependencies.
/// Represents a transaction category with type (Income/Expense).
class Category extends Equatable {
  final String id;
  final String userId;
  final String name;
  final CategoryType type;
  final String icon;
  final String color;
  final int sortOrder;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    this.sortOrder = 0,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        type,
        icon,
        color,
        sortOrder,
        isDefault,
        createdAt,
        updatedAt,
      ];

  /// Creates a copy with updated fields
  Category copyWith({
    String? id,
    String? userId,
    String? name,
    CategoryType? type,
    String? icon,
    String? color,
    int? sortOrder,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Type of category (Income or Expense)
enum CategoryType {
  income,
  expense;

  /// Display name for UI
  String get displayName {
    switch (this) {
      case CategoryType.income:
        return 'Income';
      case CategoryType.expense:
        return 'Expense';
    }
  }

  /// Default icon for category type
  String get defaultIcon {
    switch (this) {
      case CategoryType.income:
        return 'attach_money';
      case CategoryType.expense:
        return 'shopping_cart';
    }
  }

  /// Color associated with category type
  String get defaultColor {
    switch (this) {
      case CategoryType.income:
        return '#4CAF50'; // Green for income
      case CategoryType.expense:
        return '#F44336'; // Red for expense
    }
  }
}
