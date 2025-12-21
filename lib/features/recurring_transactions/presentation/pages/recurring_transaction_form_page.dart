import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/di/injection_container.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/presentation/widgets/account_selector.dart';
import '../../../transactions/presentation/widgets/category_selector.dart';
import '../../domain/entities/recurring_transaction.dart';
import '../bloc/recurring_transaction_bloc.dart';
import '../bloc/recurring_transaction_event.dart';
import '../bloc/recurring_transaction_state.dart';

/// Recurring transaction form page for adding or editing recurring transactions
///
/// Features:
/// - Create new recurring transaction
/// - Edit existing recurring transaction
/// - Type selection (Income/Expense/Transfer)
/// - Account and category selection
/// - Frequency selection (Daily, Weekly, Monthly, etc.)
/// - Start date and optional end date
/// - Optional max occurrences
/// - Form validation
class RecurringTransactionFormPage extends StatefulWidget {
  final String userId;
  final RecurringTransaction? recurringTransaction;

  const RecurringTransactionFormPage({
    super.key,
    required this.userId,
    this.recurringTransaction,
  });

  @override
  State<RecurringTransactionFormPage> createState() =>
      _RecurringTransactionFormPageState();
}

class _RecurringTransactionFormPageState
    extends State<RecurringTransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _notesController;
  late final TextEditingController _maxOccurrencesController;

  TransactionType _selectedType = TransactionType.expense;
  String? _selectedAccountId;
  String? _selectedCategoryId;
  String? _selectedToAccountId; // For transfers
  String _selectedCurrency = 'USD';
  RecurringFrequency _selectedFrequency = RecurringFrequency.monthly;
  DateTime _startDate = DateTime.now();
  bool _hasEndDate = false;
  DateTime? _endDate;
  bool _hasMaxOccurrences = false;
  bool _isActive = true;

  bool get _isEditing => widget.recurringTransaction != null;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.recurringTransaction?.amount.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.recurringTransaction?.description ?? '',
    );
    _notesController = TextEditingController(
      text: widget.recurringTransaction?.notes ?? '',
    );
    _maxOccurrencesController = TextEditingController(
      text: widget.recurringTransaction?.maxOccurrences?.toString() ?? '',
    );

    if (widget.recurringTransaction != null) {
      _selectedType = widget.recurringTransaction!.type;
      _selectedAccountId = widget.recurringTransaction!.accountId;
      _selectedCategoryId = widget.recurringTransaction!.categoryId;
      _selectedCurrency = widget.recurringTransaction!.currency;
      _selectedFrequency = widget.recurringTransaction!.frequency;
      _startDate = widget.recurringTransaction!.startDate;
      _hasEndDate = widget.recurringTransaction!.endDate != null;
      _endDate = widget.recurringTransaction!.endDate;
      _hasMaxOccurrences = widget.recurringTransaction!.maxOccurrences != null;
      _isActive = widget.recurringTransaction!.isActive;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _maxOccurrencesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RecurringTransactionBloc>(),
      child: BlocConsumer<RecurringTransactionBloc, RecurringTransactionState>(
        listener: (context, state) {
          if (state is RecurringTransactionActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state is RecurringTransactionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                _isEditing
                    ? 'Edit Recurring Transaction'
                    : 'Add Recurring Transaction',
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Transaction Type Selector
                  _buildTypeSelector(),
                  const SizedBox(height: 16),

                  // Account Selector
                  AccountSelector(
                    userId: widget.userId,
                    selectedAccountId: _selectedAccountId,
                    onAccountSelected: (accountId) {
                      setState(() {
                        _selectedAccountId = accountId;
                      });
                    },
                    label: 'From Account',
                  ),
                  const SizedBox(height: 16),

                  // Category Selector (not for transfers)
                  if (_selectedType != TransactionType.transfer)
                    CategorySelector(
                      userId: widget.userId,
                      selectedCategoryId: _selectedCategoryId,
                      onCategorySelected: (categoryId) {
                        setState(() {
                          _selectedCategoryId = categoryId;
                        });
                      },
                      transactionType: _selectedType,
                    ),
                  if (_selectedType != TransactionType.transfer)
                    const SizedBox(height: 16),

                  // To Account Selector (for transfers)
                  if (_selectedType == TransactionType.transfer)
                    AccountSelector(
                      userId: widget.userId,
                      selectedAccountId: _selectedToAccountId,
                      onAccountSelected: (accountId) {
                        setState(() {
                          _selectedToAccountId = accountId;
                        });
                      },
                      label: 'To Account',
                      excludeAccountId: _selectedAccountId,
                    ),
                  if (_selectedType == TransactionType.transfer)
                    const SizedBox(height: 16),

                  // Amount Field
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: const OutlineInputBorder(),
                      prefixText: _getCurrencySymbol(_selectedCurrency),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
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
                  ),
                  const SizedBox(height: 16),

                  // Currency Selector
                  DropdownButtonFormField<String>(
                    value: _selectedCurrency,
                    decoration: const InputDecoration(
                      labelText: 'Currency',
                      border: OutlineInputBorder(),
                    ),
                    items: ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD']
                        .map((currency) => DropdownMenuItem(
                              value: currency,
                              child: Text(currency),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCurrency = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description Field
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., Monthly Rent',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Frequency Selector
                  DropdownButtonFormField<RecurringFrequency>(
                    value: _selectedFrequency,
                    decoration: const InputDecoration(
                      labelText: 'Frequency',
                      border: OutlineInputBorder(),
                    ),
                    items: RecurringFrequency.values
                        .map((frequency) => DropdownMenuItem(
                              value: frequency,
                              child: Text(frequency.displayName),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedFrequency = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Start Date Picker
                  InkWell(
                    onTap: () => _selectStartDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Has End Date Toggle
                  SwitchListTile(
                    title: const Text('Set End Date'),
                    subtitle: const Text('Stop after a specific date'),
                    value: _hasEndDate,
                    onChanged: (value) {
                      setState(() {
                        _hasEndDate = value;
                        if (!value) {
                          _endDate = null;
                        }
                      });
                    },
                  ),

                  // End Date Picker (conditional)
                  if (_hasEndDate) ...[
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectEndDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'End Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          _endDate != null
                              ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                              : 'Select end date',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Has Max Occurrences Toggle
                  SwitchListTile(
                    title: const Text('Limit Occurrences'),
                    subtitle: const Text('Stop after a number of occurrences'),
                    value: _hasMaxOccurrences,
                    onChanged: (value) {
                      setState(() {
                        _hasMaxOccurrences = value;
                        if (!value) {
                          _maxOccurrencesController.clear();
                        }
                      });
                    },
                  ),

                  // Max Occurrences Field (conditional)
                  if (_hasMaxOccurrences) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _maxOccurrencesController,
                      decoration: const InputDecoration(
                        labelText: 'Max Occurrences',
                        border: OutlineInputBorder(),
                        hintText: 'e.g., 12 for one year of monthly payments',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (_hasMaxOccurrences) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter max occurrences';
                          }
                          final occurrences = int.tryParse(value);
                          if (occurrences == null || occurrences <= 0) {
                            return 'Must be greater than 0';
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Notes Field
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes (Optional)',
                      border: OutlineInputBorder(),
                      hintText: 'Additional details',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Active Toggle (only in edit mode)
                  if (_isEditing)
                    SwitchListTile(
                      title: const Text('Active'),
                      subtitle: Text(_isActive
                          ? 'This recurring transaction is active'
                          : 'This recurring transaction is paused'),
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                    ),
                  if (_isEditing) const SizedBox(height: 16),

                  // Save Button
                  ElevatedButton(
                    onPressed: state is RecurringTransactionActionInProgress
                        ? null
                        : _saveRecurringTransaction,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: state is RecurringTransactionActionInProgress
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            _isEditing
                                ? 'Update Recurring Transaction'
                                : 'Create Recurring Transaction',
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
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
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<TransactionType>(
          segments: const [
            ButtonSegment(
              value: TransactionType.income,
              label: Text('Income'),
              icon: Icon(Icons.arrow_downward),
            ),
            ButtonSegment(
              value: TransactionType.expense,
              label: Text('Expense'),
              icon: Icon(Icons.arrow_upward),
            ),
            ButtonSegment(
              value: TransactionType.transfer,
              label: Text('Transfer'),
              icon: Icon(Icons.swap_horiz),
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

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate.add(const Duration(days: 365)),
      firstDate: _startDate,
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
      case 'CAD':
      case 'AUD':
        return '\$ ';
      case 'EUR':
        return '€ ';
      case 'GBP':
        return '£ ';
      case 'JPY':
        return '¥ ';
      default:
        return '';
    }
  }

  void _saveRecurringTransaction() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Additional validation
    if (_selectedAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an account'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedType != TransactionType.transfer &&
        _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedType == TransactionType.transfer &&
        _selectedToAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a destination account'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_hasEndDate && _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an end date'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final amount = double.parse(_amountController.text);
    final description = _descriptionController.text.trim();
    final notes = _notesController.text.trim();
    final maxOccurrences = _hasMaxOccurrences
        ? int.tryParse(_maxOccurrencesController.text)
        : null;

    final recurringTransaction = RecurringTransaction(
      id: _isEditing ? widget.recurringTransaction!.id : const Uuid().v4(),
      userId: widget.userId,
      accountId: _selectedAccountId!,
      categoryId: _selectedCategoryId ?? '',
      type: _selectedType,
      amount: amount,
      currency: _selectedCurrency,
      description: description,
      notes: notes.isNotEmpty ? notes : null,
      tags: [],
      frequency: _selectedFrequency,
      startDate: _startDate,
      endDate: _endDate,
      lastProcessedDate: _isEditing
          ? widget.recurringTransaction!.lastProcessedDate
          : null,
      maxOccurrences: maxOccurrences,
      occurrenceCount:
          _isEditing ? widget.recurringTransaction!.occurrenceCount : 0,
      isActive: _isActive,
      createdAt:
          _isEditing ? widget.recurringTransaction!.createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (_isEditing) {
      context.read<RecurringTransactionBloc>().add(
            UpdateRecurringTransaction(
              recurringTransaction: recurringTransaction,
            ),
          );
    } else {
      context.read<RecurringTransactionBloc>().add(
            CreateRecurringTransaction(
              recurringTransaction: recurringTransaction,
            ),
          );
    }
  }
}
