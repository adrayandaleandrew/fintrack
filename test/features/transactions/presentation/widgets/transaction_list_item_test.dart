import 'package:finance_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:finance_tracker/features/transactions/presentation/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionListItem', () {
    late Transaction incomeTransaction;
    late Transaction expenseTransaction;
    late Transaction transferTransaction;

    setUp(() {
      incomeTransaction = Transaction(
        id: '1',
        userId: 'user_1',
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.income,
        amount: 1000.0,
        currency: 'USD',
        description: 'Monthly Salary',
        date: DateTime(2025, 12, 19, 10, 30),
        createdAt: DateTime(2025, 12, 19),
        updatedAt: DateTime(2025, 12, 19),
      );

      expenseTransaction = Transaction(
        id: '2',
        userId: 'user_1',
        accountId: 'acc_1',
        categoryId: 'cat_2',
        type: TransactionType.expense,
        amount: 50.0,
        currency: 'USD',
        description: 'Groceries',
        date: DateTime(2025, 12, 19, 14, 15),
        notes: 'Walmart shopping',
        createdAt: DateTime(2025, 12, 19),
        updatedAt: DateTime(2025, 12, 19),
      );

      transferTransaction = Transaction(
        id: '3',
        userId: 'user_1',
        accountId: 'acc_1',
        categoryId: 'cat_3',
        type: TransactionType.transfer,
        amount: 200.0,
        currency: 'USD',
        description: 'Transfer to Savings',
        date: DateTime(2025, 12, 19, 16, 45),
        toAccountId: 'acc_2',
        createdAt: DateTime(2025, 12, 19),
        updatedAt: DateTime(2025, 12, 19),
      );
    });

    testWidgets('displays income transaction with green color and + prefix',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionListItem(transaction: incomeTransaction),
          ),
        ),
      );

      // Check description is displayed
      expect(find.text('Monthly Salary'), findsOneWidget);

      // Check amount with + prefix is displayed
      expect(find.textContaining('+'), findsOneWidget);
      expect(find.textContaining('1,000.00'), findsOneWidget);

      // Check icon is arrow_downward for income
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });

    testWidgets('displays expense transaction with red color and - prefix',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionListItem(transaction: expenseTransaction),
          ),
        ),
      );

      // Check description is displayed
      expect(find.text('Groceries'), findsOneWidget);

      // Check amount with - prefix is displayed
      expect(find.textContaining('-'), findsOneWidget);
      expect(find.textContaining('50.00'), findsOneWidget);

      // Check icon is arrow_upward for expense
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);

      // Check note icon is displayed when notes exist
      expect(find.byIcon(Icons.note), findsOneWidget);
    });

    testWidgets('displays transfer transaction with blue color',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionListItem(transaction: transferTransaction),
          ),
        ),
      );

      // Check description is displayed
      expect(find.text('Transfer to Savings'), findsOneWidget);

      // Check amount is displayed (no prefix for transfer)
      expect(find.textContaining('200.00'), findsOneWidget);

      // Check icon is swap_horiz for transfer
      expect(find.byIcon(Icons.swap_horiz), findsOneWidget);
    });

    testWidgets('displays formatted time', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionListItem(transaction: incomeTransaction),
          ),
        ),
      );

      // Transaction is at 10:30 AM
      expect(find.text('10:30 AM'), findsOneWidget);
    });

    testWidgets('displays PM time correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionListItem(transaction: expenseTransaction),
          ),
        ),
      );

      // Transaction is at 14:15 (2:15 PM)
      expect(find.text('2:15 PM'), findsOneWidget);
    });

    testWidgets('does not show note icon when notes are null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionListItem(transaction: incomeTransaction),
          ),
        ),
      );

      expect(find.byIcon(Icons.note), findsNothing);
    });

    testWidgets('shows note icon when notes exist',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionListItem(transaction: expenseTransaction),
          ),
        ),
      );

      expect(find.byIcon(Icons.note), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionListItem(
              transaction: incomeTransaction,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      expect(tapped, true);
    });

    testWidgets('calls onLongPress when long pressed',
        (WidgetTester tester) async {
      var longPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionListItem(
              transaction: incomeTransaction,
              onLongPress: () => longPressed = true,
            ),
          ),
        ),
      );

      await tester.longPress(find.byType(ListTile));
      expect(longPressed, true);
    });

    testWidgets('renders within Card widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionListItem(transaction: incomeTransaction),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('description truncates when too long',
        (WidgetTester tester) async {
      final longDescriptionTransaction = Transaction(
        id: '4',
        userId: 'user_1',
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.income,
        amount: 100.0,
        currency: 'USD',
        description:
            'This is a very long description that should be truncated',
        date: DateTime(2025, 12, 19, 10, 30),
        createdAt: DateTime(2025, 12, 19),
        updatedAt: DateTime(2025, 12, 19),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionListItem(transaction: longDescriptionTransaction),
          ),
        ),
      );

      // Find the text widget and verify it has ellipsis overflow
      final textWidget = tester.widget<Text>(
        find.text(
            'This is a very long description that should be truncated'),
      );
      expect(textWidget.overflow, TextOverflow.ellipsis);
      expect(textWidget.maxLines, 1);
    });
  });
}
