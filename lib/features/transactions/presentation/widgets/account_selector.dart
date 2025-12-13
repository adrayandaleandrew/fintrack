import 'package:flutter/material.dart';

/// Widget for selecting an account
///
/// Displays a list of accounts with icons and balances
/// Used in transaction forms for account selection
class AccountSelector extends StatelessWidget {
  final String? selectedAccountId;
  final ValueChanged<String?> onAccountSelected;
  final String? label;
  final bool showBalance;
  final String? excludeAccountId; // For transfers, exclude source account

  const AccountSelector({
    super.key,
    required this.selectedAccountId,
    required this.onAccountSelected,
    this.label,
    this.showBalance = true,
    this.excludeAccountId,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real accounts from AccountBloc
    final accounts = _getMockAccounts()
        .where((account) => account['id'] != excludeAccountId)
        .toList();

    return DropdownButtonFormField<String>(
      initialValue: selectedAccountId,
      decoration: InputDecoration(
        labelText: label ?? 'Account',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.account_balance_wallet),
      ),
      items: accounts.map((account) {
        return DropdownMenuItem<String>(
          value: account['id'] as String,
          child: Row(
            children: [
              Icon(
                _getAccountIcon(account['type'] as String),
                size: 20,
                color: Colors.grey[700],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      account['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    if (showBalance)
                      Text(
                        '\$${(account['balance'] as double).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
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

  List<Map<String, dynamic>> _getMockAccounts() {
    return [
      {
        'id': 'acc_1',
        'name': 'Checking Account',
        'type': 'bank',
        'balance': 5420.50,
      },
      {
        'id': 'acc_2',
        'name': 'Savings Account',
        'type': 'bank',
        'balance': 15000.00,
      },
      {
        'id': 'acc_3',
        'name': 'Cash',
        'type': 'cash',
        'balance': 250.00,
      },
      {
        'id': 'acc_4',
        'name': 'Credit Card',
        'type': 'credit_card',
        'balance': -1250.75,
      },
      {
        'id': 'acc_5',
        'name': 'Investment',
        'type': 'investment',
        'balance': 25000.00,
      },
    ];
  }

  IconData _getAccountIcon(String type) {
    switch (type) {
      case 'bank':
        return Icons.account_balance;
      case 'cash':
        return Icons.money;
      case 'credit_card':
        return Icons.credit_card;
      case 'investment':
        return Icons.trending_up;
      default:
        return Icons.account_balance_wallet;
    }
  }
}
