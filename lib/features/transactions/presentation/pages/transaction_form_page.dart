import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';

/// Page for adding or editing a transaction
///
/// Features:
/// - Create new transaction (income, expense, transfer)
/// - Edit existing transaction
/// - Form validation
/// - Account and category selection
/// - Date and time picker
/// - Amount input with currency formatting
class TransactionFormPage extends StatefulWidget {
  final Transaction? transaction;

  const TransactionFormPage({
    super.key,
    this.transaction,
  });

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _notesController;

  TransactionType _selectedType = TransactionType.expense;
  String? _selectedAccountId;
  String? _selectedCategoryId;
  String? _selectedToAccountId; // For transfers
  DateTime _selectedDate = DateTime.now();
  String _selectedCurrency = 'USD';

  bool get _isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.transaction?.amount.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.transaction?.description ?? '',
    );
    _notesController = TextEditingController(
      text: widget.transaction?.notes ?? '',
    );

    if (widget.transaction != null) {
      _selectedType = widget.transaction!.type;
      _selectedAccountId = widget.transaction!.accountId;
      _selectedCategoryId = widget.transaction!.categoryId;
      _selectedToAccountId = widget.transaction!.toAccountId;
      _selectedDate = widget.transaction!.date;
      _selectedCurrency = widget.transaction!.currency;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TransactionBloc>(),
      child: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state is TransactionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is TransactionActionInProgress;

          return Scaffold(
            appBar: AppBar(
              title: Text(_isEditing ? 'Edit Transaction' : 'Add Transaction'),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildTypeSelector(),
                  const SizedBox(height: 24),
                  _buildAmountField(),
                  const SizedBox(height: 16),
                  _buildDescriptionField(),
                  const SizedBox(height: 16),
                  _buildAccountSelector(),
                  if (_selectedType == TransactionType.transfer) ...[
                    const SizedBox(height: 16),
                    _buildToAccountSelector(),
                  ],
                  if (_selectedType != TransactionType.transfer) ...[
                    const SizedBox(height: 16),
                    _buildCategorySelector(),
                  ],
                  const SizedBox(height: 16),
                  _buildDatePicker(),
                  const SizedBox(height: 16),
                  _buildNotesField(),
                  const SizedBox(height: 32),
                  _buildSubmitButton(context, isLoading),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaction Type',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        SegmentedButton<TransactionType>(
          segments: const [
            ButtonSegment(
              value: TransactionType.income,
              label: Text('Income'),
              icon: Icon(Icons.arrow_downward, color: Colors.green),
            ),
            ButtonSegment(
              value: TransactionType.expense,
              label: Text('Expense'),
              icon: Icon(Icons.arrow_upward, color: Colors.red),
            ),
            ButtonSegment(
              value: TransactionType.transfer,
              label: Text('Transfer'),
              icon: Icon(Icons.swap_horiz, color: Colors.blue),
            ),
          ],
          selected: {_selectedType},
          onSelectionChanged: (Set<TransactionType> newSelection) {
            setState(() {
              _selectedType = newSelection.first;
              // Clear category for transfers
              if (_selectedType == TransactionType.transfer) {
                _selectedCategoryId = null;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      decoration: const InputDecoration(
        labelText: 'Amount',
        prefixText: '\$ ',
        border: OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an amount';
        }
        final amount = double.tryParse(value);
        if (amount == null || amount <= 0) {
          return 'Amount must be greater than 0';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a description';
        }
        return null;
      },
    );
  }

  Widget _buildAccountSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedAccountId,
      decoration: const InputDecoration(
        labelText: 'Account',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'acc_1', child: Text('Checking Account')),
        DropdownMenuItem(value: 'acc_2', child: Text('Savings Account')),
        DropdownMenuItem(value: 'acc_3', child: Text('Cash')),
        DropdownMenuItem(value: 'acc_4', child: Text('Credit Card')),
        DropdownMenuItem(value: 'acc_5', child: Text('Investment')),
      ],
      onChanged: (value) => setState(() => _selectedAccountId = value),
      validator: (value) {
        if (value == null) {
          return 'Please select an account';
        }
        return null;
      },
    );
  }

  Widget _buildToAccountSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedToAccountId,
      decoration: const InputDecoration(
        labelText: 'To Account',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'acc_1', child: Text('Checking Account')),
        DropdownMenuItem(value: 'acc_2', child: Text('Savings Account')),
        DropdownMenuItem(value: 'acc_3', child: Text('Cash')),
        DropdownMenuItem(value: 'acc_4', child: Text('Credit Card')),
        DropdownMenuItem(value: 'acc_5', child: Text('Investment')),
      ],
      onChanged: (value) => setState(() => _selectedToAccountId = value),
      validator: (value) {
        if (_selectedType == TransactionType.transfer && value == null) {
          return 'Please select a destination account';
        }
        if (value == _selectedAccountId) {
          return 'Cannot transfer to the same account';
        }
        return null;
      },
    );
  }

  Widget _buildCategorySelector() {
    return DropdownButtonFormField<String>(
      value: _selectedCategoryId,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      items: const [
        // Income categories
        DropdownMenuItem(value: 'cat_1', child: Text('Salary')),
        DropdownMenuItem(value: 'cat_2', child: Text('Freelance')),
        // Expense categories
        DropdownMenuItem(value: 'cat_11', child: Text('Food & Dining')),
        DropdownMenuItem(value: 'cat_12', child: Text('Groceries')),
        DropdownMenuItem(value: 'cat_13', child: Text('Transportation')),
      ],
      onChanged: (value) => setState(() => _selectedCategoryId = value),
      validator: (value) {
        if (_selectedType != TransactionType.transfer && value == null) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          setState(() => _selectedDate = date);
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Date',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: 'Notes (optional)',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }

  Widget _buildSubmitButton(BuildContext context, bool isLoading) {
    return ElevatedButton(
      onPressed: isLoading ? null : () => _submitForm(context),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(_isEditing ? 'Update Transaction' : 'Add Transaction'),
    );
  }

  void _submitForm(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final transaction = Transaction(
      id: widget.transaction?.id ?? 'txn_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user_1',
      accountId: _selectedAccountId!,
      categoryId: _selectedCategoryId ?? '',
      type: _selectedType,
      amount: double.parse(_amountController.text),
      currency: _selectedCurrency,
      description: _descriptionController.text,
      date: _selectedDate,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      toAccountId: _selectedToAccountId,
      createdAt: widget.transaction?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (_isEditing) {
      context.read<TransactionBloc>().add(UpdateTransaction(transaction: transaction));
    } else {
      context.read<TransactionBloc>().add(CreateTransaction(transaction: transaction));
    }
  }
}
