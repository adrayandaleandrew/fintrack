import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/budgets/domain/entities/budget.dart';
import 'package:finance_tracker/features/budgets/domain/repositories/budget_repository.dart';
import 'package:finance_tracker/features/budgets/domain/usecases/get_budgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_budgets_test.mocks.dart';

@GenerateMocks([BudgetRepository])
void main() {
  late GetBudgets useCase;
  late MockBudgetRepository mockRepository;

  setUp(() {
    mockRepository = MockBudgetRepository();
    useCase = GetBudgets(mockRepository);
  });

  group('GetBudgets', () {
    const tUserId = 'user_1';
    final tBudgets = [
      Budget(
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
      ),
      Budget(
        id: 'budget_2',
        userId: tUserId,
        categoryId: 'cat_2',
        amount: 200.0,
        currency: 'USD',
        period: BudgetPeriod.weekly,
        startDate: DateTime(2025, 1, 1),
        alertThreshold: 75.0,
        isActive: true,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      ),
    ];

    test('should get list of budgets from repository', () async {
      // Arrange
      when(mockRepository.getBudgets(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => Right(tBudgets));

      // Act
      final result = await useCase(const GetBudgetsParams(userId: tUserId));

      // Assert
      expect(result, Right(tBudgets));
      verify(mockRepository.getBudgets(
        userId: tUserId,
        activeOnly: false,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get only active budgets when activeOnly is true', () async {
      // Arrange
      final activeBudgets = [tBudgets.first];
      when(mockRepository.getBudgets(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => Right(activeBudgets));

      // Act
      final result = await useCase(
        const GetBudgetsParams(userId: tUserId, activeOnly: true),
      );

      // Assert
      expect(result, Right(activeBudgets));
      verify(mockRepository.getBudgets(
        userId: tUserId,
        activeOnly: true,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no budgets exist', () async {
      // Arrange
      when(mockRepository.getBudgets(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => const Right([]));

      // Act
      final result = await useCase(const GetBudgetsParams(userId: tUserId));

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (budgets) => expect(budgets, isEmpty),
      );
      verify(mockRepository.getBudgets(
        userId: tUserId,
        activeOnly: false,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.getBudgets(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => Left(ServerFailure('Failed to get budgets')));

      // Act
      final result = await useCase(const GetBudgetsParams(userId: tUserId));

      // Assert
      expect(result, Left(ServerFailure('Failed to get budgets')));
      verify(mockRepository.getBudgets(
        userId: tUserId,
        activeOnly: false,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when cache fails', () async {
      // Arrange
      when(mockRepository.getBudgets(
        userId: anyNamed('userId'),
        activeOnly: anyNamed('activeOnly'),
      )).thenAnswer((_) async => Left(CacheFailure('Failed to load from cache')));

      // Act
      final result = await useCase(const GetBudgetsParams(userId: tUserId));

      // Assert
      expect(result, Left(CacheFailure('Failed to load from cache')));
      verify(mockRepository.getBudgets(
        userId: tUserId,
        activeOnly: false,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
