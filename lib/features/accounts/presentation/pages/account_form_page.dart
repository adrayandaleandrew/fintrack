import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/account.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_event.dart';
import '../bloc/account_state.dart';

/// Page for creating or editing an account
///
/// Provides form fields for all account properties with validation.
/// Handles both create and update operations.
class AccountFormPage extends StatefulWidget {
  final String userId;
  final Account? account; // Null for create, provided for edit

  const AccountFormPage({
    super.key,
    required this.userId,
    this.account,
  });

  @override
  State<AccountFormPage> createState() => _AccountFormPageState();
}

class _AccountFormPageState extends State<AccountFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _initialBalanceController = TextEditingController();
  final _notesController = TextEditingController();
  final _creditLimitController = TextEditingController();
  final _interestRateController = TextEditingController();

  AccountType _selectedType = AccountType.bank;
  String _selectedCurrency = 'USD';
  String _selectedIcon = 'account_balance';
  String _selectedColor = '#2196F3';
  bool _isActive = true;

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD'];
  final Map<AccountType, List<Map<String, dynamic>>> _iconsByType = {
    AccountType.bank: [
      {'icon': Icons.account_balance, 'name': 'account_balance'},
      {'icon': Icons.savings, 'name': 'savings'},
    ],
    AccountType.cash: [
      {'icon': Icons.account_balance_wallet, 'name': 'account_balance_wallet'},
      {'icon': Icons.money, 'name': 'money'},
    ],
    AccountType.creditCard: [
      {'icon': Icons.credit_card, 'name': 'credit_card'},
      {'icon': Icons.payment, 'name': 'payment'},
    ],
    AccountType.investment: [
      {'icon': Icons.trending_up, 'name': 'trending_up'},
      {'icon': Icons.show_chart, 'name': 'show_chart'},
    ],
  };

  final List<Map<String, dynamic>> _colors = [
    {'color': const Color(0xFF2196F3), 'hex': '#2196F3'},
    {'color': const Color(0xFF4CAF50), 'hex': '#4CAF50'},
    {'color': const Color(0xFFF44336), 'hex': '#F44336'},
    {'color': const Color(0xFFFF9800), 'hex': '#FF9800'},
    {'color': const Color(0xFF9C27B0), 'hex': '#9C27B0'},
    {'color': const Color(0xFF00BCD4), 'hex': '#00BCD4'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      _populateFormWithAccount();
    }
  }

  void _populateFormWithAccount() {
    final account = widget.account!;
    _nameController.text = account.name;
    _initialBalanceController.text = account.balance.toString();
    _notesController.text = account.notes ?? '';
    _selectedType = account.type;
    _selectedCurrency = account.currency;
    _selectedIcon = account.icon;
    _selectedColor = account.color;
    _isActive = account.isActive;

    if (account.creditLimit != null) {
      _creditLimitController.text = account.creditLimit.toString();
    }
    if (account.interestRate != null) {
      _interestRateController.text = account.interestRate.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _initialBalanceController.dispose();
    _notesController.dispose();
    _creditLimitController.dispose();
    _interestRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.account != null;

    return BlocProvider(
      create: (context) => sl<AccountBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? 'Edit Account' : 'Add Account'),
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
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            final isLoading = state is AccountLoading;

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildNameField(),
                  const SizedBox(height: 16),
                  _buildTypeSelector(),
                  const SizedBox(height: 16),
                  _buildBalanceField(isEdit),
                  const SizedBox(height: 16),
                  _buildCurrencySelector(),
                  const SizedBox(height: 16),
                  _buildIconSelector(),
                  const SizedBox(height: 16),
                  _buildColorSelector(),
                  const SizedBox(height: 16),
                  if (_selectedType == AccountType.creditCard) ...[
                    _buildCreditLimitField(),
                    const SizedBox(height: 16),
                  ],
                  if (_selectedType == AccountType.bank ||
                      _selectedType == AccountType.investment) ...[
                    _buildInterestRateField(),
                    const SizedBox(height: 16),
                  ],
                  _buildNotesField(),
                  if (isEdit) ...[
                    const SizedBox(height: 16),
                    _buildActiveToggle(),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(isEdit ? 'Update Account' : 'Create Account'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Account Name',
        hintText: 'e.g., Main Checking',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.text_fields),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter an account name';
        }
        return null;
      },
    );
  }

  Widget _buildTypeSelector() {
    return DropdownButtonFormField<AccountType>(
      value: _selectedType,
      decoration: const InputDecoration(
        labelText: 'Account Type',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.category),
      ),
      items: AccountType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type.displayName),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedType = value;
            // Update icon to default for new type
            _selectedIcon = _iconsByType[value]![0]['name'];
          });
        }
      },
    );
  }

  Widget _buildBalanceField(bool isEdit) {
    return TextFormField(
      controller: _initialBalanceController,
      decoration: InputDecoration(
        labelText: isEdit ? 'Current Balance' : 'Initial Balance',
        hintText: '0.00',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.attach_money),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\-?\d+\.?\d{0,2}')),
      ],
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a balance';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  Widget _buildCurrencySelector() {
    return DropdownButtonFormField<String>(
      value: _selectedCurrency,
      decoration: const InputDecoration(
        labelText: 'Currency',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.monetization_on),
      ),
      items: _currencies.map((currency) {
        return DropdownMenuItem(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedCurrency = value;
          });
        }
      },
    );
  }

  Widget _buildIconSelector() {
    final icons = _iconsByType[_selectedType]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Icon',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: icons.map((iconData) {
            final isSelected = _selectedIcon == iconData['name'];
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedIcon = iconData['name'];
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    iconData['icon'],
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: _colors.map((colorData) {
            final isSelected = _selectedColor == colorData['hex'];
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedColor = colorData['hex'];
                });
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: colorData['color'],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCreditLimitField() {
    return TextFormField(
      controller: _creditLimitController,
      decoration: const InputDecoration(
        labelText: 'Credit Limit',
        hintText: '0.00',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.credit_score),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      validator: (value) {
        if (_selectedType == AccountType.creditCard) {
          if (value == null || value.trim().isEmpty) {
            return 'Credit limit is required for credit cards';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
        }
        return null;
      },
    );
  }

  Widget _buildInterestRateField() {
    return TextFormField(
      controller: _interestRateController,
      decoration: const InputDecoration(
        labelText: 'Interest Rate (%)',
        hintText: '0.00',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.percent),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final rate = double.tryParse(value);
          if (rate == null) {
            return 'Please enter a valid number';
          }
          if (rate < 0 || rate > 100) {
            return 'Interest rate must be between 0 and 100';
          }
        }
        return null;
      },
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: 'Notes (Optional)',
        hintText: 'Add any additional notes...',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.note),
      ),
      maxLines: 3,
    );
  }

  Widget _buildActiveToggle() {
    return SwitchListTile(
      title: const Text('Account Active'),
      subtitle: const Text('Inactive accounts are hidden by default'),
      value: _isActive,
      onChanged: (value) {
        setState(() {
          _isActive = value;
        });
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final balance = double.parse(_initialBalanceController.text);
      final creditLimit = _creditLimitController.text.isNotEmpty
          ? double.parse(_creditLimitController.text)
          : null;
      final interestRate = _interestRateController.text.isNotEmpty
          ? double.parse(_interestRateController.text)
          : null;

      if (widget.account == null) {
        // Create new account
        context.read<AccountBloc>().add(
              CreateAccountRequested(
                userId: widget.userId,
                name: _nameController.text.trim(),
                type: _selectedType,
                initialBalance: balance,
                currency: _selectedCurrency,
                icon: _selectedIcon,
                color: _selectedColor,
                notes: _notesController.text.trim().isEmpty
                    ? null
                    : _notesController.text.trim(),
                creditLimit: creditLimit,
                interestRate: interestRate,
              ),
            );
      } else {
        // Update existing account
        context.read<AccountBloc>().add(
              UpdateAccountRequested(
                accountId: widget.account!.id,
                name: _nameController.text.trim(),
                type: _selectedType,
                currency: _selectedCurrency,
                icon: _selectedIcon,
                color: _selectedColor,
                isActive: _isActive,
                notes: _notesController.text.trim().isEmpty
                    ? null
                    : _notesController.text.trim(),
                creditLimit: creditLimit,
                interestRate: interestRate,
              ),
            );
      }
    }
  }
}
