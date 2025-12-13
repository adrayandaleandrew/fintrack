import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/account.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_event.dart';
import '../bloc/account_state.dart';
import 'account_form_page.dart';
import 'account_detail_page.dart';

/// Page displaying list of user accounts
///
/// Shows all accounts with their balances and types.
/// Allows filtering by active/inactive and navigation to add/edit.
class AccountListPage extends StatelessWidget {
  final String userId;

  const AccountListPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AccountBloc>()
        ..add(LoadAccounts(userId: userId, activeOnly: false)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Accounts'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterOptions(context),
              tooltip: 'Filter accounts',
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
              // Reload accounts after successful action
              context.read<AccountBloc>().add(
                    LoadAccounts(userId: userId, activeOnly: false),
                  );
            }
          },
          builder: (context, state) {
            if (state is AccountLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AccountsLoaded) {
              if (state.accounts.isEmpty) {
                return _buildEmptyState(context);
              }
              return _buildAccountList(context, state.accounts);
            }

            if (state is AccountError) {
              return _buildErrorState(context, state.message);
            }

            return _buildEmptyState(context);
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _navigateToAddAccount(context),
          icon: const Icon(Icons.add),
          label: const Text('Add Account'),
        ),
      ),
    );
  }

  Widget _buildAccountList(BuildContext context, List<Account> accounts) {
    // Group accounts by type
    final bankAccounts =
        accounts.where((a) => a.type == AccountType.bank).toList();
    final cashAccounts =
        accounts.where((a) => a.type == AccountType.cash).toList();
    final creditAccounts =
        accounts.where((a) => a.type == AccountType.creditCard).toList();
    final investmentAccounts =
        accounts.where((a) => a.type == AccountType.investment).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTotalBalanceCard(context, accounts),
        const SizedBox(height: 24),
        if (bankAccounts.isNotEmpty) ...[
          _buildSectionHeader('Bank Accounts'),
          ...bankAccounts.map((account) => _buildAccountCard(context, account)),
          const SizedBox(height: 16),
        ],
        if (cashAccounts.isNotEmpty) ...[
          _buildSectionHeader('Cash'),
          ...cashAccounts.map((account) => _buildAccountCard(context, account)),
          const SizedBox(height: 16),
        ],
        if (creditAccounts.isNotEmpty) ...[
          _buildSectionHeader('Credit Cards'),
          ...creditAccounts
              .map((account) => _buildAccountCard(context, account)),
          const SizedBox(height: 16),
        ],
        if (investmentAccounts.isNotEmpty) ...[
          _buildSectionHeader('Investments'),
          ...investmentAccounts
              .map((account) => _buildAccountCard(context, account)),
          const SizedBox(height: 16),
        ],
        const SizedBox(height: 80), // Space for FAB
      ],
    );
  }

  Widget _buildTotalBalanceCard(BuildContext context, List<Account> accounts) {
    // Calculate total by currency
    final balancesByCurrency = <String, double>{};
    for (final account in accounts.where((a) => a.isActive)) {
      balancesByCurrency[account.currency] =
          (balancesByCurrency[account.currency] ?? 0) + account.balance;
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Balance',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            ...balancesByCurrency.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  CurrencyFormatter.format(
                    amount: entry.value,
                    currencyCode: entry.key,
                  ),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: entry.value >= 0 ? Colors.green : Colors.red,
                      ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, Account account) {
    final color = _parseColor(account.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToAccountDetail(context, account),
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
                    if (!account.isActive)
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No accounts yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first account to get started',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 80, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading accounts',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<AccountBloc>().add(
                    LoadAccounts(userId: userId, activeOnly: false),
                  );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Filter Accounts'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Accounts'),
              onTap: () {
                Navigator.pop(dialogContext);
                context.read<AccountBloc>().add(
                      LoadAccounts(userId: userId, activeOnly: false),
                    );
              },
            ),
            ListTile(
              title: const Text('Active Only'),
              onTap: () {
                Navigator.pop(dialogContext);
                context.read<AccountBloc>().add(
                      LoadAccounts(userId: userId, activeOnly: true),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AccountFormPage(userId: userId),
      ),
    );
  }

  void _navigateToAccountDetail(BuildContext context, Account account) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AccountDetailPage(account: account),
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
