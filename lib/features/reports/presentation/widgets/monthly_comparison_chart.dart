import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/monthly_comparison.dart';

/// Bar chart widget for monthly comparison
///
/// Shows income and expense for each month as grouped bars.
class MonthlyComparisonChart extends StatelessWidget {
  final MonthlyComparison comparison;

  const MonthlyComparisonChart({
    super.key,
    required this.comparison,
  });

  @override
  Widget build(BuildContext context) {
    if (!comparison.hasData) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _calculateMaxY(),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final month = comparison.months[groupIndex];
                    final isIncome = rodIndex == 0;
                    final label = isIncome ? 'Income' : 'Expense';
                    final amount = isIncome ? month.income : month.expense;

                    return BarTooltipItem(
                      '${month.shortMonthName}\n$label\n${CurrencyFormatter.format(amount: amount, currencyCode: comparison.currencyCode)}',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= comparison.months.length) {
                        return const Text('');
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          comparison.months[index].shortMonthName,
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    interval: _calculateVerticalInterval(),
                    getTitlesWidget: (value, meta) {
                      return Text(
                        CurrencyFormatter.formatCompact(value),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.2),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: _calculateVerticalInterval(),
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withValues(alpha: 0.2),
                    strokeWidth: 1,
                  );
                },
              ),
              barGroups: _buildBarGroups(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildLegend(),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(
      comparison.months.length,
      (index) {
        final month = comparison.months[index];

        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: month.income,
              color: Colors.green,
              width: 12,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            BarChartRodData(
              toY: month.expense,
              color: Colors.red,
              width: 12,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Income', Colors.green),
        const SizedBox(width: 24),
        _buildLegendItem('Expense', Colors.red),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No Comparison Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'No transactions found for comparison',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  double _calculateMaxY() {
    if (comparison.months.isEmpty) return 100;

    final maxIncome = comparison.months
        .map((m) => m.income)
        .reduce((a, b) => a > b ? a : b);
    final maxExpense = comparison.months
        .map((m) => m.expense)
        .reduce((a, b) => a > b ? a : b);

    final max = maxIncome > maxExpense ? maxIncome : maxExpense;
    // Add 20% padding to the top
    return max * 1.2;
  }

  double _calculateVerticalInterval() {
    final maxY = _calculateMaxY();
    // Aim for about 5 horizontal lines
    return (maxY / 5).ceilToDouble();
  }
}
