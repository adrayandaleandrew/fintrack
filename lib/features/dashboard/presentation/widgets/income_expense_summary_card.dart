import 'package:flutter/material.dart';
import '../../../../core/utils/currency_formatter.dart';

/// Card displaying income and expense summary
///
/// Shows month-to-date income, expense, and net change.
class IncomeExpenseSummaryCard extends StatelessWidget {
  final double income;
  final double expense;
  final double netChange;
  final String currency;

  const IncomeExpenseSummaryCard({
    super.key,
    required this.income,
    required this.expense,
    required this.netChange,
    this.currency = 'USD',
  });

  bool get hasPositiveNet => netChange >= 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This Month',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              'Income',
              income,
              Colors.green,
              Icons.arrow_downward,
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Expenses',
              expense,
              Colors.red,
              Icons.arrow_upward,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              'Net Change',
              netChange.abs(),
              hasPositiveNet ? Colors.green : Colors.red,
              hasPositiveNet ? Icons.trending_up : Icons.trending_down,
              isNet: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double amount,
    Color color,
    IconData icon, {
    bool isNet = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: isNet ? 18 : 16,
                fontWeight: isNet ? FontWeight.bold : FontWeight.w500,
                color: isNet ? color : null,
              ),
            ),
          ],
        ),
        Text(
          '${isNet && hasPositiveNet ? '+' : isNet && !hasPositiveNet ? '-' : ''}${CurrencyFormatter.format(amount: amount, currencyCode: currency)}',
          style: TextStyle(
            fontSize: isNet ? 18 : 16,
            fontWeight: isNet ? FontWeight.bold : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
