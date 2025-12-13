import 'package:flutter/material.dart';

/// Widget displaying quick action buttons
///
/// Provides shortcuts to common actions like adding
/// transactions and accounts.
class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onAddTransaction;
  final VoidCallback onAddAccount;
  final VoidCallback onViewAccounts;
  final VoidCallback onViewTransactions;

  const QuickActionsWidget({
    super.key,
    required this.onAddTransaction,
    required this.onAddAccount,
    required this.onViewAccounts,
    required this.onViewTransactions,
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
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    label: 'Add Transaction',
                    icon: Icons.add_circle_outline,
                    color: Theme.of(context).colorScheme.primary,
                    onTap: onAddTransaction,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    label: 'Add Account',
                    icon: Icons.account_balance_wallet_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                    onTap: onAddAccount,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    label: 'View Accounts',
                    icon: Icons.account_balance,
                    color: Colors.teal,
                    onTap: onViewAccounts,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    label: 'View Transactions',
                    icon: Icons.receipt_long,
                    color: Colors.orange,
                    onTap: onViewTransactions,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
