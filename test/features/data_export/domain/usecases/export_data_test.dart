import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/data_export/domain/entities/export_format.dart';
import 'package:finance_tracker/features/data_export/domain/repositories/data_export_repository.dart';
import 'package:finance_tracker/features/data_export/domain/usecases/export_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'export_data_test.mocks.dart';

@GenerateMocks([DataExportRepository])
void main() {
  late ExportData useCase;
  late MockDataExportRepository mockRepository;

  setUp(() {
    mockRepository = MockDataExportRepository();
    useCase = ExportData(mockRepository);
  });

  group('ExportData', () {
    const tUserId = 'user_1';
    final tExportResult = ExportResult(
      filePath: '/path/to/transactions.csv',
      format: ExportFormat.csv,
      recordCount: 100,
      exportedAt: DateTime(2025, 12, 29),
    );

    test('should export transactions successfully', () async {
      // Arrange
      when(mockRepository.exportTransactions(
        userId: anyNamed('userId'),
        format: anyNamed('format'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Right(tExportResult));

      // Act
      final result = await useCase(const ExportDataParams(
        userId: tUserId,
        dataType: ExportDataType.transactions,
        format: ExportFormat.csv,
      ));

      // Assert
      expect(result, Right(tExportResult));
      verify(mockRepository.exportTransactions(
        userId: tUserId,
        format: ExportFormat.csv,
        startDate: null,
        endDate: null,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should export transactions with date range', () async {
      // Arrange
      final startDate = DateTime(2025, 1, 1);
      final endDate = DateTime(2025, 12, 31);

      when(mockRepository.exportTransactions(
        userId: anyNamed('userId'),
        format: anyNamed('format'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Right(tExportResult));

      // Act
      final result = await useCase(ExportDataParams(
        userId: tUserId,
        dataType: ExportDataType.transactions,
        format: ExportFormat.csv,
        startDate: startDate,
        endDate: endDate,
      ));

      // Assert
      expect(result, Right(tExportResult));
      verify(mockRepository.exportTransactions(
        userId: tUserId,
        format: ExportFormat.csv,
        startDate: startDate,
        endDate: endDate,
      )).called(1);
    });

    test('should export accounts successfully', () async {
      // Arrange
      when(mockRepository.exportAccounts(
        userId: anyNamed('userId'),
        format: anyNamed('format'),
      )).thenAnswer((_) async => Right(tExportResult));

      // Act
      final result = await useCase(const ExportDataParams(
        userId: tUserId,
        dataType: ExportDataType.accounts,
        format: ExportFormat.csv,
      ));

      // Assert
      expect(result, Right(tExportResult));
      verify(mockRepository.exportAccounts(
        userId: tUserId,
        format: ExportFormat.csv,
      )).called(1);
    });

    test('should export budgets successfully', () async {
      // Arrange
      when(mockRepository.exportBudgets(
        userId: anyNamed('userId'),
        format: anyNamed('format'),
      )).thenAnswer((_) async => Right(tExportResult));

      // Act
      final result = await useCase(const ExportDataParams(
        userId: tUserId,
        dataType: ExportDataType.budgets,
        format: ExportFormat.csv,
      ));

      // Assert
      expect(result, Right(tExportResult));
    });

    test('should export categories successfully', () async {
      // Arrange
      when(mockRepository.exportCategories(
        userId: anyNamed('userId'),
        format: anyNamed('format'),
      )).thenAnswer((_) async => Right(tExportResult));

      // Act
      final result = await useCase(const ExportDataParams(
        userId: tUserId,
        dataType: ExportDataType.categories,
        format: ExportFormat.csv,
      ));

      // Assert
      expect(result, Right(tExportResult));
    });

    test('should export all data successfully', () async {
      // Arrange
      final tExportResults = [
        tExportResult,
        tExportResult,
        tExportResult,
        tExportResult,
      ];

      when(mockRepository.exportAllData(
        userId: anyNamed('userId'),
        format: anyNamed('format'),
      )).thenAnswer((_) async => Right(tExportResults));

      // Act
      final result = await useCase(const ExportDataParams(
        userId: tUserId,
        dataType: ExportDataType.all,
        format: ExportFormat.csv,
      ));

      // Assert
      expect(result, Right(tExportResults));
    });

    test('should return failure when export fails', () async {
      // Arrange
      when(mockRepository.exportTransactions(
        userId: anyNamed('userId'),
        format: anyNamed('format'),
        startDate: anyNamed('startDate'),
        endDate: anyNamed('endDate'),
      )).thenAnswer((_) async => Left(ServerFailure('Export failed')));

      // Act
      final result = await useCase(const ExportDataParams(
        userId: tUserId,
        dataType: ExportDataType.transactions,
        format: ExportFormat.csv,
      ));

      // Assert
      expect(result, Left(ServerFailure('Export failed')));
    });
  });
}
