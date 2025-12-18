import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:finance_tracker/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finance_tracker/features/transactions/domain/usecases/filter_transactions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'filter_transactions_test.mocks.dart';

@GenerateMocks([TransactionRepository])
void main() {
  late FilterTransactions useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = FilterTransactions(repository: mockRepository);
  });

  group('FilterTransactions', () {
    const tUserId = 'user_1';
    final tStartDate = DateTime(2025, 12, 1);
    final tEndDate = DateTime(2025, 12, 31);
    const tAccountId = 'acc_1';
    const tCategoryId = 'cat_1';
    const tType = TransactionType.expense;

    final tFilteredTransactions = [
      Transaction(
        id: 'txn_1',
        userId: tUserId,
        accountId: tAccountId,
        categoryId: tCategoryId,
        type: tType,
        amount: 100.0,
        currency: 'USD',
        description: 'Groceries',
        date: DateTime(2025, 12, 15),
        createdAt: DateTime(2025, 12, 15),
        updatedAt: DateTime(2025, 12, 15),
      ),
      Transaction(
        id: 'txn_2',
        userId: tUserId,
        accountId: tAccountId,
        categoryId: tCategoryId,
        type: tType,
        amount: 50.0,
        currency: 'USD',
        description: 'Shopping',
        date: DateTime(2025, 12, 20),
        createdAt: DateTime(2025, 12, 20),
        updatedAt: DateTime(2025, 12, 20),
      ),
    ];

    test('should filter transactions with all criteria', () async {
      // Arrange
      when(mockRepository.filterTransactions(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        accountId: anyNamed('accountId'),
        categoryId: anyNamed('categoryId'),
        type: anyNamed('type'),
      )).thenAnswer((_) async => Right(tFilteredTransactions));

      // Act
      final result = await useCase(FilterTransactionsParams(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        accountId: tAccountId,
        categoryId: tCategoryId,
        type: tType,
      ));

      // Assert
      expect(result, Right(tFilteredTransactions));
      verify(mockRepository.filterTransactions(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        accountId: tAccountId,
        categoryId: tCategoryId,
        type: tType,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should filter transactions with date range only', () async {
      // Arrange
      when(mockRepository.filterTransactions(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        accountId: anyNamed('accountId'),
        categoryId: anyNamed('categoryId'),
        type: anyNamed('type'),
      )).thenAnswer((_) async => Right(tFilteredTransactions));

      // Act
      final result = await useCase(FilterTransactionsParams(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
      ));

      // Assert
      expect(result, Right(tFilteredTransactions));
      verify(mockRepository.filterTransactions(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        accountId: null,
        categoryId: null,
        type: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should filter transactions by account only', () async {
      // Arrange
      when(mockRepository.filterTransactions(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        accountId: anyNamed('accountId'),
        categoryId: anyNamed('categoryId'),
        type: anyNamed('type'),
      )).thenAnswer((_) async => Right(tFilteredTransactions));

      // Act
      final result = await useCase(const FilterTransactionsParams(
        userId: tUserId,
        accountId: tAccountId,
      ));

      // Assert
      expect(result, Right(tFilteredTransactions));
      verify(mockRepository.filterTransactions(
        userId: tUserId,
        startDate: null,
        endDate: null,
        accountId: tAccountId,
        categoryId: null,
        type: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should filter transactions by type only', () async {
      // Arrange
      when(mockRepository.filterTransactions(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        accountId: anyNamed('accountId'),
        categoryId: anyNamed('categoryId'),
        type: anyNamed('type'),
      )).thenAnswer((_) async => Right(tFilteredTransactions));

      // Act
      final result = await useCase(const FilterTransactionsParams(
        userId: tUserId,
        type: tType,
      ));

      // Assert
      expect(result, Right(tFilteredTransactions));
      verify(mockRepository.filterTransactions(
        userId: tUserId,
        startDate: null,
        endDate: null,
        accountId: null,
        categoryId: null,
        type: tType,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no transactions match filters', () async {
      // Arrange
      when(mockRepository.filterTransactions(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        accountId: anyNamed('accountId'),
        categoryId: anyNamed('categoryId'),
        type: anyNamed('type'),
      )).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));

      // Act
      final result = await useCase(FilterTransactionsParams(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
      ));

      // Assert
      expect(result, const Right<Failure, List<Transaction>>([]));
      verify(mockRepository.filterTransactions(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        accountId: null,
        categoryId: null,
        type: null,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.filterTransactions(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        accountId: anyNamed('accountId'),
        categoryId: anyNamed('categoryId'),
        type: anyNamed('type'),
      )).thenAnswer((_) async => Left(ServerFailure('Server error')));

      // Act
      final result = await useCase(const FilterTransactionsParams(
        userId: tUserId,
        type: tType,
      ));

      // Assert
      expect(result, Left(ServerFailure('Server error')));
      verify(mockRepository.filterTransactions(
        userId: tUserId,
        startDate: null,
        endDate: null,
        accountId: null,
        categoryId: null,
        type: tType,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
