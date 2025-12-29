import 'package:bloc/bloc.dart';
import '../../../../core/utils/error_messages.dart';
import '../../domain/usecases/export_data.dart';
import '../../domain/usecases/import_data.dart';
import 'data_export_event.dart';
import 'data_export_state.dart';

/// BLoC for managing data export/import operations
///
/// Handles exporting user data to CSV and importing from CSV files.
class DataExportBloc extends Bloc<DataExportEvent, DataExportState> {
  final ExportData exportData;
  final ImportData importData;

  DataExportBloc({
    required this.exportData,
    required this.importData,
  }) : super(const DataExportInitial()) {
    on<ExportDataRequested>(_onExportDataRequested);
    on<ImportDataRequested>(_onImportDataRequested);
  }

  /// Handle export data request
  Future<void> _onExportDataRequested(
    ExportDataRequested event,
    Emitter<DataExportState> emit,
  ) async {
    emit(const DataExportLoading());

    final result = await exportData(
      ExportDataParams(
        userId: event.userId,
        dataType: event.dataType,
        format: event.format,
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );

    result.fold(
      (failure) => emit(DataExportError(
        message: ErrorMessages.getErrorMessage(failure.message),
      )),
      (exportResult) {
        // Handle both single ExportResult and List<ExportResult>
        String message;
        if (exportResult is List) {
          var totalRecords = 0;
          for (final r in exportResult) {
            totalRecords += r.recordCount as int;
          }
          message =
              'Successfully exported $totalRecords records in ${exportResult.length} files';
        } else {
          message =
              'Successfully exported ${exportResult.recordCount} records';
        }

        emit(DataExportSuccess(
          result: exportResult,
          message: message,
        ));
      },
    );
  }

  /// Handle import data request
  Future<void> _onImportDataRequested(
    ImportDataRequested event,
    Emitter<DataExportState> emit,
  ) async {
    emit(const DataExportLoading());

    final result = await importData(
      ImportDataParams(
        userId: event.userId,
        dataType: event.dataType,
        filePath: event.filePath,
        format: event.format,
      ),
    );

    result.fold(
      (failure) => emit(DataExportError(
        message: ErrorMessages.getErrorMessage(failure.message),
      )),
      (importResult) {
        String message;
        if (importResult.hasErrors) {
          message =
              'Imported ${importResult.successCount} records with ${importResult.failureCount} failed';
        } else {
          message =
              'Successfully imported ${importResult.successCount} records';
        }

        emit(DataImportSuccess(
          result: importResult,
          message: message,
        ));
      },
    );
  }
}
