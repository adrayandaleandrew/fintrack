import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/export_format.dart';
import '../repositories/data_export_repository.dart';

/// Use case for importing user data
///
/// Supports importing transactions, accounts, budgets, and categories from CSV files.
/// Following Single Responsibility Principle.
class ImportData {
  final DataExportRepository repository;

  const ImportData(this.repository);

  Future<Either<Failure, ImportResult>> call(ImportDataParams params) async {
    // Validate file path
    if (params.filePath.isEmpty) {
      return Left(ValidationFailure('File path cannot be empty'));
    }

    switch (params.dataType) {
      case ExportDataType.transactions:
        return await repository.importTransactions(
          userId: params.userId,
          filePath: params.filePath,
          format: params.format,
        );

      case ExportDataType.accounts:
        return await repository.importAccounts(
          userId: params.userId,
          filePath: params.filePath,
          format: params.format,
        );

      case ExportDataType.budgets:
        return await repository.importBudgets(
          userId: params.userId,
          filePath: params.filePath,
          format: params.format,
        );

      case ExportDataType.categories:
        return await repository.importCategories(
          userId: params.userId,
          filePath: params.filePath,
          format: params.format,
        );

      case ExportDataType.all:
        return Left(ValidationFailure(
          'Import all is not supported. Please import each type separately.',
        ));
    }
  }
}

/// Parameters for ImportData use case
class ImportDataParams extends Equatable {
  final String userId;
  final ExportDataType dataType;
  final String filePath;
  final ExportFormat format;

  const ImportDataParams({
    required this.userId,
    required this.dataType,
    required this.filePath,
    this.format = ExportFormat.csv,
  });

  @override
  List<Object?> get props => [userId, dataType, filePath, format];
}
