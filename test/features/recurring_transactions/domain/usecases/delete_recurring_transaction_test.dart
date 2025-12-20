import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/recurring_transactions/domain/repositories/recurring_transaction_repository.dart';
import 'package:finance_tracker/features/recurring_transactions/domain/usecases/delete_recurring_transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_recurring_transaction_test.mocks.dart';

@GenerateMocks([RecurringTransactionRepository])
void main() {
  late DeleteRecurringTransaction useCase;
  late MockRecurringTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockRecurringTransactionRepository();
    useCase = DeleteRecurringTransaction(mockRepository);
  });

  group('DeleteRecurringTransaction', () {
    const tRecurringTransactionId = 'rec_1';

    test('should delete recurring transaction successfully', () async {
      // Arrange
      when(mockRepository.deleteRecurringTransaction(
        recurringTransactionId: anyNamed('recurringTransactionId'),
      )).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(
        const DeleteRecurringTransactionParams(
          recurringTransactionId: tRecurringTransactionId,
        ),
      );

      // Assert
      expect(result, const Right(null));
      verify(mockRepository.deleteRecurringTransaction(
        recurringTransactionId: tRecurringTransactionId,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NotFoundFailure when recurring transaction does not exist', () async {
      // Arrange
      when(mockRepository.deleteRecurringTransaction(
        recurringTransactionId: anyNamed('recurringTransactionId'),
      )).thenAnswer(
        (_) async => Left(NotFoundFailure('Recurring transaction not found')),
      );

      // Act
      final result = await useCase(
        const DeleteRecurringTransactionParams(
          recurringTransactionId: tRecurringTransactionId,
        ),
      );

      // Assert
      expect(result, Left(NotFoundFailure('Recurring transaction not found')));
      verify(mockRepository.deleteRecurringTransaction(
        recurringTransactionId: tRecurringTransactionId,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.deleteRecurringTransaction(
        recurringTransactionId: anyNamed('recurringTransactionId'),
      )).thenAnswer(
        (_) async => Left(ServerFailure('Failed to delete recurring transaction')),
      );

      // Act
      final result = await useCase(
        const DeleteRecurringTransactionParams(
          recurringTransactionId: tRecurringTransactionId,
        ),
      );

      // Assert
      expect(result, Left(ServerFailure('Failed to delete recurring transaction')));
      verify(mockRepository.deleteRecurringTransaction(
        recurringTransactionId: tRecurringTransactionId,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when cache fails', () async {
      // Arrange
      when(mockRepository.deleteRecurringTransaction(
        recurringTransactionId: anyNamed('recurringTransactionId'),
      )).thenAnswer(
        (_) async => Left(CacheFailure('Failed to delete from cache')),
      );

      // Act
      final result = await useCase(
        const DeleteRecurringTransactionParams(
          recurringTransactionId: tRecurringTransactionId,
        ),
      );

      // Assert
      expect(result, Left(CacheFailure('Failed to delete from cache')));
      verify(mockRepository.deleteRecurringTransaction(
        recurringTransactionId: tRecurringTransactionId,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
