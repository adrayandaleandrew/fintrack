import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/reports/domain/entities/financial_trends.dart';
import 'package:finance_tracker/features/reports/domain/entities/trend_data_point.dart';
import 'package:finance_tracker/features/reports/domain/repositories/reports_repository.dart';
import 'package:finance_tracker/features/reports/domain/usecases/get_financial_trends.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_financial_trends_test.mocks.dart';

@GenerateMocks([ReportsRepository])
void main() {
  late GetFinancialTrends useCase;
  late MockReportsRepository mockRepository;

  setUp(() {
    mockRepository = MockReportsRepository();
    useCase = GetFinancialTrends(mockRepository);
  });

  group('GetFinancialTrends', () {
    const tUserId = 'user_1';
    final tStartDate = DateTime(2025, 1, 1);
    final tEndDate = DateTime(2025, 3, 31);
    const tGroupBy = 'month';
    const tCurrencyCode = 'USD';

    final tDataPoints = [
      TrendDataPoint(
        date: DateTime(2025, 1, 1),
        income: 5000.0,
        expense: 3000.0,
        net: 2000.0,
      ),
      TrendDataPoint(
        date: DateTime(2025, 2, 1),
        income: 5500.0,
        expense: 3500.0,
        net: 2000.0,
      ),
      TrendDataPoint(
        date: DateTime(2025, 3, 1),
        income: 6000.0,
        expense: 4000.0,
        net: 2000.0,
      ),
    ];

    final tFinancialTrends = FinancialTrends(
      dataPoints: tDataPoints,
      startDate: tStartDate,
      endDate: tEndDate,
      currencyCode: tCurrencyCode,
    );

    test('should get financial trends from repository', () async {
      // Arrange
      when(mockRepository.getFinancialTrends(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        groupBy: anyNamed('groupBy'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Right(tFinancialTrends));

      // Act
      final result = await useCase(GetFinancialTrendsParams(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        groupBy: tGroupBy,
        currencyCode: tCurrencyCode,
      ));

      // Assert
      expect(result, Right(tFinancialTrends));
      verify(mockRepository.getFinancialTrends(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        groupBy: tGroupBy,
        currencyCode: tCurrencyCode,
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get financial trends with default values', () async {
      // Arrange
      when(mockRepository.getFinancialTrends(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        groupBy: anyNamed('groupBy'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Right(tFinancialTrends));

      // Act
      final result = await useCase(GetFinancialTrendsParams(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
      ));

      // Assert
      expect(result, Right(tFinancialTrends));
      verify(mockRepository.getFinancialTrends(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        groupBy: 'month',
        currencyCode: 'USD',
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get financial trends grouped by day', () async {
      // Arrange
      when(mockRepository.getFinancialTrends(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        groupBy: anyNamed('groupBy'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Right(tFinancialTrends));

      // Act
      final result = await useCase(GetFinancialTrendsParams(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        groupBy: 'day',
      ));

      // Assert
      expect(result, Right(tFinancialTrends));
      verify(mockRepository.getFinancialTrends(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        groupBy: 'day',
        currencyCode: 'USD',
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should get financial trends grouped by week', () async {
      // Arrange
      when(mockRepository.getFinancialTrends(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        groupBy: anyNamed('groupBy'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Right(tFinancialTrends));

      // Act
      final result = await useCase(GetFinancialTrendsParams(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        groupBy: 'week',
      ));

      // Assert
      expect(result, Right(tFinancialTrends));
      verify(mockRepository.getFinancialTrends(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        groupBy: 'week',
        currencyCode: 'USD',
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ValidationFailure when end date is before start date', () async {
      // Arrange
      final invalidEndDate = DateTime(2024, 12, 31);

      // Act
      final result = await useCase(GetFinancialTrendsParams(
        userId: tUserId,
        startDate: tStartDate,
        endDate: invalidEndDate,
      ));

      // Assert
      expect(result, Left(ValidationFailure('End date must be after start date')));
      verifyNever(mockRepository.getFinancialTrends(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        groupBy: anyNamed('groupBy'),
        currencyCode: anyNamed('currencyCode'),
      ));
    });

    test('should return ValidationFailure when groupBy is invalid', () async {
      // Act
      final result = await useCase(GetFinancialTrendsParams(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        groupBy: 'year', // Invalid groupBy value
      ));

      // Assert
      expect(result, Left(ValidationFailure('groupBy must be one of: day, week, month')));
      verifyNever(mockRepository.getFinancialTrends(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        groupBy: anyNamed('groupBy'),
        currencyCode: anyNamed('currencyCode'),
      ));
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(mockRepository.getFinancialTrends(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        groupBy: anyNamed('groupBy'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Left(ServerFailure('Failed to get financial trends')));

      // Act
      final result = await useCase(GetFinancialTrendsParams(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
      ));

      // Assert
      expect(result, Left(ServerFailure('Failed to get financial trends')));
      verify(mockRepository.getFinancialTrends(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        groupBy: 'month',
        currencyCode: 'USD',
      ));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return CacheFailure when cache fails', () async {
      // Arrange
      when(mockRepository.getFinancialTrends(
        userId: anyNamed('userId'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
        groupBy: anyNamed('groupBy'),
        currencyCode: anyNamed('currencyCode'),
      )).thenAnswer((_) async => Left(CacheFailure('Failed to load from cache')));

      // Act
      final result = await useCase(GetFinancialTrendsParams(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
      ));

      // Assert
      expect(result, Left(CacheFailure('Failed to load from cache')));
      verify(mockRepository.getFinancialTrends(
        userId: tUserId,
        startDate: tStartDate,
        endDate: tEndDate,
        groupBy: 'month',
        currencyCode: 'USD',
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
