import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/budgets/domain/repositories/budget_repository.dart';
import 'package:finance_tracker/features/budgets/domain/usecases/delete_budget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_budget_test.mocks.dart';

@GenerateMocks([BudgetRepository])
void main() {
  late DeleteBudget useCase;
  late MockBudgetRepository mockRepository;

  setUp(() {
    mockRepository = MockBudgetRepository();
    useCase = DeleteBudget(mockRepository);
  });

  group('DeleteBudget', () {
    const tBudgetId = 'budget_1';

    test('should delete budget successfully', () async {
      // Arrange
      when(mockRepository.deleteBudget(budgetId: anyNamed('budgetId')))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(const DeleteBudgetParams(budgetId: tBudgetId));

      // Assert
      expect(result, const Right(null));
      verify(mockRepository.deleteBudget(budgetId: tBudgetId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NotFoundFailure when budget does not exist', () async {
      // Arrange
      when(mockRepository.deleteBudget(budgetId: anyNamed('budgetId')))
          .thenAnswer((_) async => Left(NotFoundFailure('Budget not found')));

      // Act
      final result = await useCase(const DeleteBudgetParams(budgetId: tBudgetId));

      // Assert
      expect(result, Left(NotFoundFailure('Budget not found')));
      verify(mockRepository.deleteBudget(budgetId: tBudgetId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.deleteBudget(budgetId: anyNamed('budgetId')))
          .thenAnswer((_) async => Left(ServerFailure('Failed to delete budget')));

      // Act
      final result = await useCase(const DeleteBudgetParams(budgetId: tBudgetId));

      // Assert
      expect(result, Left(ServerFailure('Failed to delete budget')));
      verify(mockRepository.deleteBudget(budgetId: tBudgetId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when cache fails', () async {
      // Arrange
      when(mockRepository.deleteBudget(budgetId: anyNamed('budgetId')))
          .thenAnswer((_) async => Left(CacheFailure('Failed to delete from cache')));

      // Act
      final result = await useCase(const DeleteBudgetParams(budgetId: tBudgetId));

      // Assert
      expect(result, Left(CacheFailure('Failed to delete from cache')));
      verify(mockRepository.deleteBudget(budgetId: tBudgetId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
