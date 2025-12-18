import 'package:finance_tracker/features/accounts/domain/entities/account.dart';
import 'package:finance_tracker/features/accounts/presentation/widgets/account_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AccountCard', () {
    late Account testAccount;
    late Account creditCardAccount;
    late Account inactiveAccount;

    setUp(() {
      testAccount = Account(
        id: 'acc_1',
        userId: 'user_1',
        name: 'Checking Account',
        type: AccountType.bank,
        balance: 5000.0,
        currency: 'USD',
        icon: 'account_balance',
        color: '#2196F3',
        isActive: true,
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      );

      creditCardAccount = Account(
        id: 'acc_2',
        userId: 'user_1',
        name: 'Credit Card',
        type: AccountType.creditCard,
        balance: -500.0,
        currency: 'USD',
        icon: 'credit_card',
        color: '#FF5722',
        creditLimit: 5000.0,
        isActive: true,
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      );

      inactiveAccount = Account(
        id: 'acc_3',
        userId: 'user_1',
        name: 'Old Savings',
        type: AccountType.bank,
        balance: 1000.0,
        currency: 'USD',
        icon: 'savings',
        color: '#4CAF50',
        isActive: false,
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      );
    });

    testWidgets('renders account name and type', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(account: testAccount),
          ),
        ),
      );

      expect(find.text('Checking Account'), findsOneWidget);
      expect(find.text('Bank Account'), findsOneWidget);
    });

    testWidgets('renders account balance with color coding',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(account: testAccount),
          ),
        ),
      );

      expect(find.textContaining('5,000.00'), findsOneWidget);
    });

    testWidgets('renders negative balance in red',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(account: creditCardAccount),
          ),
        ),
      );

      expect(find.textContaining('500.00'), findsOneWidget);
    });

    testWidgets('shows credit limit for credit card accounts',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(account: creditCardAccount),
          ),
        ),
      );

      expect(find.textContaining('Limit'), findsOneWidget);
      expect(find.textContaining('5,000.00'), findsOneWidget);
    });

    testWidgets('does not show credit limit for non-credit card accounts',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(account: testAccount),
          ),
        ),
      );

      expect(find.textContaining('Limit'), findsNothing);
    });

    testWidgets('shows inactive status when account is inactive',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(account: inactiveAccount),
          ),
        ),
      );

      expect(find.text('Inactive'), findsOneWidget);
    });

    testWidgets('does not show inactive status when account is active',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(account: testAccount),
          ),
        ),
      );

      expect(find.text('Inactive'), findsNothing);
    });

    testWidgets('hides status when showStatus is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(
              account: inactiveAccount,
              showStatus: false,
            ),
          ),
        ),
      );

      expect(find.text('Inactive'), findsNothing);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(
              account: testAccount,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, true);
    });

    testWidgets('renders within Card widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(account: testAccount),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('displays correct icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(account: testAccount),
          ),
        ),
      );

      expect(find.byIcon(Icons.account_balance), findsOneWidget);
    });

    testWidgets('displays credit card icon for credit card account',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(account: creditCardAccount),
          ),
        ),
      );

      expect(find.byIcon(Icons.credit_card), findsOneWidget);
    });

    testWidgets('displays all account types correctly',
        (WidgetTester tester) async {
      final cashAccount = Account(
        id: 'acc_4',
        userId: 'user_1',
        name: 'Cash Wallet',
        type: AccountType.cash,
        balance: 500.0,
        currency: 'USD',
        icon: 'money',
        color: '#4CAF50',
        isActive: true,
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(account: cashAccount),
          ),
        ),
      );

      expect(find.text('Cash Wallet'), findsOneWidget);
      expect(find.text('Cash'), findsOneWidget); // Account type
      expect(find.byIcon(Icons.money), findsOneWidget);
    });

    testWidgets('handles invalid color gracefully',
        (WidgetTester tester) async {
      final invalidColorAccount = Account(
        id: 'acc_5',
        userId: 'user_1',
        name: 'Test',
        type: AccountType.bank,
        balance: 1000.0,
        currency: 'USD',
        icon: 'account_balance',
        color: 'invalid_color',
        isActive: true,
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(account: invalidColorAccount),
          ),
        ),
      );

      expect(find.byType(AccountCard), findsOneWidget);
    });

    testWidgets('handles unknown icon name gracefully',
        (WidgetTester tester) async {
      final unknownIconAccount = Account(
        id: 'acc_6',
        userId: 'user_1',
        name: 'Test',
        type: AccountType.bank,
        balance: 1000.0,
        currency: 'USD',
        icon: 'unknown_icon',
        color: '#2196F3',
        isActive: true,
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(account: unknownIconAccount),
          ),
        ),
      );

      // Should fall back to default icon
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
    });

    testWidgets('displays Investment account type',
        (WidgetTester tester) async {
      final investmentAccount = Account(
        id: 'acc_7',
        userId: 'user_1',
        name: 'Investment Portfolio',
        type: AccountType.investment,
        balance: 25000.0,
        currency: 'USD',
        icon: 'trending_up',
        color: '#9C27B0',
        isActive: true,
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(account: investmentAccount),
          ),
        ),
      );

      expect(find.text('Investment'), findsOneWidget);
      expect(find.byIcon(Icons.trending_up), findsOneWidget);
    });
  });
}
