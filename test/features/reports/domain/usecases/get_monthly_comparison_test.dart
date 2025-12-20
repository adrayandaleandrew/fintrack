import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/reports/domain/entities/monthly_comparison.dart';
import 'package:finance_tracker/features/reports/domain/repositories/reports_repository.dart';
import 'package:finance_tracker/features/reports/domain/usecases/get_monthly_comparison.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_monthly_comparison_test.mocks.dart';

@GenerateMocks([ReportsRepository])
void main() {
  late GetMonthlyComparison useCase;
  late MockReportsRepository mockRepository;

  setUp(() {
    mockRepository = MockReportsRepository();
    useCase = GetMonthlyComparison(mockRepository);
  });

  group('GetMonthlyComparison', () {
    const tUserId = 'user_1';
    const tMonthCount = 6;
    const tCurrencyCode = 'USD';

    final tMonthlyData = [
      MonthlyComparisonData(
        year: 2025,
        month: 1,
        income: 5000.0,
        expense: 3000.0,
        net: 2000.0,
        transactionCount: 25,
      ),
      MonthlyComparisonData(
        year: 2025,
        month: 2,
        income: 5500.0,
        expense: 3500.0,
        net: 2000.0,
        transactionCount: 28,
      ),
      MonthlyComparisonData(
        year: 2025,
        month: 3,
        income: 6000.0,
        expense: 4000.0,
        net: 2000.0,
        transactionCount: 30,
      ),
      MonthlyComparisonData(
        year: 2025,
        month: 4,
        income: 5200.0,
        expense: 3200.0,
        net: 2000.0,
        transactionCount: 26,
      ),
      MonthlyComparisonData(
        year: 2025,
        month: 5,
        income: 5800.0,
        expense: 3800.0,
        net: 2000.0,
        transactionCount: 29,
      ),
      MonthlyComparisonData(
        year: 2025,
        month: 6,
        income: 6200.0,
        expense: 4200.0,
        net: 2000.0,
        transactionCount: 31,
      ),
    ];

    final tMonthlyComparison = MonthlyComparison(
      months: tMonthlyData,
      currencyCode: tCurrencyCode,
    );

    test('should get monthly comparison from repository', () async {
      // Arrange
      when(mockRepository.getMonthlyComparison(
        userId: anyNamed('userId'),
        monthCount: anyNamed('monthCount'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Right(tMonthlyComparison));

      // Act
      final result = await useCase(const GetMonthlyComparisonParams(
        userId: tUserId,
        monthCount: tMonthCount,
        currencyCode: tCurrencyCode,
      ));

      // Assert
      expect(result, Right(tMonthlyComparison));
      verify(mockRepository.getMonthlyComparison(
        userId: tUserId,
        monthCount: tMonthCount,
        currencyCode: tCurrencyCode,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get monthly comparison with default values', () async {
      // Arrange
      when(mockRepository.getMonthlyComparison(
        userId: anyNamed('userId'),
        monthCount: anyNamed('monthCount'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Right(tMonthlyComparison));

      // Act
      final result = await useCase(const GetMonthlyComparisonParams(
        userId: tUserId,
      ));

      // Assert
      expect(result, Right(tMonthlyComparison));
      verify(mockRepository.getMonthlyComparison(
        userId: tUserId,
        monthCount: 6,
        currencyCode: 'USD',
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get monthly comparison for 3 months', () async {
      // Arrange
      when(mockRepository.getMonthlyComparison(
        userId: anyNamed('userId'),
        monthCount: anyNamed('monthCount'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Right(tMonthlyComparison));

      // Act
      final result = await useCase(const GetMonthlyComparisonParams(
        userId: tUserId,
        monthCount: 3,
      ));

      // Assert
      expect(result, Right(tMonthlyComparison));
      verify(mockRepository.getMonthlyComparison(
        userId: tUserId,
        monthCount: 3,
        currencyCode: 'USD',
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get monthly comparison for 12 months', () async {
      // Arrange
      when(mockRepository.getMonthlyComparison(
        userId: anyNamed('userId'),
        monthCount: anyNamed('monthCount'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Right(tMonthlyComparison));

      // Act
      final result = await useCase(const GetMonthlyComparisonParams(
        userId: tUserId,
        monthCount: 12,
      ));

      // Assert
      expect(result, Right(tMonthlyComparison));
      verify(mockRepository.getMonthlyComparison(
        userId: tUserId,
        monthCount: 12,
        currencyCode: 'USD',
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when month count is less than 1', () async {
      // Act
      final result = await useCase(const GetMonthlyComparisonParams(
        userId: tUserId,
        monthCount: 0,
      ));

      // Assert
      expect(result, Left(ValidationFailure('Month count must be at least 1')));
      verifyNever(mockRepository.getMonthlyComparison(
        userId: anyNamed('userId'),
        monthCount: anyNamed('monthCount'),
        currencyCode: anyNamed('currencyCode'),
      ));
    });

    test('should return ValidationFailure when month count is negative', () async {
      // Act
      final result = await useCase(const GetMonthlyComparisonParams(
        userId: tUserId,
        monthCount: -5,
      ));

      // Assert
      expect(result, Left(ValidationFailure('Month count must be at least 1')));
      verifyNever(mockRepository.getMonthlyComparison(
        userId: anyNamed('userId'),
        monthCount: anyNamed('monthCount'),
        currencyCode: anyNamed('currencyCode'),
      ));
    });

    test('should return ValidationFailure when month count exceeds 24', () async {
      // Act
      final result = await useCase(const GetMonthlyComparisonParams(
        userId: tUserId,
        monthCount: 25,
      ));

      // Assert
      expect(result, Left(ValidationFailure('Month count cannot exceed 24')));
      verifyNever(mockRepository.getMonthlyComparison(
        userId: anyNamed('userId'),
        monthCount: anyNamed('monthCount'),
        currencyCode: anyNamed('currencyCode'),
      ));
    });

    test('should accept month count of 24 (boundary)', () async {
      // Arrange
      when(mockRepository.getMonthlyComparison(
        userId: anyNamed('userId'),
        monthCount: anyNamed('monthCount'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Right(tMonthlyComparison));

      // Act
      final result = await useCase(const GetMonthlyComparisonParams(
        userId: tUserId,
        monthCount: 24,
      ));

      // Assert
      expect(result, Right(tMonthlyComparison));
      verify(mockRepository.getMonthlyComparison(
        userId: tUserId,
        monthCount: 24,
        currencyCode: 'USD',
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should accept month count of 1 (boundary)', () async {
      // Arrange
      when(mockRepository.getMonthlyComparison(
        userId: anyNamed('userId'),
        monthCount: anyNamed('monthCount'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Right(tMonthlyComparison));

      // Act
      final result = await useCase(const GetMonthlyComparisonParams(
        userId: tUserId,
        monthCount: 1,
      ));

      // Assert
      expect(result, Right(tMonthlyComparison));
      verify(mockRepository.getMonthlyComparison(
        userId: tUserId,
        monthCount: 1,
        currencyCode: 'USD',
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.getMonthlyComparison(
        userId: anyNamed('userId'),
        monthCount: anyNamed('monthCount'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Left(ServerFailure('Failed to get monthly comparison')));

      // Act
      final result = await useCase(const GetMonthlyComparisonParams(
        userId: tUserId,
      ));

      // Assert
      expect(result, Left(ServerFailure('Failed to get monthly comparison')));
      verify(mockRepository.getMonthlyComparison(
        userId: tUserId,
        monthCount: 6,
        currencyCode: 'USD',
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when cache fails', () async {
      // Arrange
      when(mockRepository.getMonthlyComparison(
        userId: anyNamed('userId'),
        monthCount: anyNamed('monthCount'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Left(CacheFailure('Failed to load from cache')));

      // Act
      final result = await useCase(const GetMonthlyComparisonParams(
        userId: tUserId,
      ));

      // Assert
      expect(result, Left(CacheFailure('Failed to load from cache')));
      verify(mockRepository.getMonthlyComparison(
        userId: tUserId,
        monthCount: 6,
        currencyCode: 'USD',
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
