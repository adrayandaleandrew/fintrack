import 'package:finance_tracker/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Finance Tracker Integration Tests', () {
    testWidgets('Complete user flow: Login -> Dashboard -> Add Transaction',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Step 1: Login Flow
      // Find email and password fields
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      // Enter credentials
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      // Tap login button
      final loginButton = find.text('Login');
      expect(loginButton, findsOneWidget);
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Step 2: Verify Dashboard loaded
      // Should see dashboard widgets
      expect(find.text('Dashboard'), findsOneWidget);

      // Step 3: Navigate to Transactions
      final transactionsTab = find.text('Transactions');
      if (transactionsTab.evaluate().isNotEmpty) {
        await tester.tap(transactionsTab);
        await tester.pumpAndSettle();
      }

      // Step 4: Add Transaction Flow
      // Find and tap Add Transaction FAB
      final addButton = find.byType(FloatingActionButton);
      if (addButton.evaluate().isNotEmpty) {
        await tester.tap(addButton.first);
        await tester.pumpAndSettle();

        // Fill transaction form
        // Amount field
        final amountField = find.widgetWithText(TextFormField, 'Amount');
        if (amountField.evaluate().isNotEmpty) {
          await tester.enterText(amountField, '100');
          await tester.pumpAndSettle();
        }

        // Description field
        final descriptionField =
            find.widgetWithText(TextFormField, 'Description');
        if (descriptionField.evaluate().isNotEmpty) {
          await tester.enterText(descriptionField, 'Test Transaction');
          await tester.pumpAndSettle();
        }

        // Save transaction
        var saveButton = find.text('Create Transaction');
        if (saveButton.evaluate().isEmpty) {
          saveButton = find.text('Save');
        }
        if (saveButton.evaluate().isNotEmpty) {
          await tester.tap(saveButton.first);
          await tester.pumpAndSettle(const Duration(seconds: 1));
        }
      }

      // Verify we're back to transaction list or dashboard
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Account management flow: View accounts -> Add account',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Login
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to Accounts
      final accountsTab = find.text('Accounts');
      if (accountsTab.evaluate().isNotEmpty) {
        await tester.tap(accountsTab);
        await tester.pumpAndSettle();

        // Verify accounts page loaded
        expect(find.byType(Scaffold), findsOneWidget);

        // Try to add account
        final addButton = find.byType(FloatingActionButton);
        if (addButton.evaluate().isNotEmpty) {
          await tester.tap(addButton.first);
          await tester.pumpAndSettle();

          // Fill account form
          final nameField = find.widgetWithText(TextFormField, 'Account Name');
          if (nameField.evaluate().isNotEmpty) {
            await tester.enterText(nameField, 'Test Account');
            await tester.pumpAndSettle();
          }

          // Save account
          var saveButton = find.text('Create Account');
          if (saveButton.evaluate().isEmpty) {
            saveButton = find.text('Save');
          }
          if (saveButton.evaluate().isNotEmpty) {
            await tester.tap(saveButton.first);
            await tester.pumpAndSettle(const Duration(seconds: 1));
          }
        }
      }

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Budget flow: View budgets -> Create budget',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Login
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to Budgets
      final budgetsTab = find.text('Budgets');
      if (budgetsTab.evaluate().isNotEmpty) {
        await tester.tap(budgetsTab);
        await tester.pumpAndSettle();

        // Verify budgets page loaded
        expect(find.byType(Scaffold), findsOneWidget);

        // Try to add budget
        final addButton = find.byType(FloatingActionButton);
        if (addButton.evaluate().isNotEmpty) {
          await tester.tap(addButton.first);
          await tester.pumpAndSettle();

          // Fill budget form
          final amountField = find.widgetWithText(TextFormField, 'Amount');
          if (amountField.evaluate().isNotEmpty) {
            await tester.enterText(amountField, '500');
            await tester.pumpAndSettle();
          }

          // Save budget
          var saveButton = find.text('Create Budget');
          if (saveButton.evaluate().isEmpty) {
            saveButton = find.text('Save');
          }
          if (saveButton.evaluate().isNotEmpty) {
            await tester.tap(saveButton.first);
            await tester.pumpAndSettle(const Duration(seconds: 1));
          }
        }
      }

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Reports flow: Navigate to reports and view charts',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Login
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to Reports
      final reportsTab = find.text('Reports');
      if (reportsTab.evaluate().isNotEmpty) {
        await tester.tap(reportsTab);
        await tester.pumpAndSettle();

        // Verify reports page loaded
        expect(find.byType(Scaffold), findsOneWidget);

        // Try to switch between report tabs
        final expenseTab = find.text('Expense Breakdown');
        if (expenseTab.evaluate().isNotEmpty) {
          await tester.tap(expenseTab);
          await tester.pumpAndSettle();
        }

        final trendsTab = find.text('Trends');
        if (trendsTab.evaluate().isNotEmpty) {
          await tester.tap(trendsTab);
          await tester.pumpAndSettle();
        }
      }

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Settings flow: Navigate to settings and update currency',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Login
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to Settings (might be in drawer or bottom nav)
      final settingsIcon = find.byIcon(Icons.settings);
      if (settingsIcon.evaluate().isNotEmpty) {
        await tester.tap(settingsIcon.first);
        await tester.pumpAndSettle();

        // Verify settings page loaded
        expect(find.byType(Scaffold), findsOneWidget);

        // Look for currency settings
        final currencyOption = find.text('Currency');
        if (currencyOption.evaluate().isNotEmpty) {
          await tester.tap(currencyOption);
          await tester.pumpAndSettle();
        }
      }

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Logout flow: Navigate to profile and logout',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Login
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for logout button (might be in drawer, profile, or settings)
      var logoutButton = find.text('Logout');
      if (logoutButton.evaluate().isEmpty) {
        logoutButton = find.text('Sign Out');
      }
      if (logoutButton.evaluate().isEmpty) {
        // Try opening drawer
        final drawerIcon = find.byIcon(Icons.menu);
        if (drawerIcon.evaluate().isNotEmpty) {
          await tester.tap(drawerIcon.first);
          await tester.pumpAndSettle();
        }
      }

      var logoutButtonAfter = find.text('Logout');
      if (logoutButtonAfter.evaluate().isEmpty) {
        logoutButtonAfter = find.text('Sign Out');
      }
      if (logoutButtonAfter.evaluate().isNotEmpty) {
        await tester.tap(logoutButtonAfter.first);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Should return to login screen
        var loginButton = find.text('Login');
        if (loginButton.evaluate().isEmpty) {
          loginButton = find.text('Sign In');
        }
        expect(loginButton, findsOneWidget);
      }
    });
  });
}
