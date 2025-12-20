import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/recurring_transactions/domain/repositories/recurring_transaction_repository.dart';
import 'package:finance_tracker/features/recurring_transactions/domain/usecases/process_due_recurring_transactions.dart';
import 'package:finance_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'process_due_recurring_transactions_test.mocks.dart';

@GenerateMocks([RecurringTransactionRepository])
void main() {
  late ProcessDueRecurringTransactions useCase;
  late MockRecurringTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockRecurringTransactionRepository();
    useCase = ProcessDueRecurringTransactions(mockRepository);
  });

  group('ProcessDueRecurringTransactions', () {
    final tGeneratedTransactions = [
      Transaction(
        id: 'txn_1',
        userId: 'user_1',
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 100.0,
        currency: 'USD',
        description: 'Monthly Rent',
        date: DateTime(2025, 1, 1),
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      ),
      Transaction(
        id: 'txn_2',
        userId: 'user_1',
        accountId: 'acc_2',
        categoryId: 'cat_2',
        type: TransactionType.income,
        amount: 5000.0,
        currency: 'USD',
        description: 'Salary',
        date: DateTime(2025, 1, 1),
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      ),
    ];

    test('should process due recurring transactions successfully', () async {
      // Arrange
      when(mockRepository.processDueRecurringTransactions())
          .thenAnswer((_) async => Right(tGeneratedTransactions));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Right(tGeneratedTransactions));
      verify(mockRepository.processDueRecurringTransactions());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no due recurring transactions', () async {
      // Arrange
      when(mockRepository.processDueRecurringTransactions())
          .thenAnswer((_) async => const Right([]));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (transactions) => expect(transactions, isEmpty),
      );
      verify(mockRepository.processDueRecurringTransactions());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.processDueRecurringTransactions()).thenAnswer(
        (_) async => Left(ServerFailure('Failed to process recurring transactions')),
      );

      // Act
      final result = await useCase();

      // Assert
      expect(result, Left(ServerFailure('Failed to process recurring transactions')));
      verify(mockRepository.processDueRecurringTransactions());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when cache fails', () async {
      // Arrange
      when(mockRepository.processDueRecurringTransactions()).thenAnswer(
        (_) async => Left(CacheFailure('Failed to load from cache')),
      );

      // Act
      final result = await useCase();

      // Assert
      expect(result, Left(CacheFailure('Failed to load from cache')));
      verify(mockRepository.processDueRecurringTransactions());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
