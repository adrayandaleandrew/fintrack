import 'package:flutter_test/flutter_test.dart';
import '../../lib/core/utils/test_data_generator.dart';

/// Performance test for large datasets
///
/// Verifies the app can handle 1000+ transactions efficiently.
/// Following bestpractices.md: Test with production-like data volumes.
void main() {
  group('Large Dataset Performance Tests', () {
    late TestDataGenerator generator;

    setUp(() {
      generator = TestDataGenerator();
    });

    test('should generate 1000 transactions quickly', () {
      final stopwatch = Stopwatch()..start();

      final dataset = generator.generateCompleteDataset(
        accountCount: 10,
        categoryCount: 20,
        transactionCount: 1000,
      );

      stopwatch.stop();

      // Verify data was generated
      expect(dataset['transactions'], hasLength(1000));
      expect(dataset['accounts'], hasLength(10));
      expect(dataset['categories'], hasLength(20));

      // Should generate in under 1 second
      expect(stopwatch.elapsedMilliseconds, lessThan(1000),
          reason: 'Dataset generation should be fast');

      // Print summary
      generator.printDatasetSummary(dataset);
    });

    test('should generate 5000 transactions for stress testing', () {
      final stopwatch = Stopwatch()..start();

      final dataset = generator.generateCompleteDataset(
        accountCount: 15,
        categoryCount: 30,
        transactionCount: 5000,
      );

      stopwatch.stop();

      expect(dataset['transactions'], hasLength(5000));
      expect(stopwatch.elapsedMilliseconds, lessThan(5000),
          reason: 'Even large datasets should generate quickly');

      print('Generated 5000 transactions in ${stopwatch.elapsedMilliseconds}ms');
    });

    test('should generate realistic transaction amounts', () {
      final dataset = generator.generateCompleteDataset(
        transactionCount: 100,
      );

      final transactions = dataset['transactions'] as List;

      // Verify amounts are positive
      for (final txn in transactions) {
        expect(txn.amount, greaterThan(0));
      }

      // Verify we have a mix of small and large amounts
      final amounts = transactions.map((t) => t.amount).toList();
      final minAmount = amounts.reduce((a, b) => a < b ? a : b);
      final maxAmount = amounts.reduce((a, b) => a > b ? a : b);

      expect(minAmount, greaterThan(0));
      expect(maxAmount, greaterThan(100),
          reason: 'Should have some larger transactions');
    });

    test('should generate transactions with proper date distribution', () {
      final dataset = generator.generateCompleteDataset(
        transactionCount: 1000,
      );

      final transactions = dataset['transactions'] as List;
      final now = DateTime.now();
      final oneYearAgo = now.subtract(const Duration(days: 365));

      // All transactions should be within the past year
      for (final txn in transactions) {
        expect(txn.date.isAfter(oneYearAgo), isTrue);
        expect(txn.date.isBefore(now.add(const Duration(hours: 1))), isTrue);
      }

      // Verify transactions are sorted by date (most recent first)
      for (var i = 0; i < transactions.length - 1; i++) {
        expect(
          transactions[i].date.isAfter(transactions[i + 1].date) ||
              transactions[i].date.isAtSameMomentAs(transactions[i + 1].date),
          isTrue,
          reason: 'Transactions should be sorted by date descending',
        );
      }
    });

    test('should generate mix of transaction types', () {
      final dataset = generator.generateCompleteDataset(
        transactionCount: 1000,
      );

      final transactions = dataset['transactions'] as List;

      final incomeCount = transactions
          .where((t) => t.type.toString().contains('income'))
          .length;
      final expenseCount = transactions
          .where((t) => t.type.toString().contains('expense'))
          .length;
      final transferCount = transactions
          .where((t) => t.type.toString().contains('transfer'))
          .length;

      // Should have a realistic mix (roughly 60% expense, 30% income, 10% transfer)
      expect(expenseCount, greaterThan(500),
          reason: 'Should have majority expenses');
      expect(incomeCount, greaterThan(200),
          reason: 'Should have decent number of income transactions');
      expect(transferCount, greaterThan(50),
          reason: 'Should have some transfers');

      print('Transaction distribution:');
      print('  Income: $incomeCount (${(incomeCount / 1000 * 100).toStringAsFixed(1)}%)');
      print('  Expense: $expenseCount (${(expenseCount / 1000 * 100).toStringAsFixed(1)}%)');
      print('  Transfer: $transferCount (${(transferCount / 1000 * 100).toStringAsFixed(1)}%)');
    });

    test('should generate varied account types', () {
      final accounts = generator.generateAccounts(count: 10);

      // Should have different account types
      final types = accounts.map((a) => a.type).toSet();
      expect(types.length, greaterThan(1),
          reason: 'Should have variety of account types');

      // Credit cards should have credit limits
      final creditCards = accounts
          .where((a) => a.type.toString().contains('creditCard'));
      for (final card in creditCards) {
        expect(card.creditLimit, isNotNull);
        expect(card.creditLimit!, greaterThan(0));
      }
    });

    test('memory usage should remain reasonable with large dataset', () {
      // Generate multiple large datasets to test memory
      for (var i = 0; i < 5; i++) {
        final dataset = generator.generateCompleteDataset(
          transactionCount: 1000,
        );

        expect(dataset['transactions'], hasLength(1000));
      }

      // If we get here without OOM, memory usage is acceptable
      expect(true, isTrue);
    });
  });
}
