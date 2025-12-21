import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/bloc/category_bloc.dart';
import '../../../categories/presentation/bloc/category_event.dart';
import '../../../categories/presentation/bloc/category_state.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/presentation/bloc/transaction_bloc.dart';
import '../../../transactions/presentation/bloc/transaction_event.dart';
import '../../../transactions/presentation/bloc/transaction_state.dart';
import '../../../transactions/presentation/widgets/transaction_list_item.dart';
import '../../domain/entities/budget.dart';
import '../../domain/entities/budget_usage.dart';
import '../bloc/budget_bloc.dart';
import '../bloc/budget_event.dart';
import '../bloc/budget_state.dart';
import '../widgets/budget_progress_bar.dart';

/// Budget detail page showing comprehensive budget information
///
/// Features:
/// - Budget overview with category, amount, and period
/// - Spending progress visualization
/// - Budget usage statistics
/// - List of transactions contributing to budget
/// - Edit and delete actions
class BudgetDetailPage extends StatelessWidget {
  final String budgetId;
  final String userId;

  const BudgetDetailPage({
    super.key,
    required this.budgetId,
    this.userId = 'user_1', // TODO: Get from auth
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<BudgetBloc>()..add(LoadBudgets(userId: userId)),
        ),
        BlocProvider(
          create: (_) => sl<CategoryBloc>()
            ..add(LoadCategories(userId: userId)),
        ),
        BlocProvider(
          create: (_) => sl<TransactionBloc>(),
        ),
      ],
      child: _BudgetDetailView(budgetId: budgetId, userId: userId),
    );
  }
}

class _BudgetDetailView extends StatelessWidget {
  final String budgetId;
  final String userId;

