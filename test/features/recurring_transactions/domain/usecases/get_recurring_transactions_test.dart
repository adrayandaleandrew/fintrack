import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/recurring_transactions/domain/entities/recurring_transaction.dart';
import 'package:finance_tracker/features/recurring_transactions/domain/repositories/recurring_transaction_repository.dart';
import 'package:finance_tracker/features/recurring_transactions/domain/usecases/get_recurring_transactions.dart';
import 'package:finance_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_recurring_transactions_test.mocks.dart';

@GenerateMocks([RecurringTransactionRepository])
void main() {
  late GetRecurringTransactions useCase;
  late MockRecurringTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockRecurringTransactionRepository();
    useCase = GetRecurringTransactions(mockRepository);
  });

  group('GetRecurringTransactions', () {
    const tUserId = 'user_1';
    final tRecurringTransactions = [
      RecurringTransaction(
        id: 'rec_1',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 100.0,
        currency: 'USD',
        description: 'Monthly Rent',
        frequency: RecurringFrequency.monthly,
        startDate: DateTime(2025, 1, 1),
        isActive: true,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      ),
      RecurringTransaction(
        id: 'rec_2',
        userId: tUserId,
        accountId: 'acc_2',
        categoryId: 'cat_2',
        type: TransactionType.income,
        amount: 5000.0,
        currency: 'USD',
        description: 'Salary',
        frequency: RecurringFrequency.monthly,
        startDate: DateTime(2025, 1, 1),
        isActive: true,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      ),
    ];

    test('should get list of recurring transactions from repository', () async {
      // Arrange
      when(mockRepository.getRecurringTransactions(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => Right(tRecurringTransactions));

      // Act
      final result = await useCase(
        const GetRecurringTransactionsParams(userId: tUserId),
      );

      // Assert
      expect(result, Right(tRecurringTransactions));
      verify(mockRepository.getRecurringTransactions(
        userId: tUserId,
        activeOnly: false,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get only active recurring transactions when activeOnly is true', () async {
      // Arrange
      final activeTransactions = [tRecurringTransactions.first];
      when(mockRepository.getRecurringTransactions(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => Right(activeTransactions));

      // Act
      final result = await useCase(
        const GetRecurringTransactionsParams(userId: tUserId, activeOnly: true),
      );

      // Assert
      expect(result, Right(activeTransactions));
      verify(mockRepository.getRecurringTransactions(
        userId: tUserId,
        activeOnly: true,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no recurring transactions exist', () async {
      // Arrange
      when(mockRepository.getRecurringTransactions(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => const Right([]));

      // Act
      final result = await useCase(
        const GetRecurringTransactionsParams(userId: tUserId),
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (transactions) => expect(transactions, isEmpty),
      );
      verify(mockRepository.getRecurringTransactions(
        userId: tUserId,
        activeOnly: false,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.getRecurringTransactions(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer(
        (_) async => Left(ServerFailure('Failed to get recurring transactions')),
      );

      // Act
      final result = await useCase(
        const GetRecurringTransactionsParams(userId: tUserId),
      );

      // Assert
      expect(result, Left(ServerFailure('Failed to get recurring transactions')));
      verify(mockRepository.getRecurringTransactions(
        userId: tUserId,
        activeOnly: false,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when cache fails', () async {
      // Arrange
      when(mockRepository.getRecurringTransactions(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer(
        (_) async => Left(CacheFailure('Failed to load from cache')),
      );

      // Act
      final result = await useCase(
        const GetRecurringTransactionsParams(userId: tUserId),
      );

      // Assert
      expect(result, Left(CacheFailure('Failed to load from cache')));
      verify(mockRepository.getRecurringTransactions(
        userId: tUserId,
        activeOnly: false,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
