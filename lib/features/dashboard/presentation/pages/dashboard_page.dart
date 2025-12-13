import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/dashboard_summary.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/balance_summary_card.dart';
import '../widgets/income_expense_summary_card.dart';
import '../widgets/quick_actions_widget.dart';
import '../widgets/recent_transactions_widget.dart';

/// Dashboard page showing financial overview
///
/// Displays:
/// - Total balance across all accounts
/// - Month-to-date income and expenses
/// - Recent transactions
/// - Quick action buttons
class DashboardPage extends StatelessWidget {
  final String userId;

  const DashboardPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardBloc>()
        ..add(LoadDashboardSummary(userId: userId)),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DashboardBloc>().add(
                    const RefreshDashboard(userId: 'user_1'),
                  );
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardLoaded) {
            return _buildDashboardContent(context, state);
          }

          if (state is DashboardError) {
            return _buildErrorState(context, state.message);
          }

          return _buildEmptyState();
        },
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, DashboardLoaded state) {
    final summary = state.summary;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(
              const RefreshDashboard(userId: 'user_1'),
            );
        // Wait a bit for the refresh to complete
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Total Balance Card
          BalanceSummaryCard(
            totalBalance: summary.totalBalance,
            accountCount: summary.accountCount,
          ),
          const SizedBox(height: 16),

          // Income/Expense Summary Card
          IncomeExpenseSummaryCard(
            income: summary.monthToDateIncome,
            expense: summary.monthToDateExpense,
            netChange: summary.netChange,
          ),
          const SizedBox(height: 16),

          // Quick Actions
          QuickActionsWidget(
            onAddTransaction: () => _navigateToAddTransaction(context),
            onAddAccount: () => _navigateToAddAccount(context),
            onViewAccounts: () => _navigateToAccounts(context),
            onViewTransactions: () => _navigateToTransactions(context),
          ),
          const SizedBox(height: 16),

          // Recent Transactions
          RecentTransactionsWidget(
            transactions: summary.recentTransactions,
            onViewAll: () => _navigateToTransactions(context),
          ),
          const SizedBox(height: 16),

          // Stats Overview
          if (summary.hasTransactions) _buildStatsCard(summary),
        ],
      ),
    );
  }

  Widget _buildStatsCard(DashboardSummary summary) {
    final savingsRate = summary.savingsRate;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              'Total Accounts',
              '${summary.accountCount}',
              Icons.account_balance_wallet,
            ),
            const SizedBox(height: 12),
            _buildStatRow(
              'Total Transactions',
              '${summary.transactionCount}',
              Icons.receipt_long,
            ),
            const SizedBox(height: 12),
            _buildStatRow(
              'Savings Rate',
              '${savingsRate.toStringAsFixed(1)}%',
              Icons.savings,
              valueColor: savingsRate >= 0 ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
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
              'Error loading dashboard',
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
              onPressed: () => context.read<DashboardBloc>().add(
                    const LoadDashboardSummary(userId: 'user_1'),
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
      child: Text('Loading dashboard...'),
    );
  }

  void _navigateToAddTransaction(BuildContext context) {
    Navigator.of(context).pushNamed('/transactions/add');
  }

  void _navigateToAddAccount(BuildContext context) {
    Navigator.of(context).pushNamed('/accounts/add');
  }

  void _navigateToAccounts(BuildContext context) {
    Navigator.of(context).pushNamed('/accounts');
  }

  void _navigateToTransactions(BuildContext context) {
    Navigator.of(context).pushNamed('/transactions');
  }
}
