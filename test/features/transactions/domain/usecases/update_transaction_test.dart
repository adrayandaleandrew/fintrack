import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:finance_tracker/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finance_tracker/features/transactions/domain/usecases/update_transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_transaction_test.mocks.dart';

@GenerateMocks([TransactionRepository])
void main() {
  late UpdateTransaction useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = UpdateTransaction(repository: mockRepository);
  });

  group('UpdateTransaction', () {
    final tTransaction = Transaction(
      id: 'txn_1',
      userId: 'user_1',
      accountId: 'acc_1',
      categoryId: 'cat_1',
      type: TransactionType.expense,
      amount: 150.0,
      currency: 'USD',
      description: 'Updated Groceries',
      date: DateTime(2025, 12, 1),
      createdAt: DateTime(2025, 12, 1),
      updatedAt: DateTime(2025, 12, 1),
    );

    test('should update transaction successfully', () async {
      // Arrange
      when(mockRepository.updateTransaction(any))
          .thenAnswer((_) async => Right(tTransaction));

      // Act
      final result = await useCase(UpdateTransactionParams(transaction: tTransaction));

      // Assert
      expect(result, Right(tTransaction));
      verify(mockRepository.updateTransaction(tTransaction));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when amount is zero', () async {
      // Arrange
      final invalidTransaction = Transaction(
        id: 'txn_1',
        userId: 'user_1',
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 0.0,
        currency: 'USD',
        description: 'Test',
        date: DateTime(2025, 12, 1),
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      );

      // Act
      final result = await useCase(UpdateTransactionParams(transaction: invalidTransaction));

      // Assert
      expect(result, Left(ValidationFailure('Amount must be greater than 0')));
      verifyZeroInteractions(mockRepository);
    });

    test('should return ValidationFailure when amount is negative', () async {
      // Arrange
      final invalidTransaction = Transaction(
        id: 'txn_1',
        userId: 'user_1',
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: -50.0,
        currency: 'USD',
        description: 'Test',
        date: DateTime(2025, 12, 1),
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      );

      // Act
      final result = await useCase(UpdateTransactionParams(transaction: invalidTransaction));

      // Assert
      expect(result, Left(ValidationFailure('Amount must be greater than 0')));
      verifyZeroInteractions(mockRepository);
    });

    test('should return ValidationFailure when description is empty', () async {
      // Arrange
      final invalidTransaction = Transaction(
        id: 'txn_1',
        userId: 'user_1',
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 100.0,
        currency: 'USD',
        description: '',
        date: DateTime(2025, 12, 1),
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      );

      // Act
      final result = await useCase(UpdateTransactionParams(transaction: invalidTransaction));

      // Assert
      expect(result, Left(ValidationFailure('Description cannot be empty')));
      verifyZeroInteractions(mockRepository);
    });

    test('should return ValidationFailure when description is only whitespace', () async {
      // Arrange
      final invalidTransaction = Transaction(
        id: 'txn_1',
        userId: 'user_1',
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.expense,
        amount: 100.0,
        currency: 'USD',
        description: '   ',
        date: DateTime(2025, 12, 1),
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      );

      // Act
      final result = await useCase(UpdateTransactionParams(transaction: invalidTransaction));

      // Assert
      expect(result, Left(ValidationFailure('Description cannot be empty')));
      verifyZeroInteractions(mockRepository);
    });

    test('should return ValidationFailure when transfer has no destination account', () async {
      // Arrange
      final invalidTransfer = Transaction(
        id: 'txn_1',
        userId: 'user_1',
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.transfer,
        amount: 100.0,
        currency: 'USD',
        description: 'Transfer',
        date: DateTime(2025, 12, 1),
        toAccountId: null,
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      );

      // Act
      final result = await useCase(UpdateTransactionParams(transaction: invalidTransfer));

      // Assert
      expect(result, Left(ValidationFailure('Destination account is required for transfers')));
      verifyZeroInteractions(mockRepository);
    });

    test('should return ValidationFailure when transfer to same account', () async {
      // Arrange
      final invalidTransfer = Transaction(
        id: 'txn_1',
        userId: 'user_1',
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.transfer,
        amount: 100.0,
        currency: 'USD',
        description: 'Transfer',
        date: DateTime(2025, 12, 1),
        toAccountId: 'acc_1', // Same as accountId
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      );

      // Act
      final result = await useCase(UpdateTransactionParams(transaction: invalidTransfer));

      // Assert
      expect(result, Left(ValidationFailure('Cannot transfer to the same account')));
      verifyZeroInteractions(mockRepository);
    });

    test('should update transfer successfully when valid', () async {
      // Arrange
      final validTransfer = Transaction(
        id: 'txn_1',
        userId: 'user_1',
        accountId: 'acc_1',
        categoryId: 'cat_1',
        type: TransactionType.transfer,
        amount: 200.0,
        currency: 'USD',
        description: 'Updated transfer',
        date: DateTime(2025, 12, 1),
        toAccountId: 'acc_2', // Different account
        createdAt: DateTime(2025, 12, 1),
        updatedAt: DateTime(2025, 12, 1),
      );

      when(mockRepository.updateTransaction(any))
          .thenAnswer((_) async => Right(validTransfer));

      // Act
      final result = await useCase(UpdateTransactionParams(transaction: validTransfer));

      // Assert
      expect(result, Right(validTransfer));
      verify(mockRepository.updateTransaction(validTransfer));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.updateTransaction(any))
          .thenAnswer((_) async => Left(ServerFailure('Failed to update transaction')));

      // Act
      final result = await useCase(UpdateTransactionParams(transaction: tTransaction));

      // Assert
      expect(result, Left(ServerFailure('Failed to update transaction')));
      verify(mockRepository.updateTransaction(tTransaction));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NotFoundFailure when transaction does not exist', () async {
      // Arrange
      when(mockRepository.updateTransaction(any))
          .thenAnswer((_) async => Left(NotFoundFailure('Transaction not found')));

      // Act
      final result = await useCase(UpdateTransactionParams(transaction: tTransaction));

      // Assert
      expect(result, Left(NotFoundFailure('Transaction not found')));
      verify(mockRepository.updateTransaction(tTransaction));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
