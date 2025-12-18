import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:finance_tracker/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_transaction_test.mocks.dart';

@GenerateMocks([TransactionRepository])
void main() {
  late DeleteTransaction useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = DeleteTransaction(repository: mockRepository);
  });

  group('DeleteTransaction', () {
    const tTransactionId = 'txn_1';

    test('should delete transaction successfully', () async {
      // Arrange
      when(mockRepository.deleteTransaction(any))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(const DeleteTransactionParams(id: tTransactionId));

      // Assert
      expect(result, const Right(null));
      verify(mockRepository.deleteTransaction(tTransactionId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.deleteTransaction(any))
          .thenAnswer((_) async => Left(ServerFailure('Failed to delete transaction')));

      // Act
      final result = await useCase(const DeleteTransactionParams(id: tTransactionId));

      // Assert
      expect(result, Left(ServerFailure('Failed to delete transaction')));
      verify(mockRepository.deleteTransaction(tTransactionId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NotFoundFailure when transaction does not exist', () async {
      // Arrange
      when(mockRepository.deleteTransaction(any))
          .thenAnswer((_) async => Left(NotFoundFailure('Transaction not found')));

      // Act
      final result = await useCase(const DeleteTransactionParams(id: tTransactionId));

      // Assert
      expect(result, Left(NotFoundFailure('Transaction not found')));
      verify(mockRepository.deleteTransaction(tTransactionId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
