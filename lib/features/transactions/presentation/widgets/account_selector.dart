import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../accounts/domain/entities/account.dart';
import '../../../accounts/presentation/bloc/account_bloc.dart';
import '../../../accounts/presentation/bloc/account_event.dart';
import '../../../accounts/presentation/bloc/account_state.dart';

/// Widget for selecting an account
///
/// Displays a list of accounts with icons and balances
/// Used in transaction forms for account selection
class AccountSelector extends StatelessWidget {
  final String userId;
  final String? selectedAccountId;
  final ValueChanged<String?> onAccountSelected;
  final String? label;
  final bool showBalance;
  final String? excludeAccountId; // For transfers, exclude source account

  const AccountSelector({
    super.key,
    required this.userId,
    required this.selectedAccountId,
    required this.onAccountSelected,
    this.label,
    this.showBalance = true,
    this.excludeAccountId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AccountBloc>()..add(LoadAccounts(userId: userId)),
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountLoading) {
            return DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: label ?? 'Account',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.account_balance_wallet),
              ),
              items: const [],
              onChanged: null,
              hint: const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Loading accounts...'),
                ],
              ),
            );
          }

          if (state is AccountError) {
            return DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: label ?? 'Account',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.account_balance_wallet),
                errorText: 'Failed to load accounts',
              ),
              items: const [],
              onChanged: null,
            );
          }

          if (state is AccountsLoaded) {
            // Filter active accounts and exclude specified account
            final accounts = state.accounts
                .where((account) =>
                    account.isActive && account.id != excludeAccountId)
                .toList();

            if (accounts.isEmpty) {
              return DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: label ?? 'Account',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.account_balance_wallet),
                ),
                items: const [],
                onChanged: null,
                hint: const Text('No accounts available'),
              );
            }

            return DropdownButtonFormField<String>(
              value: selectedAccountId,
              decoration: InputDecoration(
                labelText: label ?? 'Account',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.account_balance_wallet),
              ),
              items: accounts.map((account) {
                return DropdownMenuItem<String>(
                  value: account.id,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getAccountIcon(account.type),
                        size: 20,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              account.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (showBalance)
                              Text(
                                CurrencyFormatter.format(
                                  amount: account.balance,
                                  currencyCode: account.currency,
                                ),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: account.balance >= 0
                                      ? Colors.green[700]
                                      : Colors.red[700],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onAccountSelected,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an account';
                }
                return null;
              },
            );
          }

          // Default empty state
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: label ?? 'Account',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.account_balance_wallet),
            ),
            items: const [],
            onChanged: null,
          );
        },
      ),
    );
  }

  IconData _getAccountIcon(AccountType type) {
    switch (type) {
      case AccountType.bank:
        return Icons.account_balance;
      case AccountType.cash:
        return Icons.money;
      case AccountType.creditCard:
        return Icons.credit_card;
      case AccountType.investment:
        return Icons.trending_up;
    }
  }
}
