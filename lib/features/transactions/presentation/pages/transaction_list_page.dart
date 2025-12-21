import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/transaction.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';
import '../widgets/transaction_filter_dialog.dart';
import '../widgets/transaction_search_dialog.dart';

/// Page displaying list of all transactions
///
/// Features:
/// - View all transactions sorted by date (newest first)
/// - Filter by date range, account, category, type
/// - Search transactions by description/notes
/// - Navigate to transaction detail
/// - Quick action to add new transaction
class TransactionListPage extends StatelessWidget {
  final String userId;

  const TransactionListPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TransactionBloc>()
        ..add(LoadTransactions(userId: userId)),
      child: _TransactionListView(userId: userId),
    );
  }
}

class _TransactionListView extends StatelessWidget {
  final String userId;

  const _TransactionListView({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
            tooltip: 'Search transactions',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filter transactions',
          ),
        ],
      ),
      body: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          } else if (state is TransactionActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
            // Reload transactions after successful action
            context.read<TransactionBloc>().add(
                  LoadTransactions(userId: userId),
                );
          }
        },
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TransactionsLoaded) {
            if (state.transactions.isEmpty) {
              return _buildEmptyState(context);
            }

            return _buildTransactionList(context, state.transactions);
          }

          if (state is TransactionError) {
            return _buildErrorState(context, state.message);
          }

          return _buildEmptyState(context);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/transactions/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Transaction'),
      ),
    );
  }

  Widget _buildTransactionList(
    BuildContext context,
    List<Transaction> transactions,
  ) {
    // Group transactions by date
    final groupedTransactions = _groupTransactionsByDate(transactions);

    return ListView.builder(
      itemCount: groupedTransactions.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final date = groupedTransactions.keys.elementAt(index);
        final dayTransactions = groupedTransactions[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(date),
            const SizedBox(height: 8),
            ...dayTransactions.map(
              (transaction) => _buildTransactionItem(context, transaction),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        date,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    final isIncome = transaction.isIncome;
    final isExpense = transaction.isExpense;
    final isTransfer = transaction.isTransfer;

    Color amountColor;
    IconData icon;
    if (isIncome) {
      amountColor = Colors.green;
      icon = Icons.arrow_downward;
    } else if (isExpense) {
      amountColor = Colors.red;
      icon = Icons.arrow_upward;
    } else {
      amountColor = Colors.blue;
      icon = Icons.swap_horiz;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: amountColor.withOpacity(0.1),
          child: Icon(icon, color: amountColor),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          _formatTime(transaction.date),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: Text(
          '${isExpense ? '-' : isIncome ? '+' : ''}\$${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: amountColor,
          ),
        ),
        onTap: () => context.push('/transactions/${transaction.id}'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first transaction to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
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
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading transactions',
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
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.read<TransactionBloc>().add(
                  LoadTransactions(userId: userId),
                ),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Map<String, List<Transaction>> _groupTransactionsByDate(
    List<Transaction> transactions,
  ) {
    final grouped = <String, List<Transaction>>{};

    for (final transaction in transactions) {
      final dateKey = _formatDate(transaction.date);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(transaction);
    }

    return grouped;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return 'Today';
    } else if (transactionDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${_monthName(date.month)} ${date.day}, ${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  void _showSearchDialog(BuildContext context) async {
    final query = await showDialog<String>(
      context: context,
      builder: (context) => const TransactionSearchDialog(),
    );

    if (query != null && query.isNotEmpty && context.mounted) {
      // Dispatch search event to BLoC
      context.read<TransactionBloc>().add(
            SearchTransactions(
              userId: userId,
              query: query,
            ),
          );
    }
  }

  void _showFilterDialog(BuildContext context) async {
    final filters = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const TransactionFilterDialog(),
    );

    if (filters != null && context.mounted) {
      // Dispatch filter event to BLoC
      context.read<TransactionBloc>().add(
            FilterTransactions(
              userId: userId,
              startDate: filters['startDate'] as DateTime?,
              endDate: filters['endDate'] as DateTime?,
              type: filters['type'] as TransactionType?,
              accountId: filters['accountId'] as String?,
              categoryId: filters['categoryId'] as String?,
            ),
          );
    }
  }
}
