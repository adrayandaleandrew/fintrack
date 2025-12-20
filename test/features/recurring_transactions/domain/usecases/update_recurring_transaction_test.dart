import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/recurring_transactions/domain/entities/recurring_transaction.dart';
import 'package:finance_tracker/features/recurring_transactions/domain/repositories/recurring_transaction_repository.dart';
import 'package:finance_tracker/features/recurring_transactions/domain/usecases/update_recurring_transaction.dart';
import 'package:finance_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_recurring_transaction_test.mocks.dart';

@GenerateMocks([RecurringTransactionRepository])
void main() {
  late UpdateRecurringTransaction useCase;
  late MockRecurringTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockRecurringTransactionRepository();
    useCase = UpdateRecurringTransaction(mockRepository);
  });

  group('UpdateRecurringTransaction', () {
    const tUserId = 'user_1';
    final tRecurringTransaction = RecurringTransaction(
      id: 'rec_1',
      userId: tUserId,
      accountId: 'acc_1',
      categoryId: 'cat_1',
      type: TransactionType.expense,
      amount: 150.0,
      currency: 'USD',
      description: 'Updated Monthly Rent',
      frequency: RecurringFrequency.monthly,
      startDate: DateTime(2025, 1, 1),
      isActive: true,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 15),
    );

    test('should update recurring transaction successfully', () async {
      // Arrange
      when(mockRepository.updateRecurringTransaction(
        recurringTransaction: anyNamed('recurringTransaction'),
      )).thenAnswer((_) async => Right(tRecurringTransaction));

      // Act
      final result = await useCase(
        UpdateRecurringTransactionParams(
          recurringTransaction: tRecurringTransaction,
        ),
      );

      // Assert
      expect(result, Right(tRecurringTransaction));
      verify(mockRepository.updateRecurringTransaction(
        recurringTransaction: tRecurringTransaction,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should update recurring transaction amount', () async {
      // Arrange
      final updatedTransaction = RecurringTransaction(
        id: 'rec_1',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 200.0,
        currency: 'USD',
        description: 'Monthly Rent',
        frequency: RecurringFrequency.monthly,
        startDate: DateTime(2025, 1, 1),
        isActive: true,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 15),
      );

      when(mockRepository.updateRecurringTransaction(
        recurringTransaction: anyNamed('recurringTransaction'),
      )).thenAnswer((_) async => Right(updatedTransaction));

      // Act
      final result = await useCase(
        UpdateRecurringTransactionParams(
          recurringTransaction: updatedTransaction,
        ),
      );

      // Assert
      expect(result, Right(updatedTransaction));
      verify(mockRepository.updateRecurringTransaction(
        recurringTransaction: updatedTransaction,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should deactivate recurring transaction', () async {
      // Arrange
      final inactiveTransaction = RecurringTransaction(
        id: 'rec_1',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 150.0,
        currency: 'USD',
        description: 'Monthly Rent',
        frequency: RecurringFrequency.monthly,
        startDate: DateTime(2025, 1, 1),
        isActive: false,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 15),
      );

      when(mockRepository.updateRecurringTransaction(
        recurringTransaction: anyNamed('recurringTransaction'),
      )).thenAnswer((_) async => Right(inactiveTransaction));

      // Act
      final result = await useCase(
        UpdateRecurringTransactionParams(
          recurringTransaction: inactiveTransaction,
        ),
      );

      // Assert
      expect(result, Right(inactiveTransaction));
      verify(mockRepository.updateRecurringTransaction(
        recurringTransaction: inactiveTransaction,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when amount is zero', () async {
      // Arrange
      final invalidTransaction = RecurringTransaction(
        id: 'rec_1',
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
        updatedAt: DateTime(2025, 1, 15),
      );

      // Act
      final result = await useCase(
        UpdateRecurringTransactionParams(
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
        id: 'rec_1',
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
        updatedAt: DateTime(2025, 1, 15),
      );

      // Act
      final result = await useCase(
        UpdateRecurringTransactionParams(
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
        id: 'rec_1',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 150.0,
        currency: 'USD',
        description: 'Invalid',
        frequency: RecurringFrequency.monthly,
        startDate: DateTime(2025, 12, 1),
        endDate: DateTime(2025, 1, 1),
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 15),
      );

      // Act
      final result = await useCase(
        UpdateRecurringTransactionParams(
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
        id: 'rec_1',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 150.0,
        currency: 'USD',
        description: 'Invalid',
        frequency: RecurringFrequency.monthly,
        startDate: DateTime(2025, 1, 1),
        maxOccurrences: 0,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 15),
      );

      // Act
      final result = await useCase(
        UpdateRecurringTransactionParams(
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
        id: 'rec_1',
        userId: tUserId,
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 150.0,
        currency: 'USD',
        description: 'Invalid',
        frequency: RecurringFrequency.monthly,
        startDate: DateTime(2025, 1, 1),
        maxOccurrences: -5,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 15),
      );

      // Act
      final result = await useCase(
        UpdateRecurringTransactionParams(
          recurringTransaction: invalidTransaction,
        ),
      );

      // Assert
      expect(result, Left(ValidationFailure('Max occurrences must be greater than zero')));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NotFoundFailure when recurring transaction does not exist', () async {
      // Arrange
      when(mockRepository.updateRecurringTransaction(
        recurringTransaction: anyNamed('recurringTransaction'),
      )).thenAnswer(
        (_) async => Left(NotFoundFailure('Recurring transaction not found')),
      );

      // Act
      final result = await useCase(
        UpdateRecurringTransactionParams(
          recurringTransaction: tRecurringTransaction,
        ),
      );

      // Assert
      expect(result, Left(NotFoundFailure('Recurring transaction not found')));
      verify(mockRepository.updateRecurringTransaction(
        recurringTransaction: tRecurringTransaction,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.updateRecurringTransaction(
        recurringTransaction: anyNamed('recurringTransaction'),
      )).thenAnswer(
        (_) async => Left(ServerFailure('Failed to update recurring transaction')),
      );

      // Act
      final result = await useCase(
        UpdateRecurringTransactionParams(
          recurringTransaction: tRecurringTransaction,
        ),
      );

      // Assert
      expect(result, Left(ServerFailure('Failed to update recurring transaction')));
      verify(mockRepository.updateRecurringTransaction(
        recurringTransaction: tRecurringTransaction,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
