import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';
import '../widgets/account_selector.dart';
import '../widgets/category_selector.dart';

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
  final String userId;
  final Transaction? transaction;

  const TransactionFormPage({
    super.key,
    required this.userId,
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
    return AccountSelector(
      userId: widget.userId,
      selectedAccountId: _selectedAccountId,
      onAccountSelected: (value) => setState(() => _selectedAccountId = value),
      label: 'Account',
      showBalance: true,
    );
  }

  Widget _buildToAccountSelector() {
    return AccountSelector(
      userId: widget.userId,
      selectedAccountId: _selectedToAccountId,
      onAccountSelected: (value) => setState(() => _selectedToAccountId = value),
      label: 'To Account',
      showBalance: true,
      excludeAccountId: _selectedAccountId, // Exclude source account
    );
  }

  Widget _buildCategorySelector() {
    return CategorySelector(
      userId: widget.userId,
      selectedCategoryId: _selectedCategoryId,
      onCategorySelected: (value) => setState(() => _selectedCategoryId = value),
      transactionType: _selectedType,
      label: 'Category',
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
      userId: widget.userId,
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
