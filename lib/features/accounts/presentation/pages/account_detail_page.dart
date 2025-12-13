import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/account.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_event.dart';
import '../bloc/account_state.dart';
import 'account_form_page.dart';

/// Page displaying detailed information about a single account
///
/// Shows account details, balance, and provides options to edit or delete.
class AccountDetailPage extends StatelessWidget {
  final Account account;

  const AccountDetailPage({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account Details'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _navigateToEditAccount(context),
              tooltip: 'Edit account',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteConfirmation(context),
              tooltip: 'Delete account',
            ),
          ],
        ),
        body: BlocConsumer<AccountBloc, AccountState>(
          listener: (context, state) {
            if (state is AccountError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is AccountActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigate back after successful delete
              if (state.message.contains('deleted')) {
                Navigator.pop(context);
              }
            }
          },
          builder: (context, state) {
            if (state is AccountLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Use updated account if available
            final displayAccount = (state is AccountLoaded)
                ? state.account
                : (state is AccountActionSuccess && state.account != null)
                    ? state.account!
                    : account;

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildAccountHeader(context, displayAccount),
                  const SizedBox(height: 16),
                  _buildAccountDetails(context, displayAccount),
                  const SizedBox(height: 16),
                  _buildAccountStats(context, displayAccount),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAccountHeader(BuildContext context, Account displayAccount) {
    final color = _parseColor(displayAccount.color);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconData(displayAccount.icon),
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            displayAccount.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            displayAccount.type.displayName,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            CurrencyFormatter.format(
              amount: displayAccount.balance,
              currencyCode: displayAccount.currency,
            ),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (!displayAccount.isActive)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'INACTIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAccountDetails(BuildContext context, Account displayAccount) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            _buildDetailRow('Currency', displayAccount.currency),
            _buildDetailRow(
              'Created',
              DateFormat.yMMMd().format(displayAccount.createdAt),
            ),
            _buildDetailRow(
              'Last Updated',
              DateFormat.yMMMd().format(displayAccount.updatedAt),
            ),
            _buildDetailRow(
              'Status',
              displayAccount.isActive ? 'Active' : 'Inactive',
            ),
            if (displayAccount.type == AccountType.creditCard &&
                displayAccount.creditLimit != null) ...[
              const Divider(),
              _buildDetailRow(
                'Credit Limit',
                CurrencyFormatter.format(
                  amount: displayAccount.creditLimit!,
                  currencyCode: displayAccount.currency,
                ),
              ),
              _buildDetailRow(
                'Available Credit',
                CurrencyFormatter.format(
                  amount: displayAccount.availableCredit,
                  currencyCode: displayAccount.currency,
                ),
              ),
              _buildCreditUtilizationBar(displayAccount),
            ],
            if (displayAccount.interestRate != null) ...[
              const Divider(),
              _buildDetailRow(
                'Interest Rate',
                '${displayAccount.interestRate}%',
              ),
            ],
            if (displayAccount.notes != null &&
                displayAccount.notes!.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Notes',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                displayAccount.notes!,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAccountStats(BuildContext context, Account displayAccount) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Transaction history and statistics will be available once the Transactions feature is implemented.',
              style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditUtilizationBar(Account displayAccount) {
    if (displayAccount.creditLimit == null || displayAccount.creditLimit == 0) {
      return const SizedBox.shrink();
    }

    final utilized = displayAccount.balance.abs();
    final limit = displayAccount.creditLimit!;
    final utilizationPercent = (utilized / limit * 100).clamp(0, 100);

    Color barColor;
    if (utilizationPercent < 30) {
      barColor = Colors.green;
    } else if (utilizationPercent < 70) {
      barColor = Colors.orange;
    } else {
      barColor = Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Credit Utilization: ${utilizationPercent.toStringAsFixed(1)}%',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: utilizationPercent / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  void _navigateToEditAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AccountFormPage(
          userId: account.userId,
          account: account,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text(
          'Are you sure you want to delete "${account.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AccountBloc>().add(
                    DeleteAccountRequested(accountId: account.id),
                  );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
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
      case 'credit_card':
        return Icons.credit_card;
      case 'trending_up':
        return Icons.trending_up;
      default:
        return Icons.account_balance_wallet;
    }
  }
}
