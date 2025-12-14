import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../categories/presentation/bloc/category_bloc.dart';
import '../../../categories/presentation/bloc/category_event.dart';
import '../../../categories/presentation/bloc/category_state.dart';
import '../bloc/budget_bloc.dart';
import '../bloc/budget_event.dart';
import '../bloc/budget_state.dart';
import '../widgets/budget_card.dart';

/// Budget list page showing all budgets with usage
///
/// Displays budgets with progress bars, filtering options,
/// and navigation to add/edit budgets.
class BudgetListPage extends StatelessWidget {
  final String userId;

  const BudgetListPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<BudgetBloc>()
            ..add(LoadBudgets(userId: userId, activeOnly: true)),
        ),
        BlocProvider(
          create: (_) => sl<CategoryBloc>()
            ..add(LoadCategories(userId: userId)),
        ),
      ],
      child: const _BudgetListView(),
    );
  }
}

class _BudgetListView extends StatefulWidget {
  const _BudgetListView();

  @override
  State<_BudgetListView> createState() => _BudgetListViewState();
}

class _BudgetListViewState extends State<_BudgetListView> {
  bool _activeOnly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          // Filter toggle
          IconButton(
            icon: Icon(_activeOnly ? Icons.filter_alt : Icons.filter_alt_off),
            onPressed: () {
              setState(() {
                _activeOnly = !_activeOnly;
              });
              final userId = (context.read<BudgetBloc>().state is BudgetsLoaded)
                  ? 'user_1' // TODO: Get from auth
                  : 'user_1';
              context.read<BudgetBloc>().add(
                    LoadBudgets(userId: userId, activeOnly: _activeOnly),
                  );
            },
            tooltip: _activeOnly ? 'Show All' : 'Show Active Only',
          ),
          // Add budget button
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddBudget(context),
            tooltip: 'Add Budget',
          ),
        ],
      ),
      body: BlocConsumer<BudgetBloc, BudgetState>(
        listener: (context, state) {
          if (state is BudgetActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is BudgetError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BudgetLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BudgetsLoaded) {
            return _buildBudgetList(context, state);
          }

          if (state is BudgetError) {
            return _buildErrorState(context, state.message);
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildBudgetList(BuildContext context, BudgetsLoaded state) {
    if (state.budgets.isEmpty) {
      return _buildEmptyBudgetsList();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<BudgetBloc>().add(
              RefreshBudgets(userId: 'user_1', activeOnly: _activeOnly),
            );
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: Column(
        children: [
          // Summary card
          if (state.alertBudgets.isNotEmpty) _buildAlertBanner(state),

          // Budget list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.budgets.length,
              itemBuilder: (context, index) {
                final budget = state.budgets[index];
                final usage = state.getUsage(budget.id);

                return BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, categoryState) {
                    String categoryName = 'Unknown Category';
                    if (categoryState is CategoriesLoaded) {
                      final category = categoryState.categories
                          .where((c) => c.id == budget.categoryId)
                          .firstOrNull;
                      categoryName = category?.name ?? 'Unknown Category';
                    }

                    return BudgetCard(
                      budget: budget,
                      usage: usage,
                      categoryName: categoryName,
                      onTap: () => _navigateToBudgetDetail(context, budget.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertBanner(BudgetsLoaded state) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Budget Alerts',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.alertBudgets.length} ${state.alertBudgets.length == 1 ? 'budget is' : 'budgets are'} approaching or over limit',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyBudgetsList() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _activeOnly ? 'No Active Budgets' : 'No Budgets',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _activeOnly
                  ? 'Create a budget to start tracking your spending'
                  : 'You have no budgets yet',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _navigateToAddBudget(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Budget'),
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
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading budgets',
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
              onPressed: () => context.read<BudgetBloc>().add(
                    LoadBudgets(userId: 'user_1', activeOnly: _activeOnly),
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
    return const Center(
      child: Text('Loading budgets...'),
    );
  }

  void _navigateToAddBudget(BuildContext context) {
    Navigator.of(context).pushNamed('/budgets/add');
  }

  void _navigateToBudgetDetail(BuildContext context, String budgetId) {
    Navigator.of(context).pushNamed('/budgets/$budgetId');
  }
}
