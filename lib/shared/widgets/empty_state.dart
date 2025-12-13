import 'package:flutter/material.dart';
import 'custom_button.dart';

/// Empty state widget
///
/// Displays a message when there's no data to show.
/// Use this for empty lists, search results, etc.
class EmptyState extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Title text
  final String title;

  /// Description text
  final String description;

  /// Action button text
  final String? actionText;

  /// Action button callback
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionText,
    this.onAction,
  });

  /// Empty transactions state
  factory EmptyState.transactions({
    Key? key,
    VoidCallback? onAddTransaction,
  }) {
    return EmptyState(
      key: key,
      icon: Icons.receipt_long,
      title: 'No Transactions Yet',
      description: 'Start tracking your finances by adding your first transaction.',
      actionText: 'Add Transaction',
      onAction: onAddTransaction,
    );
  }

  /// Empty accounts state
  factory EmptyState.accounts({
    Key? key,
    VoidCallback? onAddAccount,
  }) {
    return EmptyState(
      key: key,
      icon: Icons.account_balance_wallet,
      title: 'No Accounts Yet',
      description: 'Create an account to start managing your finances.',
      actionText: 'Add Account',
      onAction: onAddAccount,
    );
  }

  /// Empty budgets state
  factory EmptyState.budgets({
    Key? key,
    VoidCallback? onAddBudget,
  }) {
    return EmptyState(
      key: key,
      icon: Icons.pie_chart,
      title: 'No Budgets Yet',
      description: 'Set up budgets to track your spending and stay on target.',
      actionText: 'Create Budget',
      onAction: onAddBudget,
    );
  }

  /// Empty recurring transactions state
  factory EmptyState.recurringTransactions({
    Key? key,
    VoidCallback? onAddRecurring,
  }) {
    return EmptyState(
      key: key,
      icon: Icons.repeat,
      title: 'No Recurring Transactions',
      description: 'Automate your regular income and expenses.',
      actionText: 'Add Recurring Transaction',
      onAction: onAddRecurring,
    );
  }

  /// Empty categories state
  factory EmptyState.categories({
    Key? key,
    VoidCallback? onAddCategory,
  }) {
    return EmptyState(
      key: key,
      icon: Icons.category,
      title: 'No Categories Yet',
      description: 'Create categories to organize your transactions.',
      actionText: 'Add Category',
      onAction: onAddCategory,
    );
  }

  /// Empty search results
  factory EmptyState.searchResults({
    Key? key,
    String? query,
  }) {
    return EmptyState(
      key: key,
      icon: Icons.search_off,
      title: 'No Results Found',
      description: query != null
          ? 'No results found for "$query". Try a different search term.'
          : 'No results found. Try a different search term.',
    );
  }

  /// Empty filtered results
  factory EmptyState.filteredResults({
    Key? key,
    VoidCallback? onClearFilters,
  }) {
    return EmptyState(
      key: key,
      icon: Icons.filter_list_off,
      title: 'No Matching Results',
      description: 'No items match your current filters.',
      actionText: 'Clear Filters',
      onAction: onClearFilters,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 100,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 32),
              CustomButton.primary(
                text: actionText!,
                onPressed: onAction,
                icon: Icons.add,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Compact empty state widget
///
/// Displays a smaller empty state for use in smaller containers.
class CompactEmptyState extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Message text
  final String message;

  const CompactEmptyState({
    super.key,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
