import 'package:flutter/material.dart';
import '../../../../core/utils/currency_formatter.dart';

/// Summary card showing transaction statistics
///
/// Displays:
/// - Total income for period
/// - Total expenses for period
/// - Net amount (income - expenses)
/// - Number of transactions
class TransactionSummaryCard extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;
  final int transactionCount;
  final String currency;
  final String period;

  const TransactionSummaryCard({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.transactionCount,
    this.currency = 'USD',
    this.period = 'This Month',
  });

  double get netAmount => totalIncome - totalExpense;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  period,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$transactionCount transactions',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              'Income',
              totalIncome,
              Colors.green,
              Icons.arrow_downward,
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Expenses',
              totalExpense,
              Colors.red,
              Icons.arrow_upward,
            ),
            const Divider(height: 24),
            _buildSummaryRow(
              'Net',
              netAmount.abs(),
              netAmount >= 0 ? Colors.green : Colors.red,
              netAmount >= 0 ? Icons.trending_up : Icons.trending_down,
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
          '${isNet && netAmount >= 0 ? '+' : isNet && netAmount < 0 ? '-' : ''}${CurrencyFormatter.format(amount: amount, currencyCode: currency)}',
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
