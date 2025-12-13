import 'package:flutter/material.dart';
import '../../domain/entities/transaction.dart';

/// Widget for selecting a category
///
/// Displays categories grouped by type (Income/Expense)
/// Used in transaction forms for category selection
class CategorySelector extends StatelessWidget {
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;
  final TransactionType transactionType;
  final String? label;

  const CategorySelector({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    required this.transactionType,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real categories from CategoryBloc
    final categories = _getMockCategories()
        .where((category) => category['type'] == _getCategoryType())
        .toList();

    return DropdownButtonFormField<String>(
      initialValue: selectedCategoryId,
      decoration: InputDecoration(
        labelText: label ?? 'Category',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.category),
      ),
      items: categories.map((category) {
        return DropdownMenuItem<String>(
          value: category['id'] as String,
          child: Row(
            children: [
              Icon(
                _getCategoryIcon(category['icon'] as String),
                size: 20,
                color: _getCategoryColor(category['color'] as String),
              ),
              const SizedBox(width: 12),
              Text(
                category['name'] as String,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: onCategorySelected,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }

  String _getCategoryType() {
    if (transactionType == TransactionType.income) {
      return 'income';
    } else if (transactionType == TransactionType.expense) {
      return 'expense';
    }
    return 'expense'; // Default
  }

  List<Map<String, dynamic>> _getMockCategories() {
    return [
      // Income categories
      {
        'id': 'cat_1',
        'name': 'Salary',
        'type': 'income',
        'icon': 'work',
        'color': 'green',
      },
      {
        'id': 'cat_2',
        'name': 'Freelance',
        'type': 'income',
        'icon': 'laptop',
        'color': 'blue',
      },
      {
        'id': 'cat_3',
        'name': 'Business',
        'type': 'income',
        'icon': 'business',
        'color': 'purple',
      },
      {
        'id': 'cat_4',
        'name': 'Investments',
        'type': 'income',
        'icon': 'trending_up',
        'color': 'teal',
      },
      // Expense categories
      {
        'id': 'cat_11',
        'name': 'Food & Dining',
        'type': 'expense',
        'icon': 'restaurant',
        'color': 'orange',
      },
      {
        'id': 'cat_12',
        'name': 'Groceries',
        'type': 'expense',
        'icon': 'shopping_cart',
        'color': 'green',
      },
      {
        'id': 'cat_13',
        'name': 'Transportation',
        'type': 'expense',
        'icon': 'directions_car',
        'color': 'blue',
      },
      {
        'id': 'cat_14',
        'name': 'Shopping',
        'type': 'expense',
        'icon': 'shopping_bag',
        'color': 'pink',
      },
      {
        'id': 'cat_15',
        'name': 'Entertainment',
        'type': 'expense',
        'icon': 'movie',
        'color': 'purple',
      },
      {
        'id': 'cat_16',
        'name': 'Bills & Utilities',
        'type': 'expense',
        'icon': 'receipt',
        'color': 'red',
      },
    ];
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'work':
        return Icons.work;
      case 'laptop':
        return Icons.laptop;
      case 'business':
        return Icons.business;
      case 'trending_up':
        return Icons.trending_up;
      case 'restaurant':
        return Icons.restaurant;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'directions_car':
        return Icons.directions_car;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'movie':
        return Icons.movie;
      case 'receipt':
        return Icons.receipt;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String colorName) {
    switch (colorName) {
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'purple':
        return Colors.purple;
      case 'teal':
        return Colors.teal;
      case 'orange':
        return Colors.orange;
      case 'pink':
        return Colors.pink;
      case 'red':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
