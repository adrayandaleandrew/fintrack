import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/recurring_transactions/domain/entities/recurring_transaction.dart';
import 'package:finance_tracker/features/recurring_transactions/domain/repositories/recurring_transaction_repository.dart';
import 'package:finance_tracker/features/recurring_transactions/domain/usecases/create_recurring_transaction.dart';
import 'package:finance_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_recurring_transaction_test.mocks.dart';

@GenerateMocks([RecurringTransactionRepository])
void main() {
  late CreateRecurringTransaction useCase;
  late MockRecurringTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockRecurringTransactionRepository();
    useCase = CreateRecurringTransaction(mockRepository);
  });

  group('CreateRecurringTransaction', () {
    const tUserId = 'user_1';
    final tRecurringTransaction = RecurringTransaction(
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
    );

    test('should create recurring transaction successfully', () async {
      // Arrange
      when(mockRepository.createRecurringTransaction(
        recurringTransaction: anyNamed('recurringTransaction'),
      )).thenAnswer((_) async => Right(tRecurringTransaction));

      // Act
      final result = await useCase(
        CreateRecurringTransactionParams(
          recurringTransaction: tRecurringTransaction,
        ),
      );

      // Assert
      expect(result, Right(tRecurringTransaction));
      verify(mockRepository.createRecurringTransaction(
        recurringTransaction: tRecurringTransaction,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should create recurring transaction with end date', () async {
      // Arrange
      final transactionWithEndDate = RecurringTransaction(
        id: 'rec_2',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 50.0,
        currency: 'USD',
        description: 'Gym Membership',
        frequency: RecurringFrequency.monthly,
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 12, 31),
        isActive: true,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      when(mockRepository.createRecurringTransaction(
        recurringTransaction: anyNamed('recurringTransaction'),
      )).thenAnswer((_) async => Right(transactionWithEndDate));

      // Act
      final result = await useCase(
        CreateRecurringTransactionParams(
          recurringTransaction: transactionWithEndDate,
        ),
      );

      // Assert
      expect(result, Right(transactionWithEndDate));
      verify(mockRepository.createRecurringTransaction(
        recurringTransaction: transactionWithEndDate,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should create recurring transaction with max occurrences', () async {
      // Arrange
      final transactionWithMaxOccurrences = RecurringTransaction(
        id: 'rec_3',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 25.0,
        currency: 'USD',
        description: 'Subscription',
        frequency: RecurringFrequency.monthly,
        startDate: DateTime(2025, 1, 1),
        maxOccurrences: 12,
        isActive: true,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      when(mockRepository.createRecurringTransaction(
        recurringTransaction: anyNamed('recurringTransaction'),
      )).thenAnswer((_) async => Right(transactionWithMaxOccurrences));

      // Act
      final result = await useCase(
        CreateRecurringTransactionParams(
          recurringTransaction: transactionWithMaxOccurrences,
        ),
      );

      // Assert
      expect(result, Right(transactionWithMaxOccurrences));
      verify(mockRepository.createRecurringTransaction(
        recurringTransaction: transactionWithMaxOccurrences,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when amount is zero', () async {
      // Arrange
      final invalidTransaction = RecurringTransaction(
        id: 'rec_4',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 0.0,
        currency: 'USD',
        description: 'Invalid',
        frequency: RecurringFrequency.monthly,
        startDate: DateTime(2025, 1, 1),
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      // Act
      final result = await useCase(
        CreateRecurringTransactionParams(
          recurringTransaction: invalidTransaction,
        ),
      );

      // Assert
      expect(result, Left(ValidationFailure('Amount must be greater than zero')));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when amount is negative', () async {
      // Arrange
      final invalidTransaction = RecurringTransaction(
        id: 'rec_5',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: -100.0,
        currency: 'USD',
        description: 'Invalid',
        frequency: RecurringFrequency.monthly,
        startDate: DateTime(2025, 1, 1),
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      // Act
      final result = await useCase(
        CreateRecurringTransactionParams(
          recurringTransaction: invalidTransaction,
        ),
      );

      // Assert
      expect(result, Left(ValidationFailure('Amount must be greater than zero')));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when end date is before start date', () async {
      // Arrange
      final invalidTransaction = RecurringTransaction(
        id: 'rec_6',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 100.0,
        currency: 'USD',
        description: 'Invalid',
        frequency: RecurringFrequency.monthly,
        startDate: DateTime(2025, 12, 1),
        endDate: DateTime(2025, 1, 1),
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      // Act
      final result = await useCase(
        CreateRecurringTransactionParams(
          recurringTransaction: invalidTransaction,
        ),
      );

      // Assert
      expect(result, Left(ValidationFailure('End date must be after start date')));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when max occurrences is zero', () async {
      // Arrange
      final invalidTransaction = RecurringTransaction(
        id: 'rec_7',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 100.0,
        currency: 'USD',
        description: 'Invalid',
        frequency: RecurringFrequency.monthly,
        startDate: DateTime(2025, 1, 1),
        maxOccurrences: 0,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      // Act
      final result = await useCase(
        CreateRecurringTransactionParams(
          recurringTransaction: invalidTransaction,
        ),
      );

      // Assert
      expect(result, Left(ValidationFailure('Max occurrences must be greater than zero')));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when max occurrences is negative', () async {
      // Arrange
      final invalidTransaction = RecurringTransaction(
        id: 'rec_8',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 100.0,
        currency: 'USD',
        description: 'Invalid',
        frequency: RecurringFrequency.monthly,
        startDate: DateTime(2025, 1, 1),
        maxOccurrences: -5,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      // Act
      final result = await useCase(
        CreateRecurringTransactionParams(
          recurringTransaction: invalidTransaction,
        ),
      );

      // Assert
      expect(result, Left(ValidationFailure('Max occurrences must be greater than zero')));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.createRecurringTransaction(
        recurringTransaction: anyNamed('recurringTransaction'),
      )).thenAnswer(
        (_) async => Left(ServerFailure('Failed to create recurring transaction')),
      );

      // Act
      final result = await useCase(
        CreateRecurringTransactionParams(
          recurringTransaction: tRecurringTransaction,
        ),
      );

      // Assert
      expect(result, Left(ServerFailure('Failed to create recurring transaction')));
      verify(mockRepository.createRecurringTransaction(
        recurringTransaction: tRecurringTransaction,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
