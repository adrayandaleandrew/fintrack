import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/budgets/domain/entities/budget.dart';
import 'package:finance_tracker/features/budgets/domain/repositories/budget_repository.dart';
import 'package:finance_tracker/features/budgets/domain/usecases/create_budget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_budget_test.mocks.dart';

@GenerateMocks([BudgetRepository])
void main() {
  late CreateBudget useCase;
  late MockBudgetRepository mockRepository;

  setUp(() {
    mockRepository = MockBudgetRepository();
    useCase = CreateBudget(mockRepository);
  });

  group('CreateBudget', () {
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
      updatedAt: DateTime(2025, 1, 1),
    );

    test('should create budget successfully', () async {
      // Arrange
      when(mockRepository.createBudget(budget: anyNamed('budget')))
          .thenAnswer((_) async => Right(tBudget));

      // Act
      final result = await useCase(CreateBudgetParams(budget: tBudget));

      // Assert
      expect(result, Right(tBudget));
      verify(mockRepository.createBudget(budget: tBudget));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should create budget with custom alert threshold', () async {
      // Arrange
      final customBudget = Budget(
        id: 'budget_2',
        userId: tUserId,
        categoryId: 'cat_2',
        amount: 1000.0,
        currency: 'USD',
        period: BudgetPeriod.weekly,
        startDate: DateTime(2025, 1, 1),
        alertThreshold: 90.0,
        isActive: true,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      when(mockRepository.createBudget(budget: anyNamed('budget')))
          .thenAnswer((_) async => Right(customBudget));

      // Act
      final result = await useCase(CreateBudgetParams(budget: customBudget));

      // Assert
      expect(result, Right(customBudget));
      verify(mockRepository.createBudget(budget: customBudget));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should create budget with end date', () async {
      // Arrange
      final budgetWithEndDate = Budget(
        id: 'budget_3',
        userId: tUserId,
        categoryId: 'cat_3',
        amount: 300.0,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 12, 31),
        alertThreshold: 75.0,
        isActive: true,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      when(mockRepository.createBudget(budget: anyNamed('budget')))
          .thenAnswer((_) async => Right(budgetWithEndDate));

      // Act
      final result = await useCase(CreateBudgetParams(budget: budgetWithEndDate));

      // Assert
      expect(result, Right(budgetWithEndDate));
      verify(mockRepository.createBudget(budget: budgetWithEndDate));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when amount is zero', () async {
      // Arrange
      final invalidBudget = Budget(
        id: 'budget_4',
        userId: tUserId,
        categoryId: 'cat_1',
        amount: 0.0,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: DateTime(2025, 1, 1),
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      // Act
      final result = await useCase(CreateBudgetParams(budget: invalidBudget));

      // Assert
      expect(result, Left(ValidationFailure('Budget amount must be greater than zero')));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when amount is negative', () async {
      // Arrange
      final invalidBudget = Budget(
        id: 'budget_5',
        userId: tUserId,
        categoryId: 'cat_1',
        amount: -100.0,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: DateTime(2025, 1, 1),
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      // Act
      final result = await useCase(CreateBudgetParams(budget: invalidBudget));

      // Assert
      expect(result, Left(ValidationFailure('Budget amount must be greater than zero')));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when alert threshold is below 0', () async {
      // Arrange
      final invalidBudget = Budget(
        id: 'budget_6',
        userId: tUserId,
        categoryId: 'cat_1',
        amount: 500.0,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: DateTime(2025, 1, 1),
        alertThreshold: -10.0,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      // Act
      final result = await useCase(CreateBudgetParams(budget: invalidBudget));

      // Assert
      expect(result, Left(ValidationFailure('Alert threshold must be between 0 and 100')));
      verifyNever(mockRepository.createBudget(budget: anyNamed('budget')));
    });

    test('should return ValidationFailure when alert threshold is above 100', () async {
      // Arrange
      final invalidBudget = Budget(
        id: 'budget_7',
        userId: tUserId,
        categoryId: 'cat_1',
        amount: 500.0,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: DateTime(2025, 1, 1),
        alertThreshold: 150.0,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      // Act
      final result = await useCase(CreateBudgetParams(budget: invalidBudget));

      // Assert
      expect(result, Left(ValidationFailure('Alert threshold must be between 0 and 100')));
      verifyNever(mockRepository.createBudget(budget: anyNamed('budget')));
    });

    test('should return ValidationFailure when end date is before start date', () async {
      // Arrange
      final invalidBudget = Budget(
        id: 'budget_8',
        userId: tUserId,
        categoryId: 'cat_1',
        amount: 500.0,
        currency: 'USD',
        period: BudgetPeriod.monthly,
        startDate: DateTime(2025, 12, 1),
        endDate: DateTime(2025, 1, 1),
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );

      // Act
      final result = await useCase(CreateBudgetParams(budget: invalidBudget));

      // Assert
      expect(result, Left(ValidationFailure('End date must be after start date')));
      verifyNever(mockRepository.createBudget(budget: anyNamed('budget')));
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.createBudget(budget: anyNamed('budget')))
          .thenAnswer((_) async => Left(ServerFailure('Failed to create budget')));

      // Act
      final result = await useCase(CreateBudgetParams(budget: tBudget));

      // Assert
      expect(result, Left(ServerFailure('Failed to create budget')));
      verify(mockRepository.createBudget(budget: tBudget));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure from repository for duplicate budget', () async {
      // Arrange
      when(mockRepository.createBudget(budget: anyNamed('budget')))
          .thenAnswer((_) async => Left(ValidationFailure(
              'Budget already exists for this category and period')));

      // Act
      final result = await useCase(CreateBudgetParams(budget: tBudget));

      // Assert
      expect(result, Left(ValidationFailure(
          'Budget already exists for this category and period')));
      verify(mockRepository.createBudget(budget: tBudget));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
