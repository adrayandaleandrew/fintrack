import 'package:flutter/material.dart';
import '../../domain/entities/budget.dart';

/// Widget for selecting budget period
///
/// Displays period options in a segmented button style.
class BudgetPeriodSelector extends StatelessWidget {
  final BudgetPeriod selectedPeriod;
  final ValueChanged<BudgetPeriod> onPeriodChanged;

  const BudgetPeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Budget Period',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: BudgetPeriod.values.map((period) {
            final isSelected = period == selectedPeriod;
            return ChoiceChip(
              label: Text(period.displayName),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onPeriodChanged(period);
                }
              },
              selectedColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
