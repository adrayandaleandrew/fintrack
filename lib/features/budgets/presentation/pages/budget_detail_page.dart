import 'package:flutter/material.dart';

/// Budget detail page placeholder
///
/// Full implementation will be added with Phase 8 (Reports & Analytics)
/// where charts and detailed spending breakdown will be displayed.
class BudgetDetailPage extends StatelessWidget {
  final String budgetId;

  const BudgetDetailPage({
    super.key,
    required this.budgetId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.construction,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              const Text(
                'Budget Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Detailed budget view with spending breakdown and charts will be implemented in Phase 8 (Reports & Analytics).',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'Budget ID: $budgetId',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
