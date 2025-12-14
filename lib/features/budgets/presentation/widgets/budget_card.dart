import 'package:flutter/material.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/budget.dart';
import '../../domain/entities/budget_usage.dart';
import 'budget_progress_bar.dart';

/// Widget displaying a budget card with progress
///
/// Shows budget details, spending progress, and status indicators.
class BudgetCard extends StatelessWidget {
  final Budget budget;
  final BudgetUsage? usage;
  final VoidCallback? onTap;
  final String categoryName;

  const BudgetCard({
    super.key,
    required this.budget,
    this.usage,
    this.onTap,
    this.categoryName = 'Unknown Category',
  });

  @override
  Widget build(BuildContext context) {
    final percentageUsed = usage?.percentageUsed ?? 0.0;
    final spent = usage?.spent ?? 0.0;
    final remaining = usage?.remaining ?? budget.amount;
    final status = usage?.status ?? BudgetStatus.safe;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with category name and period
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      categoryName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusChip(status),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                budget.period.displayName,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),

              // Progress bar
              BudgetProgressBar(
                percentageUsed: percentageUsed,
                status: status,
              ),
              const SizedBox(height: 12),

              // Amount details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spent',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.format(
                          amount: spent,
                          currencyCode: budget.currency,
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(status),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Budget',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.format(
                          amount: budget.amount,
                          currencyCode: budget.currency,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Remaining amount
              if (remaining > 0)
                Text(
                  '${CurrencyFormatter.format(amount: remaining, currencyCode: budget.currency)} remaining',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                )
              else
                Text(
                  'Over budget by ${CurrencyFormatter.format(amount: remaining.abs(), currencyCode: budget.currency)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build status chip
  Widget _buildStatusChip(BudgetStatus status) {
    final color = _getStatusColor(status);
    final text = usage?.statusMessage ?? 'No data';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  /// Get color based on status
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
}
