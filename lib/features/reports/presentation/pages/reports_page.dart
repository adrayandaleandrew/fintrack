import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/reports_bloc.dart';
import '../bloc/reports_event.dart';
import '../bloc/reports_state.dart';
import '../widgets/expense_breakdown_chart.dart';
import '../widgets/financial_trends_chart.dart';
import '../widgets/monthly_comparison_chart.dart';

/// Reports page with tabbed interface for different chart types
///
/// Displays expense breakdown (pie chart), financial trends (line chart),
/// and monthly comparison (bar chart).
class ReportsPage extends StatelessWidget {
  final String userId;

  const ReportsPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ReportsBloc>(),
      child: _ReportsPageView(userId: userId),
    );
  }
}

class _ReportsPageView extends StatefulWidget {
  final String userId;

  const _ReportsPageView({required this.userId});

  @override
  State<_ReportsPageView> createState() => _ReportsPageViewState();
}

class _ReportsPageViewState extends State<_ReportsPageView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Set default date range (last 30 days)
    _endDate = DateTime.now();
    _startDate = _endDate!.subtract(const Duration(days: 30));

    // Load initial report
    _loadExpenseBreakdown();

    // Listen to tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _onTabChanged(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    switch (index) {
      case 0:
        _loadExpenseBreakdown();
        break;
      case 1:
        _loadFinancialTrends();
        break;
      case 2:
        _loadMonthlyComparison();
        break;
    }
  }

  void _loadExpenseBreakdown() {
    context.read<ReportsBloc>().add(
          LoadExpenseBreakdown(
            userId: widget.userId,
            startDate: _startDate!,
            endDate: _endDate!,
          ),
        );
  }

  void _loadFinancialTrends() {
    context.read<ReportsBloc>().add(
          LoadFinancialTrends(
            userId: widget.userId,
            startDate: _startDate!,
            endDate: _endDate!,
            groupBy: 'month',
          ),
        );
  }

  void _loadMonthlyComparison() {
    context.read<ReportsBloc>().add(
          LoadMonthlyComparison(
            userId: widget.userId,
            monthCount: 6,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Breakdown', icon: Icon(Icons.pie_chart)),
            Tab(text: 'Trends', icon: Icon(Icons.show_chart)),
            Tab(text: 'Comparison', icon: Icon(Icons.bar_chart)),
          ],
        ),
      ),
      body: BlocConsumer<ReportsBloc, ReportsState>(
        listener: (context, state) {
          if (state is ReportsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildExpenseBreakdownTab(state),
              _buildFinancialTrendsTab(state),
              _buildMonthlyComparisonTab(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildExpenseBreakdownTab(ReportsState state) {
    if (state is ReportsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ExpenseBreakdownLoaded) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateRangeSelector(),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Expense Breakdown by Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ExpenseBreakdownChart(breakdown: state.breakdown),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildExpenseBreakdownSummary(state),
          ],
        ),
      );
    }

    return _buildEmptyState('No expense breakdown data available');
  }

  Widget _buildFinancialTrendsTab(ReportsState state) {
    if (state is ReportsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is FinancialTrendsLoaded) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateRangeSelector(),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Income vs Expense Trends',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FinancialTrendsChart(trends: state.trends),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildTrendsSummary(state),
          ],
        ),
      );
    }

    return _buildEmptyState('No trends data available');
  }

  Widget _buildMonthlyComparisonTab(ReportsState state) {
    if (state is ReportsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is MonthlyComparisonLoaded) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monthly Comparison (Last 6 Months)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    MonthlyComparisonChart(comparison: state.comparison),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildComparisonSummary(state),
          ],
        ),
      );
    }

    return _buildEmptyState('No comparison data available');
  }

  Widget _buildDateRangeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.date_range, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Date Range: ${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            TextButton(
              onPressed: _showDateRangePicker,
              child: const Text('Change'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseBreakdownSummary(ExpenseBreakdownLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Total Expenses',
              '\$${state.breakdown.totalExpense.toStringAsFixed(2)}',
            ),
            _buildSummaryRow(
              'Categories',
              state.breakdown.categoryCount.toString(),
            ),
            _buildSummaryRow(
              'Transactions',
              state.breakdown.totalTransactionCount.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsSummary(FinancialTrendsLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Total Income',
              '\$${state.trends.totalIncome.toStringAsFixed(2)}',
            ),
            _buildSummaryRow(
              'Total Expense',
              '\$${state.trends.totalExpense.toStringAsFixed(2)}',
            ),
            _buildSummaryRow(
              'Net',
              '\$${state.trends.totalNet.toStringAsFixed(2)}',
              valueColor: state.trends.totalNet >= 0 ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonSummary(MonthlyComparisonLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Average Income',
              '\$${state.comparison.averageIncome.toStringAsFixed(2)}',
            ),
            _buildSummaryRow(
              'Average Expense',
              '\$${state.comparison.averageExpense.toStringAsFixed(2)}',
            ),
            _buildSummaryRow(
              'Surplus Months',
              '${state.comparison.surplusMonthsCount} / ${state.comparison.months.length}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate!, end: _endDate!),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _onTabChanged(_tabController.index);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
