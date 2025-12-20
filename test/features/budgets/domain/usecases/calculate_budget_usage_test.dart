import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/budgets/domain/entities/budget.dart';
import 'package:finance_tracker/features/budgets/domain/entities/budget_usage.dart';
import 'package:finance_tracker/features/budgets/domain/repositories/budget_repository.dart';
import 'package:finance_tracker/features/budgets/domain/usecases/calculate_budget_usage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'calculate_budget_usage_test.mocks.dart';

@GenerateMocks([BudgetRepository])
void main() {
  late CalculateBudgetUsage useCase;
  late MockBudgetRepository mockRepository;

  setUp(() {
    mockRepository = MockBudgetRepository();
    useCase = CalculateBudgetUsage(mockRepository);
  });

  group('CalculateBudgetUsage', () {
    const tBudgetId = 'budget_1';
    final tBudget = Budget(
      id: tBudgetId,
      userId: 'user_1',
      categoryId: 'cat_1',
      amount: 500.0,
      currency: 'USD',
      period: BudgetPeriod.monthly,
      startDate: DateTime(2025, 1, 1),
      alertThreshold: 80.0,
      isActive: true,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    );

    final tBudgetUsage = BudgetUsage(
      budget: tBudget,
      spent: 250.0,
      periodStart: DateTime(2025, 1, 1),
      periodEnd: DateTime(2025, 1, 31),
    );

    test('should calculate budget usage successfully', () async {
      // Arrange
      when(mockRepository.calculateBudgetUsage(budgetId: anyNamed('budgetId')))
          .thenAnswer((_) async => Right(tBudgetUsage));

      // Act
      final result = await useCase(
        const CalculateBudgetUsageParams(budgetId: tBudgetId),
      );

      // Assert
      expect(result, Right(tBudgetUsage));
      verify(mockRepository.calculateBudgetUsage(budgetId: tBudgetId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should calculate usage when spent is zero', () async {
      // Arrange
      final zeroUsage = BudgetUsage(
        budget: tBudget,
        spent: 0.0,
        periodStart: DateTime(2025, 1, 1),
        periodEnd: DateTime(2025, 1, 31),
      );

      when(mockRepository.calculateBudgetUsage(budgetId: anyNamed('budgetId')))
          .thenAnswer((_) async => Right(zeroUsage));

      // Act
      final result = await useCase(
        const CalculateBudgetUsageParams(budgetId: tBudgetId),
      );

      // Assert
      expect(result, Right(zeroUsage));
      verify(mockRepository.calculateBudgetUsage(budgetId: tBudgetId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should calculate usage when budget is exceeded', () async {
      // Arrange
      final exceededUsage = BudgetUsage(
        budget: tBudget,
        spent: 600.0,
        periodStart: DateTime(2025, 1, 1),
        periodEnd: DateTime(2025, 1, 31),
      );

      when(mockRepository.calculateBudgetUsage(budgetId: anyNamed('budgetId')))
          .thenAnswer((_) async => Right(exceededUsage));

      // Act
      final result = await useCase(
        const CalculateBudgetUsageParams(budgetId: tBudgetId),
      );

      // Assert
      expect(result, Right(exceededUsage));
      verify(mockRepository.calculateBudgetUsage(budgetId: tBudgetId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should calculate usage when alert threshold is reached', () async {
      // Arrange
      final alertUsage = BudgetUsage(
        budget: tBudget,
        spent: 400.0, // 80% of 500
        periodStart: DateTime(2025, 1, 1),
        periodEnd: DateTime(2025, 1, 31),
      );

      when(mockRepository.calculateBudgetUsage(budgetId: anyNamed('budgetId')))
          .thenAnswer((_) async => Right(alertUsage));

      // Act
      final result = await useCase(
        const CalculateBudgetUsageParams(budgetId: tBudgetId),
      );

      // Assert
      expect(result, Right(alertUsage));
      verify(mockRepository.calculateBudgetUsage(budgetId: tBudgetId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NotFoundFailure when budget does not exist', () async {
      // Arrange
      when(mockRepository.calculateBudgetUsage(budgetId: anyNamed('budgetId')))
          .thenAnswer((_) async => Left(NotFoundFailure('Budget not found')));

      // Act
      final result = await useCase(
        const CalculateBudgetUsageParams(budgetId: tBudgetId),
      );

      // Assert
      expect(result, Left(NotFoundFailure('Budget not found')));
      verify(mockRepository.calculateBudgetUsage(budgetId: tBudgetId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.calculateBudgetUsage(budgetId: anyNamed('budgetId')))
          .thenAnswer((_) async => Left(ServerFailure('Failed to calculate budget usage')));

      // Act
      final result = await useCase(
        const CalculateBudgetUsageParams(budgetId: tBudgetId),
      );

      // Assert
      expect(result, Left(ServerFailure('Failed to calculate budget usage')));
      verify(mockRepository.calculateBudgetUsage(budgetId: tBudgetId));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when cache fails', () async {
      // Arrange
      when(mockRepository.calculateBudgetUsage(budgetId: anyNamed('budgetId')))
          .thenAnswer((_) async => Left(CacheFailure('Failed to load from cache')));

      // Act
      final result = await useCase(
        const CalculateBudgetUsageParams(budgetId: tBudgetId),
      );

      // Assert
      expect(result, Left(CacheFailure('Failed to load from cache')));
      verify(mockRepository.calculateBudgetUsage(budgetId: tBudgetId));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
