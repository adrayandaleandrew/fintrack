import 'package:flutter/material.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/transaction.dart';

/// Reusable transaction list item widget
///
/// Displays a transaction with:
/// - Type-specific icon and color
/// - Description and date
/// - Amount with +/- prefix
/// - Tap handler for navigation
class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const TransactionListItem({
    super.key,
    required this.transaction,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final isExpense = transaction.isExpense;

    Color amountColor;
    IconData icon;
    Color iconBgColor;

    if (isIncome) {
      amountColor = Colors.green;
      icon = Icons.arrow_downward;
      iconBgColor = Colors.green.withValues(alpha: 0.1);
    } else if (isExpense) {
      amountColor = Colors.red;
      icon = Icons.arrow_upward;
      iconBgColor = Colors.red.withValues(alpha: 0.1);
    } else {
      amountColor = Colors.blue;
      icon = Icons.swap_horiz;
      iconBgColor = Colors.blue.withValues(alpha: 0.1);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconBgColor,
          child: Icon(icon, color: amountColor, size: 20),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _formatTime(transaction.date),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isExpense ? '-' : isIncome ? '+' : ''}${CurrencyFormatter.format(amount: transaction.amount, currencyCode: transaction.currency)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: amountColor,
              ),
            ),
            if (transaction.notes != null && transaction.notes!.isNotEmpty)
              const Icon(
                Icons.note,
                size: 12,
                color: Colors.grey,
              ),
          ],
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
