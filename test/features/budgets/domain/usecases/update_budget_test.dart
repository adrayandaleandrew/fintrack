import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/budgets/domain/entities/budget.dart';
import 'package:finance_tracker/features/budgets/domain/repositories/budget_repository.dart';
import 'package:finance_tracker/features/budgets/domain/usecases/update_budget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_budget_test.mocks.dart';

@GenerateMocks([BudgetRepository])
void main() {
  late UpdateBudget useCase;
  late MockBudgetRepository mockRepository;

  setUp(() {
    mockRepository = MockBudgetRepository();
    useCase = UpdateBudget(mockRepository);
  });

  group('UpdateBudget', () {
    const tUserId = 'user_1';
    final tBudget = Budget(
      id: 'budget_1',
      userId: tUserId,
      categoryId: 'cat_1',
      amount: 500.0,
      currency: 'USD',
      period: BudgetPeriod.monthly,
      startDate: DateTime(2025, 1, 1),
      alertThreshold: 80.0,
      isActive: true,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 15),
    );

    test('should update budget successfully', () async {
      // Arrange
      when(mockRepository.updateBudget(budget: anyNamed('budget')))
          .thenAnswer((_) async => Right(tBudget));

      // Act
      final result = await useCase(UpdateBudgetParams(budget: tBudget));

      // Assert
      expect(result, Right(tBudget));
      verify(mockRepository.updateBudget(budget: tBudget));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should update budget amount', () async {
      // Arrange
      final updatedBudget = Budget(
        id: 'budget_1',
        userId: tUserId,
        categoryId: 'cat_1',
        amount: 1000.0,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: DateTime(2025, 1, 1),
        alertThreshold: 80.0,
        isActive: true,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 15),
      );

      when(mockRepository.updateBudget(budget: anyNamed('budget')))
          .thenAnswer((_) async => Right(updatedBudget));

      // Act
      final result = await useCase(UpdateBudgetParams(budget: updatedBudget));

      // Assert
      expect(result, Right(updatedBudget));
      verify(mockRepository.updateBudget(budget: updatedBudget));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should update alert threshold', () async {
      // Arrange
      final updatedBudget = Budget(
        id: 'budget_1',
        userId: tUserId,
        categoryId: 'cat_1',
        amount: 500.0,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: DateTime(2025, 1, 1),
        alertThreshold: 90.0,
        isActive: true,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 15),
      );

      when(mockRepository.updateBudget(budget: anyNamed('budget')))
          .thenAnswer((_) async => Right(updatedBudget));

      // Act
      final result = await useCase(UpdateBudgetParams(budget: updatedBudget));

      // Assert
      expect(result, Right(updatedBudget));
      verify(mockRepository.updateBudget(budget: updatedBudget));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should deactivate budget', () async {
      // Arrange
      final inactiveBudget = Budget(
        id: 'budget_1',
        userId: tUserId,
        categoryId: 'cat_1',
        amount: 500.0,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: DateTime(2025, 1, 1),
        alertThreshold: 80.0,
        isActive: false,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 15),
      );

      when(mockRepository.updateBudget(budget: anyNamed('budget')))
          .thenAnswer((_) async => Right(inactiveBudget));

      // Act
      final result = await useCase(UpdateBudgetParams(budget: inactiveBudget));

      // Assert
      expect(result, Right(inactiveBudget));
      verify(mockRepository.updateBudget(budget: inactiveBudget));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when amount is zero', () async {
      // Arrange
      final invalidBudget = Budget(
        id: 'budget_1',
        userId: tUserId,
        categoryId: 'cat_1',
        amount: 0.0,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: DateTime(2025, 1, 1),
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 15),
      );

      // Act
      final result = await useCase(UpdateBudgetParams(budget: invalidBudget));

      // Assert
      expect(result, Left(ValidationFailure('Budget amount must be greater than zero')));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when amount is negative', () async {
      // Arrange
      final invalidBudget = Budget(
        id: 'budget_1',
        userId: tUserId,
        categoryId: 'cat_1',
        amount: -100.0,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: DateTime(2025, 1, 1),
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 15),
      );

      // Act
      final result = await useCase(UpdateBudgetParams(budget: invalidBudget));

      // Assert
      expect(result, Left(ValidationFailure('Budget amount must be greater than zero')));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when alert threshold is below 0', () async {
      // Arrange
      final invalidBudget = Budget(
        id: 'budget_1',
        userId: tUserId,
        categoryId: 'cat_1',
        amount: 500.0,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: DateTime(2025, 1, 1),
        alertThreshold: -10.0,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 15),
      );

      // Act
      final result = await useCase(UpdateBudgetParams(budget: invalidBudget));

      // Assert
      expect(result, Left(ValidationFailure('Alert threshold must be between 0 and 100')));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when alert threshold is above 100', () async {
      // Arrange
      final invalidBudget = Budget(
        id: 'budget_1',
        userId: tUserId,
        categoryId: 'cat_1',
        amount: 500.0,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: DateTime(2025, 1, 1),
        alertThreshold: 150.0,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 15),
      );

      // Act
      final result = await useCase(UpdateBudgetParams(budget: invalidBudget));

      // Assert
      expect(result, Left(ValidationFailure('Alert threshold must be between 0 and 100')));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when end date is before start date', () async {
      // Arrange
      final invalidBudget = Budget(
        id: 'budget_1',
        userId: tUserId,
        categoryId: 'cat_1',
        amount: 500.0,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: DateTime(2025, 12, 1),
        endDate: DateTime(2025, 1, 1),
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 15),
      );

      // Act
      final result = await useCase(UpdateBudgetParams(budget: invalidBudget));

      // Assert
      expect(result, Left(ValidationFailure('End date must be after start date')));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NotFoundFailure when budget does not exist', () async {
      // Arrange
      when(mockRepository.updateBudget(budget: anyNamed('budget')))
          .thenAnswer((_) async => Left(NotFoundFailure('Budget not found')));

      // Act
      final result = await useCase(UpdateBudgetParams(budget: tBudget));

      // Assert
      expect(result, Left(NotFoundFailure('Budget not found')));
      verify(mockRepository.updateBudget(budget: tBudget));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.updateBudget(budget: anyNamed('budget')))
          .thenAnswer((_) async => Left(ServerFailure('Failed to update budget')));

      // Act
      final result = await useCase(UpdateBudgetParams(budget: tBudget));

      // Assert
      expect(result, Left(ServerFailure('Failed to update budget')));
      verify(mockRepository.updateBudget(budget: tBudget));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
