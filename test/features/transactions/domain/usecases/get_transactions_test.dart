import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:finance_tracker/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finance_tracker/features/transactions/domain/usecases/get_transactions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_transactions_test.mocks.dart';

@GenerateMocks([TransactionRepository])
void main() {
  late GetTransactions useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = GetTransactions(repository: mockRepository);
  });

  group('GetTransactions', () {
    const tUserId = 'user_1';
    final tTransactions = [
      Transaction(
        id: 'txn_1',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.income,
        amount: 1000.0,
        currency: 'USD',
        description: 'Salary',
        date: DateTime(2025, 12, 1),
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      ),
      Transaction(
        id: 'txn_2',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_2',
        type: TransactionType.expense,
        amount: 50.0,
        currency: 'USD',
        description: 'Groceries',
        date: DateTime(2025, 12, 2),
        createdAt: DateTime(2025, 12, 2),
        updatedAt: DateTime(2025, 12, 2),
      ),
    ];

    test('should get list of transactions from repository', () async {
      // Arrange
      when(mockRepository.getTransactions(any))
          .thenAnswer((_) async => Right(tTransactions));

      // Act
      final result = await useCase(const GetTransactionsParams(userId: tUserId));

      // Assert
      expect(result, Right(tTransactions));
      verify(mockRepository.getTransactions(tUserId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.getTransactions(any))
          .thenAnswer((_) async => Left(ServerFailure('Server error')));

      // Act
      final result = await useCase(const GetTransactionsParams(userId: tUserId));

      // Assert
      expect(result, Left(ServerFailure('Server error')));
      verify(mockRepository.getTransactions(tUserId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when cache fails', () async {
      // Arrange
      when(mockRepository.getTransactions(any))
          .thenAnswer((_) async => Left(CacheFailure('Cache error')));

      // Act
      final result = await useCase(const GetTransactionsParams(userId: tUserId));

      // Assert
      expect(result, Left(CacheFailure('Cache error')));
      verify(mockRepository.getTransactions(tUserId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no transactions exist', () async {
      // Arrange
      when(mockRepository.getTransactions(any))
          .thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));

      // Act
      final result = await useCase(const GetTransactionsParams(userId: tUserId));

      // Assert
      expect(result, const Right<Failure, List<Transaction>>([]));
      verify(mockRepository.getTransactions(tUserId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
