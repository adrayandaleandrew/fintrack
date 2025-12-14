import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/expense_breakdown.dart';

/// Pie chart widget for expense breakdown by category
///
/// Shows each category's spending as a slice of the pie with percentages.
class ExpenseBreakdownChart extends StatefulWidget {
  final ExpenseBreakdown breakdown;

  const ExpenseBreakdownChart({
    super.key,
    required this.breakdown,
  });

  @override
  State<ExpenseBreakdownChart> createState() => _ExpenseBreakdownChartState();
}

class _ExpenseBreakdownChartState extends State<ExpenseBreakdownChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (!widget.breakdown.hasData) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 50,
              sections: _buildSections(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildLegend(),
      ],
    );
  }

  List<PieChartSectionData> _buildSections() {
    final categoryExpenses = widget.breakdown.categoryExpenses;

    return List.generate(categoryExpenses.length, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 16.0 : 14.0;
      final radius = isTouched ? 110.0 : 100.0;

      final categoryExpense = categoryExpenses[index];
      final color = _parseColor(categoryExpense.categoryColor);

      return PieChartSectionData(
        color: color,
        value: categoryExpense.amount,
        title: '${categoryExpense.percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Widget _buildLegend() {
    final categoryExpenses = widget.breakdown.categoryExpenses;

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: List.generate(categoryExpenses.length, (index) {
        final categoryExpense = categoryExpenses[index];
        final color = _parseColor(categoryExpense.categoryColor);

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${categoryExpense.categoryName} (${CurrencyFormatter.format(amount: categoryExpense.amount, currencyCode: widget.breakdown.currencyCode)})',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      }),
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
              Icons.pie_chart_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No Expense Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'No expenses found for the selected period',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      // Remove '#' if present
      final hexColor = colorString.replaceAll('#', '');
      return Color(int.parse('FF$hexColor', radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }
}
