import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/transaction.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/bloc/category_bloc.dart';
import '../../../categories/presentation/bloc/category_event.dart';
import '../../../categories/presentation/bloc/category_state.dart';

/// Widget for selecting a category
///
/// Displays categories grouped by type (Income/Expense)
/// Used in transaction forms for category selection
class CategorySelector extends StatelessWidget {
  final String userId;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;
  final TransactionType transactionType;
  final String? label;

  const CategorySelector({
    super.key,
    required this.userId,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    required this.transactionType,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CategoryBloc>()..add(LoadCategories(userId: userId)),
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: label ?? 'Category',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.category),
              ),
              items: const [],
              onChanged: null,
              hint: const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Loading categories...'),
                ],
              ),
            );
          }

          if (state is CategoryError) {
            return DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: label ?? 'Category',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.category),
                errorText: 'Failed to load categories',
              ),
              items: const [],
              onChanged: null,
            );
          }

          if (state is CategoriesLoaded) {
            // Filter categories by transaction type
            final categoryType = transactionType == TransactionType.income
                ? CategoryType.income
                : CategoryType.expense;

            final categories = state.categories
                .where((category) => category.type == categoryType)
                .toList()
              ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

            if (categories.isEmpty) {
              return DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: label ?? 'Category',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.category),
                ),
                items: const [],
                onChanged: null,
                hint: Text(
                    'No ${categoryType.displayName.toLowerCase()} categories'),
              );
            }

            return DropdownButtonFormField<String>(
              value: selectedCategoryId,
              decoration: InputDecoration(
                labelText: label ?? 'Category',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.category),
              ),
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category.id,
                  child: Row(
                    children: [
                      Icon(
                        _getCategoryIcon(category.icon),
                        size: 20,
                        color: _parseColor(category.color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          category.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (category.isDefault)
                        const Icon(
                          Icons.lock_outline,
                          size: 14,
                          color: Colors.grey,
                        ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onCategorySelected,
              validator: (value) {
                if (transactionType != TransactionType.transfer &&
                    (value == null || value.isEmpty)) {
                  return 'Please select a category';
                }
                return null;
              },
            );
          }

          // Default empty state
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: label ?? 'Category',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.category),
            ),
            items: const [],
            onChanged: null,
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String iconName) {
    // Map icon names to IconData
    const iconMap = {
      'work': Icons.work,
      'computer': Icons.computer,
      'business_center': Icons.business_center,
      'trending_up': Icons.trending_up,
      'home': Icons.home,
      'card_giftcard': Icons.card_giftcard,
      'star': Icons.star,
      'receipt': Icons.receipt,
      'restaurant': Icons.restaurant,
      'shopping_cart': Icons.shopping_cart,
      'directions_car': Icons.directions_car,
      'shopping_bag': Icons.shopping_bag,
      'movie': Icons.movie,
      'receipt_long': Icons.receipt_long,
      'local_hospital': Icons.local_hospital,
      'school': Icons.school,
      'flight': Icons.flight,
      'spa': Icons.spa,
      'security': Icons.security,
      'subscriptions': Icons.subscriptions,
    };

    return iconMap[iconName] ?? Icons.category;
  }

  Color _parseColor(String colorHex) {
    try {
      // Remove # if present
      final hex = colorHex.replaceAll('#', '');

      // Parse hex color
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (e) {
      // If parsing fails, return grey
    }

    return Colors.grey;
  }
}