  const _BudgetDetailView({
    required this.budgetId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BudgetBloc, BudgetState>(
      listener: (context, state) {
        if (state is BudgetActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
          // Navigate back after delete
          if (state.message.contains('deleted')) {
            context.pop();
          }
        } else if (state is BudgetError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, budgetState) {
        if (budgetState is BudgetLoading) {
          return Scaffold(
            appBar: AppBar(title: const Text('Budget Details')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (budgetState is BudgetsLoaded) {
          final budget = budgetState.budgets.firstWhere(
            (b) => b.id == budgetId,
            orElse: () => throw Exception('Budget not found'),
          );

          final usage = budgetState.getUsage(budgetId);

          return Scaffold(
            appBar: AppBar(
              title: const Text('Budget Details'),
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _navigateToEdit(context, budget);
                    } else if (value == 'delete') {
                      _confirmDelete(context, budgetId);
                    }
                  },
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
                ),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<BudgetBloc>().add(
                      RefreshBudgets(userId: userId),
                    );
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Category Name Card
                  _buildCategoryCard(context, budget),
                  const SizedBox(height: 16),

                  // Budget Overview Card
                  _buildOverviewCard(context, budget, usage),
                  const SizedBox(height: 16),

                  // Progress Card
                  if (usage != null) ...[
                    _buildProgressCard(context, budget, usage),
                    const SizedBox(height: 16),
                  ],

                  // Budget Info Card
                  _buildInfoCard(context, budget),
                  const SizedBox(height: 16),

                  // Transactions List
                  _buildTransactionsSection(context, budget),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Budget Details')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('Budget not found'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, Budget budget) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoriesLoaded) {
          final category = state.categories.firstWhere(
            (c) => c.id == budget.categoryId,
            orElse: () => Category(
              id: budget.categoryId,
              userId: userId,
              name: 'Unknown Category',
              type: CategoryType.expense,
              icon: 'category',
              color: '#808080',
              sortOrder: 0,
              isDefault: false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _parseColor(category.color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(category.icon),
                      color: _parseColor(category.color),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${budget.period.displayName} Budget',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
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
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildOverviewCard(
      BuildContext context, Budget budget, BudgetUsage? usage) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Budget Amount',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              CurrencyFormatter.format(
                amount: budget.amount,
                currencyCode: budget.currency,
              ),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (usage != null) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatColumn(
                    'Spent',
                    CurrencyFormatter.format(
                      amount: usage.spent,
                      currencyCode: budget.currency,
                    ),
                    usage.isOverBudget ? Colors.red : Colors.orange,
                  ),
                  _buildStatColumn(
                    'Remaining',
                    CurrencyFormatter.format(
                      amount: usage.remaining,
                      currencyCode: budget.currency,
                    ),
                    usage.remaining >= 0 ? Colors.green : Colors.red,
                  ),
                  _buildStatColumn(
                    'Days Left',
                    '${usage.daysRemaining}',
                    Colors.blue,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressCard(
      BuildContext context, Budget budget, BudgetUsage usage) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Spending Progress',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(usage.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    usage.statusMessage,
                    style: TextStyle(
                      fontSize: 12,
                      color: _getStatusColor(usage.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BudgetProgressBar(
              percentageUsed: usage.percentageUsed,
              status: usage.status,
              height: 12,
            ),
            if (usage.shouldAlert && !usage.isOverBudget) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You\'re approaching your budget limit (${budget.alertThreshold.toInt()}% threshold)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orange[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (usage.isOverBudget) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Budget exceeded by ${CurrencyFormatter.format(amount: usage.spent - budget.amount, currencyCode: budget.currency)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, Budget budget) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Budget Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Period', budget.period.displayName),
            const Divider(),
            _buildInfoRow(
              'Start Date',
              '${budget.startDate.day}/${budget.startDate.month}/${budget.startDate.year}',
            ),
            if (budget.endDate != null) ...[
              const Divider(),
              _buildInfoRow(
                'End Date',
                '${budget.endDate!.day}/${budget.endDate!.month}/${budget.endDate!.year}',
              ),
            ],
            const Divider(),
            _buildInfoRow(
              'Alert Threshold',
              '${budget.alertThreshold.toInt()}%',
            ),
            const Divider(),
            _buildInfoRow(
              'Status',
              budget.isActive ? 'Active' : 'Inactive',
              valueColor: budget.isActive ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsSection(BuildContext context, Budget budget) {
    // Load transactions filtered by category and current period
    context.read<TransactionBloc>().add(
          FilterTransactions(
            userId: userId,
            filters: {
              'categoryId': budget.categoryId,
              // Add date range based on budget period
            },
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Related Transactions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is TransactionsLoaded) {
              // Filter transactions by category
              final categoryTransactions = state.transactions
                  .where((t) => t.categoryId == budget.categoryId)
                  .toList();

              if (categoryTransactions.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No transactions yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Card(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  itemCount: categoryTransactions.length > 10
                      ? 10
                      : categoryTransactions.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final transaction = categoryTransactions[index];
                    return TransactionListItem(
                      transaction: transaction,
                      onTap: () => _navigateToTransactionDetail(
                        context,
                        transaction.id,
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
        if (BlocProvider.of<TransactionBloc>(context).state
            is TransactionsLoaded) ...[
          final state = BlocProvider.of<TransactionBloc>(context).state
              as TransactionsLoaded;
          final categoryTransactions =
              state.transactions.where((t) => t.categoryId == budget.categoryId);
          if (categoryTransactions.length > 10)
            TextButton(
              onPressed: () {
                // Navigate to transactions page with category filter
                context.push('/transactions');
              },
              child: const Text('View All Transactions'),
            ),
        ],
      ],
    );
  }

  Color _getStatusColor(BudgetStatus status) {
    switch (status) {
      case BudgetStatus.safe:
        return Colors.green;
      case BudgetStatus.onTrack:
        return Colors.blue;
      case BudgetStatus.nearLimit:
        return Colors.orange;
      case BudgetStatus.overBudget:
        return Colors.red;
    }
  }

  IconData _getCategoryIcon(String iconName) {
    const iconMap = {
      'work': Icons.work,
      'computer': Icons.computer,
      'business_center': Icons.business_center,
      'trending_up': Icons.trending_up,
      'home': Icons.home,
      'card_giftcard': Icons.card_giftcard,
      'star': Icons.star,
      'receipt': Icons.receipt,
      'restaurant': Icons.restaurant,
      'shopping_cart': Icons.shopping_cart,
      'directions_car': Icons.directions_car,
      'shopping_bag': Icons.shopping_bag,
      'movie': Icons.movie,
      'receipt_long': Icons.receipt_long,
      'local_hospital': Icons.local_hospital,
      'school': Icons.school,
      'flight': Icons.flight,
      'spa': Icons.spa,
      'security': Icons.security,
      'subscriptions': Icons.subscriptions,
    };

    return iconMap[iconName] ?? Icons.category;
  }

  Color _parseColor(String colorHex) {
    try {
      final hex = colorHex.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (e) {
      // Return grey if parsing fails
    }
    return Colors.grey;
  }

  void _navigateToEdit(BuildContext context, Budget budget) {
    context.push('/budgets/edit', extra: budget);
  }

  void _navigateToTransactionDetail(BuildContext context, String transactionId) {
    context.push('/transactions/$transactionId');
  }

  void _confirmDelete(BuildContext context, String budgetId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Budget'),
        content: const Text(
          'Are you sure you want to delete this budget? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<BudgetBloc>().add(DeleteBudget(budgetId: budgetId));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
