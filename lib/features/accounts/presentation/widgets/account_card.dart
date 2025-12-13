import 'package:flutter/material.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/account.dart';

/// Card widget displaying account summary information
///
/// Shows account icon, name, type, and balance.
/// Reusable across different screens.
class AccountCard extends StatelessWidget {
  final Account account;
  final VoidCallback? onTap;
  final bool showStatus;

  const AccountCard({
    super.key,
    required this.account,
    this.onTap,
    this.showStatus = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(account.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconData(account.icon),
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Account info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      account.type.displayName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (showStatus && !account.isActive)
                      const Text(
                        'Inactive',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
              // Balance
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyFormatter.format(
                      amount: account.balance,
                      currencyCode: account.currency,
                    ),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: account.balance >= 0 ? Colors.green : Colors.red,
                    ),
                  ),
                  if (account.type == AccountType.creditCard &&
                      account.creditLimit != null)
                    Text(
                      'Limit: ${CurrencyFormatter.format(
                        amount: account.creditLimit!,
                        currencyCode: account.currency,
                      )}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ],
          ),
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
    switch (iconName) {
      case 'account_balance':
        return Icons.account_balance;
      case 'savings':
        return Icons.savings;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'money':
        return Icons.money;
      case 'credit_card':
        return Icons.credit_card;
      case 'payment':
        return Icons.payment;
      case 'trending_up':
        return Icons.trending_up;
      case 'show_chart':
        return Icons.show_chart;
      default:
        return Icons.account_balance_wallet;
    }
  }
}
