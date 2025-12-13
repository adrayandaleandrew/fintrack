import 'package:flutter/material.dart';
import '../../domain/entities/transaction.dart';

/// Filter dialog for transactions
///
/// Allows filtering by:
/// - Date range (start and end date)
/// - Account
/// - Category
/// - Transaction type (Income, Expense, Transfer)
class TransactionFilterDialog extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final String? initialAccountId;
  final String? initialCategoryId;
  final TransactionType? initialType;

  const TransactionFilterDialog({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    this.initialAccountId,
    this.initialCategoryId,
    this.initialType,
  });

  @override
  State<TransactionFilterDialog> createState() =>
      _TransactionFilterDialogState();
}

class _TransactionFilterDialogState extends State<TransactionFilterDialog> {
  late DateTime? _startDate;
  late DateTime? _endDate;
  late String? _accountId;
  late String? _categoryId;
  late TransactionType? _type;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
    _accountId = widget.initialAccountId;
    _categoryId = widget.initialCategoryId;
    _type = widget.initialType;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Transactions'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Date Range',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildDateField(
              label: 'Start Date',
              date: _startDate,
              onDateSelected: (date) => setState(() => _startDate = date),
            ),
            const SizedBox(height: 8),
            _buildDateField(
              label: 'End Date',
              date: _endDate,
              onDateSelected: (date) => setState(() => _endDate = date),
            ),
            const SizedBox(height: 16),
            const Text(
              'Transaction Type',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<TransactionType?>(
              initialValue: _type,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: null, child: Text('All Types')),
                DropdownMenuItem(
                  value: TransactionType.income,
                  child: Text('Income'),
                ),
                DropdownMenuItem(
                  value: TransactionType.expense,
                  child: Text('Expense'),
                ),
                DropdownMenuItem(
                  value: TransactionType.transfer,
                  child: Text('Transfer'),
                ),
              ],
              onChanged: (value) => setState(() => _type = value),
            ),
            const SizedBox(height: 16),
            const Text(
              'Account',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String?>(
              initialValue: _accountId,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: null, child: Text('All Accounts')),
                DropdownMenuItem(value: 'acc_1', child: Text('Checking Account')),
                DropdownMenuItem(value: 'acc_2', child: Text('Savings Account')),
                DropdownMenuItem(value: 'acc_3', child: Text('Cash')),
                DropdownMenuItem(value: 'acc_4', child: Text('Credit Card')),
                DropdownMenuItem(value: 'acc_5', child: Text('Investment')),
              ],
              onChanged: (value) => setState(() => _accountId = value),
            ),
            const SizedBox(height: 16),
            const Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String?>(
              initialValue: _categoryId,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: null, child: Text('All Categories')),
                DropdownMenuItem(value: 'cat_1', child: Text('Salary')),
                DropdownMenuItem(value: 'cat_2', child: Text('Freelance')),
                DropdownMenuItem(value: 'cat_11', child: Text('Food & Dining')),
                DropdownMenuItem(value: 'cat_12', child: Text('Groceries')),
                DropdownMenuItem(value: 'cat_13', child: Text('Transportation')),
              ],
              onChanged: (value) => setState(() => _categoryId = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _startDate = null;
              _endDate = null;
              _accountId = null;
              _categoryId = null;
              _type = null;
            });
          },
          child: const Text('Clear All'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'startDate': _startDate,
              'endDate': _endDate,
              'accountId': _accountId,
              'categoryId': _categoryId,
              'type': _type,
            });
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required ValueChanged<DateTime?> onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: date != null
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () => onDateSelected(null),
                )
              : const Icon(Icons.calendar_today),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: Text(
          date != null ? _formatDate(date) : 'Select date',
          style: TextStyle(
            fontSize: 14,
            color: date != null ? null : Colors.grey,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
