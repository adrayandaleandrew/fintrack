import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/financial_trends.dart';

/// Line chart widget for financial trends over time
///
/// Shows income and expense trends as separate lines.
class FinancialTrendsChart extends StatelessWidget {
  final FinancialTrends trends;

  const FinancialTrendsChart({
    super.key,
    required this.trends,
  });

  @override
  Widget build(BuildContext context) {
    if (!trends.hasData) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: _calculateHorizontalInterval(),
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withValues(alpha: 0.2),
                    strokeWidth: 1,
                  );
                },
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
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= trends.dataPoints.length) {
                        return const Text('');
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          trends.dataPoints[index].shortLabel,
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
                    interval: _calculateHorizontalInterval(),
                    getTitlesWidget: (value, meta) {
                      return Text(
                        CurrencyFormatter.formatCompactNumber(value),
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
              minX: 0,
              maxX: (trends.dataPoints.length - 1).toDouble(),
              minY: 0,
              maxY: _calculateMaxY(),
              lineBarsData: [
                _buildIncomeLine(),
                _buildExpenseLine(),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final isIncome = spot.barIndex == 0;
                      final label = isIncome ? 'Income' : 'Expense';
                      return LineTooltipItem(
                        '$label\n${CurrencyFormatter.format(amount: spot.y, currencyCode: trends.currencyCode)}',
                        TextStyle(
                          color: isIncome ? Colors.white : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildLegend(),
      ],
    );
  }

  LineChartBarData _buildIncomeLine() {
    return LineChartBarData(
      spots: List.generate(
        trends.dataPoints.length,
        (index) => FlSpot(
          index.toDouble(),
          trends.dataPoints[index].income,
        ),
      ),
      isCurved: true,
      color: Colors.green,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: Colors.green,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        color: Colors.green.withValues(alpha: 0.1),
      ),
    );
  }

  LineChartBarData _buildExpenseLine() {
    return LineChartBarData(
      spots: List.generate(
        trends.dataPoints.length,
        (index) => FlSpot(
          index.toDouble(),
          trends.dataPoints[index].expense,
        ),
      ),
      isCurved: true,
      color: Colors.red,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: Colors.red,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        color: Colors.red.withValues(alpha: 0.1),
      ),
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
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
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
              Icons.show_chart,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No Trend Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'No transactions found for the selected period',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  double _calculateMaxY() {
    if (trends.dataPoints.isEmpty) return 100;

    final maxIncome = trends.dataPoints
        .map((p) => p.income)
        .reduce((a, b) => a > b ? a : b);
    final maxExpense = trends.dataPoints
        .map((p) => p.expense)
        .reduce((a, b) => a > b ? a : b);

    final max = maxIncome > maxExpense ? maxIncome : maxExpense;
    // Add 20% padding to the top
    return max * 1.2;
  }

  double _calculateHorizontalInterval() {
    final maxY = _calculateMaxY();
    // Aim for about 5 horizontal lines
    return (maxY / 5).ceilToDouble();
  }
}
