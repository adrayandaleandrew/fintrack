import 'package:flutter/material.dart';
import '../../domain/entities/budget_usage.dart';

/// Widget displaying budget progress as a colored bar
///
/// Shows spending progress with color coding based on status.
class BudgetProgressBar extends StatelessWidget {
  final double percentageUsed;
  final BudgetStatus status;
  final double height;

  const BudgetProgressBar({
    super.key,
    required this.percentageUsed,
    required this.status,
    this.height = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    // Cap at 100% for display purposes
    final displayPercentage = percentageUsed.clamp(0.0, 100.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar
        Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: LinearProgressIndicator(
              value: displayPercentage / 100,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(_getColor()),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Percentage text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${percentageUsed.toStringAsFixed(1)}% used',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _getColor(),
              ),
            ),
            if (percentageUsed > 100)
              const Icon(
                Icons.warning_amber_rounded,
                size: 20,
                color: Colors.red,
              ),
          ],
        ),
      ],
    );
  }

  /// Get color based on status
  Color _getColor() {
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
