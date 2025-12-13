import 'package:equatable/equatable.dart';
import '../../domain/entities/category.dart';

/// Base class for all category states
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

/// Initial state when bloc is created
class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

/// Loading state for any category operation
class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

/// State when multiple categories are loaded successfully
class CategoriesLoaded extends CategoryState {
  final List<Category> categories;
  final CategoryType? filterType;

  const CategoriesLoaded({
    required this.categories,
    this.filterType,
  });

  @override
  List<Object?> get props => [categories, filterType];

  /// Helper to get categories by type
  List<Category> getCategoriesByType(CategoryType type) {
    return categories.where((category) => category.type == type).toList();
  }

  /// Helper to get income categories
  List<Category> get incomeCategories {
    return getCategoriesByType(CategoryType.income)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// Helper to get expense categories
  List<Category> get expenseCategories {
    return getCategoriesByType(CategoryType.expense)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// Helper to get default categories
  List<Category> get defaultCategories {
    return categories.where((category) => category.isDefault).toList();
  }

  /// Helper to get custom categories
  List<Category> get customCategories {
    return categories.where((category) => !category.isDefault).toList();
  }

  /// Helper to get count by type
  int getCountByType(CategoryType type) {
    return getCategoriesByType(type).length;
  }
}

/// State when a single category is loaded successfully
class CategoryLoaded extends CategoryState {
  final Category category;

  const CategoryLoaded({required this.category});

  @override
  List<Object?> get props => [category];
}

/// State when a category action (create, update, delete) succeeds
class CategoryActionSuccess extends CategoryState {
  final String message;
  final Category? category; // For create/update operations

  const CategoryActionSuccess({
    required this.message,
    this.category,
  });

  @override
  List<Object?> get props => [message, category];
}

/// State when default categories are loaded
class DefaultCategoriesLoaded extends CategoryState {
  final List<Category> categories;

  const DefaultCategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];

  /// Helper to get income categories
  List<Category> get incomeCategories {
    return categories
        .where((category) => category.type == CategoryType.income)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  /// Helper to get expense categories
  List<Category> get expenseCategories {
    return categories
        .where((category) => category.type == CategoryType.expense)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }
}

/// State when an error occurs
class CategoryError extends CategoryState {
  final String message;

  const CategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
