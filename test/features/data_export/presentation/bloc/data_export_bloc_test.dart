import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:finance_tracker/core/errors/failures.dart';
import 'package:finance_tracker/features/data_export/domain/entities/export_format.dart';
import 'package:finance_tracker/features/data_export/domain/usecases/export_data.dart';
import 'package:finance_tracker/features/data_export/domain/usecases/import_data.dart';
import 'package:finance_tracker/features/data_export/presentation/bloc/data_export_bloc.dart';
import 'package:finance_tracker/features/data_export/presentation/bloc/data_export_event.dart';
import 'package:finance_tracker/features/data_export/presentation/bloc/data_export_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'data_export_bloc_test.mocks.dart';

@GenerateMocks([ExportData, ImportData])
void main() {
  late DataExportBloc bloc;
  late MockExportData mockExportData;
  late MockImportData mockImportData;

  setUp(() {
    mockExportData = MockExportData();
    mockImportData = MockImportData();
    bloc = DataExportBloc(
      exportData: mockExportData,
      importData: mockImportData,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('DataExportBloc', () {
    test('initial state should be DataExportInitial', () {
      expect(bloc.state, equals(const DataExportInitial()));
    });

    group('ExportDataRequested', () {
      final tExportResult = ExportResult(
        filePath: '/path/to/transactions.csv',
        format: ExportFormat.csv,
        recordCount: 100,
        exportedAt: DateTime(2025, 12, 29),
      );

      blocTest<DataExportBloc, DataExportState>(
        'should emit [DataExportLoading, DataExportSuccess] when export succeeds',
        build: () {
          when(mockExportData(any))
              .thenAnswer((_) async => Right(tExportResult));
          return bloc;
        },
        act: (bloc) => bloc.add(const ExportDataRequested(
          userId: 'user_1',
          dataType: ExportDataType.transactions,
          format: ExportFormat.csv,
        )),
        expect: () => [
          const DataExportLoading(),
          isA<DataExportSuccess>()
              .having((s) => s.result, 'result', tExportResult)
              .having((s) => s.message, 'message', contains('100 records')),
        ],
        verify: (_) {
          verify(mockExportData(const ExportDataParams(
            userId: 'user_1',
            dataType: ExportDataType.transactions,
            format: ExportFormat.csv,
          ))).called(1);
        },
      );

      blocTest<DataExportBloc, DataExportState>(
        'should emit [DataExportLoading, DataExportError] when export fails',
        build: () {
          when(mockExportData(any))
              .thenAnswer((_) async => Left(ServerFailure('Export failed')));
          return bloc;
        },
        act: (bloc) => bloc.add(const ExportDataRequested(
          userId: 'user_1',
          dataType: ExportDataType.transactions,
          format: ExportFormat.csv,
        )),
        expect: () => [
          const DataExportLoading(),
          isA<DataExportError>()
              .having((s) => s.message, 'message', isNotEmpty),
        ],
      );

      blocTest<DataExportBloc, DataExportState>(
        'should handle export with date range filter',
        build: () {
          when(mockExportData(any))
              .thenAnswer((_) async => Right(tExportResult));
          return bloc;
        },
        act: (bloc) => bloc.add(ExportDataRequested(
          userId: 'user_1',
          dataType: ExportDataType.transactions,
          format: ExportFormat.csv,
          startDate: DateTime(2025, 12, 1),
          endDate: DateTime(2025, 12, 31),
        )),
        expect: () => [
          const DataExportLoading(),
          isA<DataExportSuccess>(),
        ],
        verify: (_) {
          verify(mockExportData(argThat(
            isA<ExportDataParams>()
                .having((p) => p.startDate, 'startDate', isNotNull)
                .having((p) => p.endDate, 'endDate', isNotNull),
          ))).called(1);
        },
      );

      blocTest<DataExportBloc, DataExportState>(
        'should export multiple data types (all)',
        build: () {
          final tMultipleExportResult = [
            tExportResult,
            tExportResult,
            tExportResult,
            tExportResult,
          ];

          when(mockExportData(any))
              .thenAnswer((_) async => Right(tMultipleExportResult));
          return bloc;
        },
        act: (bloc) => bloc.add(const ExportDataRequested(
          userId: 'user_1',
          dataType: ExportDataType.all,
          format: ExportFormat.csv,
        )),
        expect: () => [
          const DataExportLoading(),
          isA<DataExportSuccess>()
              .having((s) => s.message, 'message', contains('4 files')),
        ],
      );
    });

    group('ImportDataRequested', () {
      final tImportResult = ImportResult(
        successCount: 100,
        failureCount: 0,
        errors: [],
        importedAt: DateTime(2025, 12, 29),
      );

      blocTest<DataExportBloc, DataExportState>(
        'should emit [DataExportLoading, DataImportSuccess] when import succeeds',
        build: () {
          when(mockImportData(any))
              .thenAnswer((_) async => Right(tImportResult));
          return bloc;
        },
        act: (bloc) => bloc.add(const ImportDataRequested(
          userId: 'user_1',
          dataType: ExportDataType.transactions,
          filePath: '/path/to/transactions.csv',
          format: ExportFormat.csv,
        )),
        expect: () => [
          const DataExportLoading(),
          isA<DataImportSuccess>()
              .having((s) => s.result, 'result', tImportResult)
              .having((s) => s.message, 'message', contains('100 records')),
        ],
        verify: (_) {
          verify(mockImportData(const ImportDataParams(
            userId: 'user_1',
            dataType: ExportDataType.transactions,
            filePath: '/path/to/transactions.csv',
            format: ExportFormat.csv,
          ))).called(1);
        },
      );

      blocTest<DataExportBloc, DataExportState>(
        'should emit [DataExportLoading, DataExportError] when import fails',
        build: () {
          when(mockImportData(any))
              .thenAnswer((_) async => Left(ServerFailure('Import failed')));
          return bloc;
        },
        act: (bloc) => bloc.add(const ImportDataRequested(
          userId: 'user_1',
          dataType: ExportDataType.transactions,
          filePath: '/path/to/transactions.csv',
          format: ExportFormat.csv,
        )),
        expect: () => [
          const DataExportLoading(),
          isA<DataExportError>()
              .having((s) => s.message, 'message', isNotEmpty),
        ],
      );

      blocTest<DataExportBloc, DataExportState>(
        'should handle partial import failures',
        build: () {
          final tPartialResult = ImportResult(
            successCount: 95,
            failureCount: 5,
            errors: ['Row 10: Invalid format', 'Row 25: Missing field'],
            importedAt: DateTime(2025, 12, 29),
          );

          when(mockImportData(any))
              .thenAnswer((_) async => Right(tPartialResult));
          return bloc;
        },
        act: (bloc) => bloc.add(const ImportDataRequested(
          userId: 'user_1',
          dataType: ExportDataType.transactions,
          filePath: '/path/to/transactions.csv',
          format: ExportFormat.csv,
        )),
        expect: () => [
          const DataExportLoading(),
          isA<DataImportSuccess>()
              .having((s) => s.message, 'message', contains('95'))
              .having((s) => s.message, 'message', contains('5 failed')),
        ],
      );

      blocTest<DataExportBloc, DataExportState>(
        'should handle file not found error',
        build: () {
          when(mockImportData(any))
              .thenAnswer((_) async => Left(ServerFailure('File not found')));
          return bloc;
        },
        act: (bloc) => bloc.add(const ImportDataRequested(
          userId: 'user_1',
          dataType: ExportDataType.transactions,
          filePath: '/invalid/path.csv',
          format: ExportFormat.csv,
        )),
        expect: () => [
          const DataExportLoading(),
          isA<DataExportError>(),
        ],
      );

      blocTest<DataExportBloc, DataExportState>(
        'should handle invalid CSV format',
        build: () {
          when(mockImportData(any)).thenAnswer(
              (_) async => Left(ValidationFailure('Invalid CSV format')));
          return bloc;
        },
        act: (bloc) => bloc.add(const ImportDataRequested(
          userId: 'user_1',
          dataType: ExportDataType.transactions,
          filePath: '/path/to/invalid.csv',
          format: ExportFormat.csv,
        )),
        expect: () => [
          const DataExportLoading(),
          isA<DataExportError>(),
        ],
      );
    });
  });
}
