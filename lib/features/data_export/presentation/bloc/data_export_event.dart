import 'package:equatable/equatable.dart';
import '../../domain/entities/export_format.dart';

/// Events for DataExportBloc
abstract class DataExportEvent extends Equatable {
  const DataExportEvent();

  @override
  List<Object?> get props => [];
}

/// Export data event
class ExportDataRequested extends DataExportEvent {
  final String userId;
  final ExportDataType dataType;
  final ExportFormat format;
  final DateTime? startDate;
  final DateTime? endDate;

  const ExportDataRequested({
    required this.userId,
    required this.dataType,
    this.format = ExportFormat.csv,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [userId, dataType, format, startDate, endDate];
}

/// Import data event
class ImportDataRequested extends DataExportEvent {
  final String userId;
  final ExportDataType dataType;
  final String filePath;
  final ExportFormat format;

  const ImportDataRequested({
    required this.userId,
    required this.dataType,
    required this.filePath,
    this.format = ExportFormat.csv,
  });

  @override
  List<Object?> get props => [userId, dataType, filePath, format];
}
