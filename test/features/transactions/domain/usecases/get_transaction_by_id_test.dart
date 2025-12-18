import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/transactions/domain/entities/transaction.dart';
import 'package:finance_tracker/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finance_tracker/features/transactions/domain/usecases/get_transaction_by_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_transaction_by_id_test.mocks.dart';

@GenerateMocks([TransactionRepository])
void main() {
  late GetTransactionById useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = GetTransactionById(repository: mockRepository);
  });

  group('GetTransactionById', () {
    const tTransactionId = 'txn_1';
    final tTransaction = Transaction(
      id: tTransactionId,
      userId: 'user_1',
      accountId: 'acc_1',
      categoryId: 'cat_1',
      type: TransactionType.expense,
      amount: 100.0,
      currency: 'USD',
      description: 'Groceries',
      date: DateTime(2025, 12, 1),
      createdAt: DateTime(2025, 12, 1),
      updatedAt: DateTime(2025, 12, 1),
    );

    test('should get transaction by ID from repository', () async {
      // Arrange
      when(mockRepository.getTransactionById(any))
          .thenAnswer((_) async => Right(tTransaction));

      // Act
      final result = await useCase(const GetTransactionByIdParams(id: tTransactionId));

      // Assert
      expect(result, Right(tTransaction));
      verify(mockRepository.getTransactionById(tTransactionId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NotFoundFailure when transaction does not exist', () async {
      // Arrange
      when(mockRepository.getTransactionById(any))
          .thenAnswer((_) async => Left(NotFoundFailure('Transaction not found')));

      // Act
      final result = await useCase(const GetTransactionByIdParams(id: tTransactionId));

      // Assert
      expect(result, Left(NotFoundFailure('Transaction not found')));
      verify(mockRepository.getTransactionById(tTransactionId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.getTransactionById(any))
          .thenAnswer((_) async => Left(ServerFailure('Server error')));

      // Act
      final result = await useCase(const GetTransactionByIdParams(id: tTransactionId));

      // Assert
      expect(result, Left(ServerFailure('Server error')));
      verify(mockRepository.getTransactionById(tTransactionId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
