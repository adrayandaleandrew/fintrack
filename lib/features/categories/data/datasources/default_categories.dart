import '../../domain/entities/category.dart';
import '../models/category_model.dart';

/// Default categories configuration
///
/// Provides predefined categories for new users.
/// These categories cannot be edited or deleted.
class DefaultCategories {
  DefaultCategories._();

  /// Income categories (10)
  static final List<Map<String, dynamic>> incomeCategories = [
    {
      'name': 'Salary',
      'icon': 'work',
      'color': '#4CAF50',
      'sortOrder': 1,
    },
    {
      'name': 'Freelance',
      'icon': 'computer',
      'color': '#66BB6A',
      'sortOrder': 2,
    },
    {
      'name': 'Business',
      'icon': 'business_center',
      'color': '#81C784',
      'sortOrder': 3,
    },
    {
      'name': 'Investments',
      'icon': 'trending_up',
      'color': '#4DB6AC',
      'sortOrder': 4,
    },
    {
      'name': 'Rental Income',
      'icon': 'home',
      'color': '#4FC3F7',
      'sortOrder': 5,
    },
    {
      'name': 'Gifts',
      'icon': 'card_giftcard',
      'color': '#BA68C8',
      'sortOrder': 6,
    },
    {
      'name': 'Bonus',
      'icon': 'star',
      'color': '#FFD54F',
      'sortOrder': 7,
    },
    {
      'name': 'Refund',
      'icon': 'receipt',
      'color': '#90CAF9',
      'sortOrder': 8,
    },
    {
      'name': 'Dividend',
      'icon': 'account_balance',
      'color': '#26A69A',
      'sortOrder': 9,
    },
    {
      'name': 'Other Income',
      'icon': 'attach_money',
      'color': '#66BB6A',
      'sortOrder': 10,
    },
  ];

  /// Expense categories (15)
  static final List<Map<String, dynamic>> expenseCategories = [
    {
      'name': 'Food & Dining',
      'icon': 'restaurant',
      'color': '#F44336',
      'sortOrder': 1,
    },
    {
      'name': 'Groceries',
      'icon': 'shopping_cart',
      'color': '#E57373',
      'sortOrder': 2,
    },
    {
      'name': 'Transportation',
      'icon': 'directions_car',
      'color': '#EF5350',
      'sortOrder': 3,
    },
    {
      'name': 'Shopping',
      'icon': 'shopping_bag',
      'color': '#EC407A',
      'sortOrder': 4,
    },
    {
      'name': 'Entertainment',
      'icon': 'movie',
      'color': '#AB47BC',
      'sortOrder': 5,
    },
    {
      'name': 'Bills & Utilities',
      'icon': 'receipt_long',
      'color': '#FF7043',
      'sortOrder': 6,
    },
    {
      'name': 'Healthcare',
      'icon': 'local_hospital',
      'color': '#EF5350',
      'sortOrder': 7,
    },
    {
      'name': 'Education',
      'icon': 'school',
      'color': '#5C6BC0',
      'sortOrder': 8,
    },
    {
      'name': 'Travel',
      'icon': 'flight',
      'color': '#42A5F5',
      'sortOrder': 9,
    },
    {
      'name': 'Personal Care',
      'icon': 'spa',
      'color': '#EC407A',
      'sortOrder': 10,
    },
    {
      'name': 'Insurance',
      'icon': 'security',
      'color': '#7E57C2',
      'sortOrder': 11,
    },
    {
      'name': 'Subscriptions',
      'icon': 'subscriptions',
      'color': '#FF7043',
      'sortOrder': 12,
    },
    {
      'name': 'Home Maintenance',
      'icon': 'home_repair_service',
      'color': '#8D6E63',
      'sortOrder': 13,
    },
    {
      'name': 'Pets',
      'icon': 'pets',
      'color': '#A1887F',
      'sortOrder': 14,
    },
    {
      'name': 'Other Expenses',
      'icon': 'more_horiz',
      'color': '#F44336',
      'sortOrder': 15,
    },
  ];

  /// Generates default categories for a user
  ///
  /// Creates CategoryModel instances for all default categories.
  /// All categories are marked as isDefault = true.
  static List<CategoryModel> generateForUser(String userId) {
    final now = DateTime.now();
    final categories = <CategoryModel>[];
    int idCounter = 1;

    // Add income categories
    for (final data in incomeCategories) {
      categories.add(
        CategoryModel(
          id: 'category_${idCounter++}',
          userId: userId,
          name: data['name'] as String,
          type: CategoryType.income,
          icon: data['icon'] as String,
          color: data['color'] as String,
          sortOrder: data['sortOrder'] as int,
          isDefault: true,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    // Add expense categories
    for (final data in expenseCategories) {
      categories.add(
        CategoryModel(
          id: 'category_${idCounter++}',
          userId: userId,
          name: data['name'] as String,
          type: CategoryType.expense,
          icon: data['icon'] as String,
          color: data['color'] as String,
          sortOrder: data['sortOrder'] as int,
          isDefault: true,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    return categories;
  }

  /// Gets the total number of default categories
  static int get totalCount =>
      incomeCategories.length + expenseCategories.length;

  /// Gets count of income categories
  static int get incomeCount => incomeCategories.length;

  /// Gets count of expense categories
  static int get expenseCount => expenseCategories.length;
}
