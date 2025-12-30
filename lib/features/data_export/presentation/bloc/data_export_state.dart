import 'package:equatable/equatable.dart';
import '../../domain/entities/export_format.dart';

/// States for DataExportBloc
abstract class DataExportState extends Equatable {
  const DataExportState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class DataExportInitial extends DataExportState {
  const DataExportInitial();
}

/// Loading state (export or import in progress)
class DataExportLoading extends DataExportState {
  const DataExportLoading();
}

/// Export success state
class DataExportSuccess extends DataExportState {
  final dynamic result; // ExportResult or List<ExportResult>
  final String message;

  const DataExportSuccess({
    required this.result,
    required this.message,
  });

  @override
  List<Object?> get props => [result, message];
}

/// Import success state
class DataImportSuccess extends DataExportState {
  final ImportResult result;
  final String message;

  const DataImportSuccess({
    required this.result,
    required this.message,
  });

  @override
  List<Object?> get props => [result, message];
}

/// Error state
class DataExportError extends DataExportState {
  final String message;

  const DataExportError({required this.message});

  @override
  List<Object?> get props => [message];
}
