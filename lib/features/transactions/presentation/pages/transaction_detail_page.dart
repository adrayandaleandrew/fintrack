import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';
import 'transaction_form_page.dart';

/// Page displaying detailed information about a single transaction
///
/// Features:
/// - View all transaction details
/// - Edit transaction
/// - Delete transaction with confirmation
/// - View account and category information
class TransactionDetailPage extends StatelessWidget {
  final String transactionId;

  const TransactionDetailPage({
    super.key,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TransactionBloc>()
        ..add(LoadTransactionById(transactionId: transactionId)),
      child: const _TransactionDetailView(),
    );
  }
}

class _TransactionDetailView extends StatelessWidget {
  const _TransactionDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        actions: [
          BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              if (state is TransactionLoaded) {
                return PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      _navigateToEdit(context, state.transaction);
                    } else if (value == 'delete') {
                      _confirmDelete(context, state.transaction.id);
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
            Navigator.of(context).pop();
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
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TransactionLoaded) {
            return _buildTransactionDetails(context, state.transaction);
          }

          if (state is TransactionError) {
            return _buildErrorState(context, state.message);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTransactionDetails(BuildContext context, Transaction transaction) {
    final isIncome = transaction.isIncome;
    final isExpense = transaction.isExpense;
    final isTransfer = transaction.isTransfer;

    Color amountColor;
    IconData icon;
    String typeLabel;
    if (isIncome) {
      amountColor = Colors.green;
      icon = Icons.arrow_downward;
      typeLabel = 'Income';
    } else if (isExpense) {
      amountColor = Colors.red;
      icon = Icons.arrow_upward;
      typeLabel = 'Expense';
    } else {
      amountColor = Colors.blue;
      icon = Icons.swap_horiz;
      typeLabel = 'Transfer';
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Amount Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            color: amountColor.withValues(alpha: 0.1),
            child: Column(
              children: [
                Icon(icon, size: 48, color: amountColor),
                const SizedBox(height: 16),
                Text(
                  '${isExpense ? '-' : isIncome ? '+' : ''}${CurrencyFormatter.format(amount: transaction.amount, currencyCode: transaction.currency)}',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: amountColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  typeLabel,
                  style: TextStyle(
                    fontSize: 16,
                    color: amountColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Transaction Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailCard(
                  'Description',
                  transaction.description,
                  Icons.description,
                ),
                const SizedBox(height: 12),
                _buildDetailCard(
                  'Date',
                  _formatDateTime(transaction.date),
                  Icons.calendar_today,
                ),
                const SizedBox(height: 12),
                _buildDetailCard(
                  'Account',
                  _getAccountName(transaction.accountId),
                  Icons.account_balance_wallet,
                ),
                if (isTransfer && transaction.toAccountId != null) ...[
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    'To Account',
                    _getAccountName(transaction.toAccountId!),
                    Icons.arrow_forward,
                  ),
                ],
                if (!isTransfer) ...[
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    'Category',
                    _getCategoryName(transaction.categoryId),
                    Icons.category,
                  ),
                ],
                if (transaction.notes != null && transaction.notes!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    'Notes',
                    transaction.notes!,
                    Icons.note,
                  ),
                ],
                const SizedBox(height: 12),
                _buildDetailCard(
                  'Created',
                  _formatDateTime(transaction.createdAt),
                  Icons.access_time,
                ),
                if (transaction.createdAt != transaction.updatedAt) ...[
                  const SizedBox(height: 12),
                  _buildDetailCard(
                    'Last Updated',
                    _formatDateTime(transaction.updatedAt),
                    Icons.update,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading transaction',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_monthName(dateTime.month)} ${dateTime.day}, ${dateTime.year} at ${_formatTime(dateTime)}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  String _getAccountName(String accountId) {
    // TODO: Fetch real account name from accounts feature
    const accountNames = {
      'acc_1': 'Checking Account',
      'acc_2': 'Savings Account',
      'acc_3': 'Cash',
      'acc_4': 'Credit Card',
      'acc_5': 'Investment',
    };
    return accountNames[accountId] ?? 'Unknown Account';
  }

  String _getCategoryName(String categoryId) {
    // TODO: Fetch real category name from categories feature
    const categoryNames = {
      'cat_1': 'Salary',
      'cat_2': 'Freelance',
      'cat_11': 'Food & Dining',
      'cat_12': 'Groceries',
      'cat_13': 'Transportation',
    };
    return categoryNames[categoryId] ?? 'Unknown Category';
  }

  void _navigateToEdit(BuildContext context, Transaction transaction) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TransactionFormPage(
          userId: transaction.userId,
          transaction: transaction,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String transactionId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text(
          'Are you sure you want to delete this transaction? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TransactionBloc>().add(
                    DeleteTransaction(transactionId: transactionId),
                  );
              Navigator.of(dialogContext).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
