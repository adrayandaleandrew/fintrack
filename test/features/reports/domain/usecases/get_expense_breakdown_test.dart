import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/reports/domain/entities/category_expense.dart';
import 'package:finance_tracker/features/reports/domain/entities/expense_breakdown.dart';
import 'package:finance_tracker/features/reports/domain/repositories/reports_repository.dart';
import 'package:finance_tracker/features/reports/domain/usecases/get_expense_breakdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_expense_breakdown_test.mocks.dart';

@GenerateMocks([ReportsRepository])
void main() {
  late GetExpenseBreakdown useCase;
  late MockReportsRepository mockRepository;

  setUp(() {
    mockRepository = MockReportsRepository();
    useCase = GetExpenseBreakdown(mockRepository);
  });

  group('GetExpenseBreakdown', () {
    const tUserId = 'user_1';
    final tStartDate = DateTime(2025, 1, 1);
    final tEndDate = DateTime(2025, 1, 31);
    const tCurrencyCode = 'USD';

    final tCategoryExpenses = [
      const CategoryExpense(
        categoryId: 'cat_1',
        categoryName: 'Food',
        categoryIcon: 'restaurant',
        categoryColor: '#FF6B6B',
        amount: 500.0,
        transactionCount: 10,
        percentage: 50.0,
      ),
      const CategoryExpense(
        categoryId: 'cat_2',
        categoryName: 'Transport',
        categoryIcon: 'directions_car',
        categoryColor: '#4ECDC4',
        amount: 300.0,
        transactionCount: 5,
        percentage: 30.0,
      ),
      const CategoryExpense(
        categoryId: 'cat_3',
        categoryName: 'Entertainment',
        categoryIcon: 'movie',
        categoryColor: '#95E1D3',
        amount: 200.0,
        transactionCount: 3,
        percentage: 20.0,
      ),
    ];

    final tExpenseBreakdown = ExpenseBreakdown(
      categoryExpenses: tCategoryExpenses,
      totalExpense: 1000.0,
      startDate: tStartDate,
      endDate: tEndDate,
      currencyCode: tCurrencyCode,
    );

    test('should get expense breakdown from repository', () async {
      // Arrange
      when(mockRepository.getExpenseBreakdown(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Right(tExpenseBreakdown));

      // Act
      final result = await useCase(GetExpenseBreakdownParams(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        currencyCode: tCurrencyCode,
      ));

      // Assert
      expect(result, Right(tExpenseBreakdown));
      verify(mockRepository.getExpenseBreakdown(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        currencyCode: tCurrencyCode,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get expense breakdown with default currency', () async {
      // Arrange
      when(mockRepository.getExpenseBreakdown(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Right(tExpenseBreakdown));

      // Act
      final result = await useCase(GetExpenseBreakdownParams(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
      ));

      // Assert
      expect(result, Right(tExpenseBreakdown));
      verify(mockRepository.getExpenseBreakdown(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        currencyCode: 'USD',
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get empty expense breakdown when no data', () async {
      // Arrange
      final emptyBreakdown = ExpenseBreakdown(
        categoryExpenses: const [],
        totalExpense: 0.0,
        startDate: tStartDate,
        endDate: tEndDate,
        currencyCode: tCurrencyCode,
      );

      when(mockRepository.getExpenseBreakdown(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Right(emptyBreakdown));

      // Act
      final result = await useCase(GetExpenseBreakdownParams(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
      ));

      // Assert
      expect(result, Right(emptyBreakdown));
      verify(mockRepository.getExpenseBreakdown(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        currencyCode: 'USD',
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when end date is before start date', () async {
      // Arrange
      final invalidEndDate = DateTime(2024, 12, 31);

      // Act
      final result = await useCase(GetExpenseBreakdownParams(
        userId: tUserId,
        startDate: tStartDate,
        endDate: invalidEndDate,
      ));

      // Assert
      expect(result, Left(ValidationFailure('End date must be after start date')));
      verifyNever(mockRepository.getExpenseBreakdown(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        currencyCode: anyNamed('currencyCode'),
      ));
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.getExpenseBreakdown(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Left(ServerFailure('Failed to get expense breakdown')));

      // Act
      final result = await useCase(GetExpenseBreakdownParams(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
      ));

      // Assert
      expect(result, Left(ServerFailure('Failed to get expense breakdown')));
      verify(mockRepository.getExpenseBreakdown(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        currencyCode: 'USD',
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when cache fails', () async {
      // Arrange
      when(mockRepository.getExpenseBreakdown(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Left(CacheFailure('Failed to load from cache')));

      // Act
      final result = await useCase(GetExpenseBreakdownParams(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
      ));

      // Assert
      expect(result, Left(CacheFailure('Failed to load from cache')));
      verify(mockRepository.getExpenseBreakdown(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        currencyCode: 'USD',
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
