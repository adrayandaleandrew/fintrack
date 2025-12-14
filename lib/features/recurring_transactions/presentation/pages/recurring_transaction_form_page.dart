import 'package:flutter/material.dart';

/// Recurring transaction form page placeholder
///
/// Full form implementation can be added similar to TransactionFormPage and BudgetFormPage.
/// Would include: account selector, category selector, type toggle, amount input,
/// frequency selector, start date, optional end date, max occurrences.
class RecurringTransactionFormPage extends StatelessWidget {
  final String? recurringTransactionId;

  const RecurringTransactionFormPage({
    super.key,
    this.recurringTransactionId,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = recurringTransactionId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing
            ? 'Edit Recurring Transaction'
            : 'Add Recurring Transaction'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                isEditing
                    ? 'Edit Recurring Transaction'
                    : 'Add Recurring Transaction',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Full form with account selector, category selector, type toggle, amount input, frequency selector, start/end dates, and max occurrences can be implemented similar to BudgetFormPage.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (isEditing)
                Text(
                  'Recurring Transaction ID: $recurringTransactionId',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
