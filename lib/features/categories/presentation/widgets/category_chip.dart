import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';

/// Chip widget displaying category information
///
/// Shows category icon, name, and color.
/// Useful for transaction forms and category selection.
class CategoryChip extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showIcon;

  const CategoryChip({
    super.key,
    required this.category,
    this.onTap,
    this.isSelected = false,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(category.color);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Icon(
                _getIconData(category.icon),
                size: 18,
                color: isSelected ? Colors.white : color,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              category.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceAll('#', '0xFF')));
    } catch (_) {
      return Colors.blue;
    }
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      // Income icons
      'work': Icons.work,
      'computer': Icons.computer,
      'business_center': Icons.business_center,
      'trending_up': Icons.trending_up,
      'home': Icons.home,
      'card_giftcard': Icons.card_giftcard,
      'star': Icons.star,
      'receipt': Icons.receipt,
      'account_balance': Icons.account_balance,
      'attach_money': Icons.attach_money,

      // Expense icons
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
      'home_repair_service': Icons.home_repair_service,
      'pets': Icons.pets,
      'more_horiz': Icons.more_horiz,
    };

    return iconMap[iconName] ?? Icons.category;
  }
}
