import 'package:finance_tracker/shared/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmptyState', () {
    testWidgets('renders with icon, title, and description',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.inbox,
              title: 'No Items',
              description: 'Add items to get started',
            ),
          ),
        ),
      );

      expect(find.text('No Items'), findsOneWidget);
      expect(find.text('Add items to get started'), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });

    testWidgets('shows action button when provided',
        (WidgetTester tester) async {
      var actionCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.inbox,
              title: 'No Items',
              description: 'Add items to get started',
              actionText: 'Add Item',
              onAction: () => actionCalled = true,
            ),
          ),
        ),
      );

      expect(find.text('Add Item'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(find.text('Add Item'));
      expect(actionCalled, true);
    });

    testWidgets('does not show action button when not provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.inbox,
              title: 'No Items',
              description: 'Add items to get started',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsNothing);
    });

    group('Factory constructors', () {
      testWidgets('transactions factory creates transactions empty state',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EmptyState.transactions(
                onAddTransaction: () {},
              ),
            ),
          ),
        );

        expect(find.text('No Transactions Yet'), findsOneWidget);
        expect(
            find.text(
                'Start tracking your finances by adding your first transaction.'),
            findsOneWidget);
        expect(find.byIcon(Icons.receipt_long), findsOneWidget);
        expect(find.text('Add Transaction'), findsOneWidget);
      });

      testWidgets('accounts factory creates accounts empty state',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EmptyState.accounts(
                onAddAccount: () {},
              ),
            ),
          ),
        );

        expect(find.text('No Accounts Yet'), findsOneWidget);
        expect(
            find.text('Create an account to start managing your finances.'),
            findsOneWidget);
        expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
        expect(find.text('Add Account'), findsOneWidget);
      });

      testWidgets('budgets factory creates budgets empty state',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EmptyState.budgets(
                onAddBudget: () {},
              ),
            ),
          ),
        );

        expect(find.text('No Budgets Yet'), findsOneWidget);
        expect(
            find.text(
                'Set up budgets to track your spending and stay on target.'),
            findsOneWidget);
        expect(find.byIcon(Icons.pie_chart), findsOneWidget);
        expect(find.text('Create Budget'), findsOneWidget);
      });

      testWidgets(
          'recurringTransactions factory creates recurring transactions empty state',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EmptyState.recurringTransactions(
                onAddRecurring: () {},
              ),
            ),
          ),
        );

        expect(find.text('No Recurring Transactions'), findsOneWidget);
        expect(find.text('Automate your regular income and expenses.'),
            findsOneWidget);
        expect(find.byIcon(Icons.repeat), findsOneWidget);
        expect(find.text('Add Recurring Transaction'), findsOneWidget);
      });

      testWidgets('categories factory creates categories empty state',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EmptyState.categories(
                onAddCategory: () {},
              ),
            ),
          ),
        );

        expect(find.text('No Categories Yet'), findsOneWidget);
        expect(find.text('Create categories to organize your transactions.'),
            findsOneWidget);
        expect(find.byIcon(Icons.category), findsOneWidget);
        expect(find.text('Add Category'), findsOneWidget);
      });

      testWidgets('searchResults factory creates search results empty state',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EmptyState.searchResults(
                query: 'test query',
              ),
            ),
          ),
        );

        expect(find.text('No Results Found'), findsOneWidget);
        expect(
            find.text(
                'No results found for "test query". Try a different search term.'),
            findsOneWidget);
        expect(find.byIcon(Icons.search_off), findsOneWidget);
      });

      testWidgets('searchResults factory without query',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EmptyState.searchResults(),
            ),
          ),
        );

        expect(find.text('No results found. Try a different search term.'),
            findsOneWidget);
      });

      testWidgets('filteredResults factory creates filtered results empty state',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EmptyState.filteredResults(
                onClearFilters: () {},
              ),
            ),
          ),
        );

        expect(find.text('No Matching Results'), findsOneWidget);
        expect(find.text('No items match your current filters.'),
            findsOneWidget);
        expect(find.byIcon(Icons.filter_list_off), findsOneWidget);
        expect(find.text('Clear Filters'), findsOneWidget);
      });
    });
  });

  group('CompactEmptyState', () {
    testWidgets('renders with icon and message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CompactEmptyState(
              icon: Icons.inbox,
              message: 'No items available',
            ),
          ),
        ),
      );

      expect(find.text('No items available'), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });

    testWidgets('renders smaller than regular EmptyState',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CompactEmptyState(
              icon: Icons.inbox,
              message: 'Test',
            ),
          ),
        ),
      );

      final icon =
          tester.widget<Icon>(find.byIcon(Icons.inbox));
      expect(icon.size, 48);
    });
  });
}
