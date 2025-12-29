import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/data_export/domain/entities/export_format.dart';
import 'package:finance_tracker/features/data_export/domain/repositories/data_export_repository.dart';
import 'package:finance_tracker/features/data_export/domain/usecases/import_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'import_data_test.mocks.dart';

@GenerateMocks([DataExportRepository])
void main() {
  late ImportData useCase;
  late MockDataExportRepository mockRepository;

  setUp(() {
    mockRepository = MockDataExportRepository();
    useCase = ImportData(mockRepository);
  });

  group('ImportData', () {
    const tUserId = 'user_1';
    const tFilePath = '/path/to/transactions.csv';
    final tImportResult = ImportResult(
      successCount: 100,
      failureCount: 0,
      errors: [],
      importedAt: DateTime(2025, 12, 29),
    );

    test('should import transactions successfully', () async {
      // Arrange
      when(mockRepository.importTransactions(
        userId: anyNamed('userId'),
        filePath: anyNamed('filePath'),
        format: anyNamed('format'),
      )).thenAnswer((_) async => Right(tImportResult));

      // Act
      final result = await useCase(const ImportDataParams(
        userId: tUserId,
        dataType: ExportDataType.transactions,
        filePath: tFilePath,
        format: ExportFormat.csv,
      ));

      // Assert
      expect(result, Right(tImportResult));
      verify(mockRepository.importTransactions(
        userId: tUserId,
        filePath: tFilePath,
        format: ExportFormat.csv,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should import accounts successfully', () async {
      // Arrange
      when(mockRepository.importAccounts(
        userId: anyNamed('userId'),
        filePath: anyNamed('filePath'),
        format: anyNamed('format'),
      )).thenAnswer((_) async => Right(tImportResult));

      // Act
      final result = await useCase(const ImportDataParams(
        userId: tUserId,
        dataType: ExportDataType.accounts,
        filePath: tFilePath,
        format: ExportFormat.csv,
      ));

      // Assert
      expect(result, Right(tImportResult));
      verify(mockRepository.importAccounts(
        userId: tUserId,
        filePath: tFilePath,
        format: ExportFormat.csv,
      )).called(1);
    });

    test('should import budgets successfully', () async {
      // Arrange
      when(mockRepository.importBudgets(
        userId: anyNamed('userId'),
        filePath: anyNamed('filePath'),
        format: anyNamed('format'),
      )).thenAnswer((_) async => Right(tImportResult));

      // Act
      final result = await useCase(const ImportDataParams(
        userId: tUserId,
        dataType: ExportDataType.budgets,
        filePath: tFilePath,
        format: ExportFormat.csv,
      ));

      // Assert
      expect(result, Right(tImportResult));
      verify(mockRepository.importBudgets(
        userId: tUserId,
        filePath: tFilePath,
        format: ExportFormat.csv,
      )).called(1);
    });

    test('should import categories successfully', () async {
      // Arrange
      when(mockRepository.importCategories(
        userId: anyNamed('userId'),
        filePath: anyNamed('filePath'),
        format: anyNamed('format'),
      )).thenAnswer((_) async => Right(tImportResult));

      // Act
      final result = await useCase(const ImportDataParams(
        userId: tUserId,
        dataType: ExportDataType.categories,
        filePath: tFilePath,
        format: ExportFormat.csv,
      ));

      // Assert
      expect(result, Right(tImportResult));
      verify(mockRepository.importCategories(
        userId: tUserId,
        filePath: tFilePath,
        format: ExportFormat.csv,
      )).called(1);
    });

    test('should handle import with partial failures', () async {
      // Arrange
      final tPartialFailureResult = ImportResult(
        successCount: 95,
        failureCount: 5,
        errors: [
          'Row 10: Invalid amount format',
          'Row 25: Missing required field',
          'Row 50: Invalid date format',
          'Row 75: Account not found',
          'Row 99: Category not found',
        ],
        importedAt: DateTime(2025, 12, 29),
      );

      when(mockRepository.importTransactions(
        userId: anyNamed('userId'),
        filePath: anyNamed('filePath'),
        format: anyNamed('format'),
      )).thenAnswer((_) async => Right(tPartialFailureResult));

      // Act
      final result = await useCase(const ImportDataParams(
        userId: tUserId,
        dataType: ExportDataType.transactions,
        filePath: tFilePath,
        format: ExportFormat.csv,
      ));

      // Assert
      result.fold(
        (failure) => fail('Should not return failure'),
        (importResult) {
          expect(importResult.successCount, equals(95));
          expect(importResult.failureCount, equals(5));
          expect(importResult.errors.length, equals(5));
          expect(importResult.errors[0], contains('Row 10'));
        },
      );
    });

    test('should return failure when file not found', () async {
      // Arrange
      when(mockRepository.importTransactions(
        userId: anyNamed('userId'),
        filePath: anyNamed('filePath'),
        format: anyNamed('format'),
      )).thenAnswer((_) async => Left(ServerFailure('File not found')));

      // Act
      final result = await useCase(const ImportDataParams(
        userId: tUserId,
        dataType: ExportDataType.transactions,
        filePath: '/invalid/path.csv',
        format: ExportFormat.csv,
      ));

      // Assert
      expect(result, Left(ServerFailure('File not found')));
    });

    test('should return failure when import fails', () async {
      // Arrange
      when(mockRepository.importTransactions(
        userId: anyNamed('userId'),
        filePath: anyNamed('filePath'),
        format: anyNamed('format'),
      )).thenAnswer((_) async => Left(ServerFailure('Import failed')));

      // Act
      final result = await useCase(const ImportDataParams(
        userId: tUserId,
        dataType: ExportDataType.transactions,
        filePath: tFilePath,
        format: ExportFormat.csv,
      ));

      // Assert
      expect(result, Left(ServerFailure('Import failed')));
    });

    test('should handle invalid CSV format', () async {
      // Arrange
      when(mockRepository.importTransactions(
        userId: anyNamed('userId'),
        filePath: anyNamed('filePath'),
        format: anyNamed('format'),
      )).thenAnswer((_) async => Left(ValidationFailure('Invalid CSV format')));

      // Act
      final result = await useCase(const ImportDataParams(
        userId: tUserId,
        dataType: ExportDataType.transactions,
        filePath: tFilePath,
        format: ExportFormat.csv,
      ));

      // Assert
      expect(result, Left(ValidationFailure('Invalid CSV format')));
    });

    test('should handle empty CSV file', () async {
      // Arrange
      final tEmptyResult = ImportResult(
        successCount: 0,
        failureCount: 0,
        errors: [],
        importedAt: DateTime(2025, 12, 29),
      );

      when(mockRepository.importTransactions(
        userId: anyNamed('userId'),
        filePath: anyNamed('filePath'),
        format: anyNamed('format'),
      )).thenAnswer((_) async => Right(tEmptyResult));

      // Act
      final result = await useCase(const ImportDataParams(
        userId: tUserId,
        dataType: ExportDataType.transactions,
        filePath: tFilePath,
        format: ExportFormat.csv,
      ));

      // Assert
      result.fold(
        (failure) => fail('Should not return failure'),
        (importResult) {
          expect(importResult.successCount, equals(0));
          expect(importResult.failureCount, equals(0));
          expect(importResult.errors, isEmpty);
        },
      );
    });
  });
}
