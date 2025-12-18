import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:finance_tracker/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finance_tracker/features/transactions/domain/usecases/search_transactions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_transactions_test.mocks.dart';

@GenerateMocks([TransactionRepository])
void main() {
  late SearchTransactions useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = SearchTransactions(repository: mockRepository);
  });

  group('SearchTransactions', () {
    const tUserId = 'user_1';
    const tQuery = 'groceries';

    final tSearchResults = [
      Transaction(
        id: 'txn_1',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 100.0,
        currency: 'USD',
        description: 'Groceries at Walmart',
        date: DateTime(2025, 12, 1),
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      ),
      Transaction(
        id: 'txn_2',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 50.0,
        currency: 'USD',
        description: 'Weekly groceries',
        date: DateTime(2025, 12, 8),
        createdAt: DateTime(2025, 12, 8),
        updatedAt: DateTime(2025, 12, 8),
      ),
    ];

    test('should search transactions successfully', () async {
      // Arrange
      when(mockRepository.searchTransactions(
        userId: anyNamed('userId'),
        query: anyNamed('query'),
      )).thenAnswer((_) async => Right(tSearchResults));

      // Act
      final result = await useCase(const SearchTransactionsParams(
        userId: tUserId,
        query: tQuery,
      ));

      // Assert
      expect(result, Right(tSearchResults));
      verify(mockRepository.searchTransactions(
        userId: tUserId,
        query: tQuery,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when query is empty', () async {
      // Act
      final result = await useCase(const SearchTransactionsParams(
        userId: tUserId,
        query: '',
      ));

      // Assert
      expect(result, Left(ValidationFailure('Search query cannot be empty')));
      verifyZeroInteractions(mockRepository);
    });

    test('should return ValidationFailure when query is only whitespace', () async {
      // Act
      final result = await useCase(const SearchTransactionsParams(
        userId: tUserId,
        query: '   ',
      ));

      // Assert
      expect(result, Left(ValidationFailure('Search query cannot be empty')));
      verifyZeroInteractions(mockRepository);
    });

    test('should return empty list when no transactions match query', () async {
      // Arrange
      when(mockRepository.searchTransactions(
        userId: anyNamed('userId'),
        query: anyNamed('query'),
      )).thenAnswer((_) async => const Right<Failure, List<Transaction>>([]));

      // Act
      final result = await useCase(const SearchTransactionsParams(
        userId: tUserId,
        query: 'nonexistent',
      ));

      // Assert
      expect(result, const Right<Failure, List<Transaction>>([]));
      verify(mockRepository.searchTransactions(
        userId: tUserId,
        query: 'nonexistent',
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should search with case-insensitive query', () async {
      // Arrange
      when(mockRepository.searchTransactions(
        userId: anyNamed('userId'),
        query: anyNamed('query'),
      )).thenAnswer((_) async => Right(tSearchResults));

      // Act
      final result = await useCase(const SearchTransactionsParams(
        userId: tUserId,
        query: 'GROCERIES', // Uppercase
      ));

      // Assert
      expect(result, Right(tSearchResults));
      verify(mockRepository.searchTransactions(
        userId: tUserId,
        query: 'GROCERIES',
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.searchTransactions(
        userId: anyNamed('userId'),
        query: anyNamed('query'),
      )).thenAnswer((_) async => Left(ServerFailure('Search failed')));

      // Act
      final result = await useCase(const SearchTransactionsParams(
        userId: tUserId,
        query: tQuery,
      ));

      // Assert
      expect(result, Left(ServerFailure('Search failed')));
      verify(mockRepository.searchTransactions(
        userId: tUserId,
        query: tQuery,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
