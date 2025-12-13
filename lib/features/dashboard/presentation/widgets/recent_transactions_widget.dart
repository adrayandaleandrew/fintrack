import 'package:flutter/material.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/presentation/widgets/transaction_list_item.dart';

/// Widget displaying recent transactions
///
/// Shows a list of recent transactions with a "View All" button.
class RecentTransactionsWidget extends StatelessWidget {
  final List<Transaction> transactions;
  final VoidCallback onViewAll;

  const RecentTransactionsWidget({
    super.key,
    required this.transactions,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: onViewAll,
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (transactions.isEmpty)
              _buildEmptyState()
            else
              ...transactions.map(
                (transaction) => TransactionListItem(
                  transaction: transaction,
                  onTap: () => _navigateToDetail(context, transaction.id),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'No transactions yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, String transactionId) {
    Navigator.of(context).pushNamed('/transactions/$transactionId');
  }
}
