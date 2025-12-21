import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../bloc/recurring_transaction_bloc.dart';
import '../bloc/recurring_transaction_event.dart';
import '../bloc/recurring_transaction_state.dart';

/// Recurring transaction list page
///
/// Displays all recurring transactions with options to add, edit, pause, and process.
class RecurringTransactionListPage extends StatelessWidget {
  final String userId;

  const RecurringTransactionListPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RecurringTransactionBloc>()
        ..add(LoadRecurringTransactions(userId: userId, activeOnly: true)),
      child: _RecurringTransactionListView(userId: userId),
    );
  }
}

class _RecurringTransactionListView extends StatefulWidget {
  final String userId;

  const _RecurringTransactionListView({required this.userId});

  @override
  State<_RecurringTransactionListView> createState() =>
      _RecurringTransactionListViewState();
}

class _RecurringTransactionListViewState
    extends State<_RecurringTransactionListView> {
  bool _activeOnly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recurring Transactions'),
        actions: [
          IconButton(
            icon: Icon(_activeOnly ? Icons.filter_alt : Icons.filter_alt_off),
            onPressed: () {
              setState(() {
                _activeOnly = !_activeOnly;
              });
              context.read<RecurringTransactionBloc>().add(
                    LoadRecurringTransactions(
                      userId: widget.userId,
                      activeOnly: _activeOnly,
                    ),
                  );
            },
            tooltip: _activeOnly ? 'Show All' : 'Show Active Only',
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_outline),
            onPressed: () {
              context
                  .read<RecurringTransactionBloc>()
                  .add(const ProcessDueRecurringTransactions());
            },
            tooltip: 'Process Due',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAdd(context),
            tooltip: 'Add Recurring Transaction',
          ),
        ],
      ),
      body: BlocConsumer<RecurringTransactionBloc, RecurringTransactionState>(
        listener: (context, state) {
          if (state is RecurringTransactionActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is TransactionsGenerated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.blue,
                duration: const Duration(seconds: 3),
              ),
            );
            // Refresh the list
            context.read<RecurringTransactionBloc>().add(
                  RefreshRecurringTransactions(
                    userId: widget.userId,
                    activeOnly: _activeOnly,
                  ),
                );
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
          if (state is RecurringTransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RecurringTransactionsLoaded) {
            return _buildList(context, state);
          }

          if (state is RecurringTransactionError) {
            return _buildErrorState(context, state.message);
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, RecurringTransactionsLoaded state) {
    if (state.recurringTransactions.isEmpty) {
      return _buildEmptyList();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<RecurringTransactionBloc>().add(
              RefreshRecurringTransactions(
                userId: widget.userId,
                activeOnly: _activeOnly,
              ),
            );
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.recurringTransactions.length,
        itemBuilder: (context, index) {
          final recurring = state.recurringTransactions[index];
          return _buildRecurringCard(context, recurring);
        },
      ),
    );
  }

  Widget _buildRecurringCard(context, recurring) {
    final typeColor = recurring.type == TransactionType.income
        ? Colors.green
        : Colors.red;
    final nextOccurrence = recurring.getNextOccurrence();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: typeColor.withValues(alpha: 0.2),
          child: Icon(
            recurring.type == TransactionType.income
                ? Icons.arrow_downward
                : Icons.arrow_upward,
            color: typeColor,
          ),
        ),
        title: Text(
          recurring.description,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recurring.frequency.displayName),
            if (nextOccurrence != null)
              Text(
                'Next: ${nextOccurrence.day}/${nextOccurrence.month}/${nextOccurrence.year}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            if (!recurring.isActive)
              const Text(
                'Paused',
                style: TextStyle(color: Colors.orange, fontSize: 12),
              ),
          ],
        ),
        trailing: Text(
          CurrencyFormatter.format(
            amount: recurring.amount,
            currencyCode: recurring.currency,
          ),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: typeColor,
          ),
        ),
        onTap: () => _showActions(context, recurring),
      ),
    );
  }

  void _showActions(context, recurring) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                context.push(
                  '/recurring-transactions/${recurring.id}/edit',
                  extra: recurring,
                );
              },
            ),
            ListTile(
              leading: Icon(recurring.isActive ? Icons.pause : Icons.play_arrow),
              title: Text(recurring.isActive ? 'Pause' : 'Resume'),
              onTap: () {
                Navigator.pop(context);
                context.read<RecurringTransactionBloc>().add(
                      ToggleRecurringTransactionStatus(
                        recurringTransactionId: recurring.id,
                      ),
                    );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, recurring.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recurring Transaction'),
        content: const Text(
          'Are you sure you want to delete this recurring transaction?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<RecurringTransactionBloc>().add(
                    DeleteRecurringTransaction(recurringTransactionId: id),
                  );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyList() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.repeat, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _activeOnly
                  ? 'No Active Recurring Transactions'
                  : 'No Recurring Transactions',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Set up recurring transactions to automate regular income and expenses',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _navigateToAdd(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Recurring Transaction'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text('Error loading recurring transactions',
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.read<RecurringTransactionBloc>().add(
                    LoadRecurringTransactions(
                      userId: widget.userId,
                      activeOnly: _activeOnly,
                    ),
                  ),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(child: Text('Loading...'));
  }

  void _navigateToAdd(BuildContext context) {
    context.push('/recurring-transactions/add');
  }
}
