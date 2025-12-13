import 'package:flutter/material.dart';
import '../../../../core/utils/currency_formatter.dart';

/// Card displaying total balance summary
///
/// Shows the total balance across all accounts with
/// a large, prominent display.
class BalanceSummaryCard extends StatelessWidget {
  final double totalBalance;
  final int accountCount;
  final String currency;

  const BalanceSummaryCard({
    super.key,
    required this.totalBalance,
    required this.accountCount,
    this.currency = 'USD',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Balance',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              CurrencyFormatter.format(
                amount: totalBalance,
                currencyCode: currency,
              ),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$accountCount ${accountCount == 1 ? 'account' : 'accounts'}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
