import 'package:equatable/equatable.dart';

/// Supported data export formats
enum ExportFormat {
  csv('CSV', '.csv', 'text/csv'),
  json('JSON', '.json', 'application/json');

  const ExportFormat(this.displayName, this.fileExtension, this.mimeType);

  final String displayName;
  final String fileExtension;
  final String mimeType;
}

/// Result of a data export operation
class ExportResult extends Equatable {
  final String filePath;
  final ExportFormat format;
  final int recordCount;
  final DateTime exportedAt;

  const ExportResult({
    required this.filePath,
    required this.format,
    required this.recordCount,
    required this.exportedAt,
  });

  @override
  List<Object?> get props => [filePath, format, recordCount, exportedAt];
}

/// Result of a data import operation
class ImportResult extends Equatable {
  final int successCount;
  final int failureCount;
  final List<String> errors;
  final DateTime importedAt;

  const ImportResult({
    required this.successCount,
    required this.failureCount,
    required this.errors,
    required this.importedAt,
  });

  bool get hasErrors => failureCount > 0;
  bool get isSuccess => failureCount == 0;
  int get totalCount => successCount + failureCount;

  @override
  List<Object?> get props => [successCount, failureCount, errors, importedAt];
}

/// Types of data that can be exported/imported
enum ExportDataType {
  transactions('Transactions'),
  accounts('Accounts'),
  budgets('Budgets'),
  categories('Categories'),
  all('All Data');

  const ExportDataType(this.displayName);

  final String displayName;
}
