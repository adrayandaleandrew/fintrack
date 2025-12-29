import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/export_format.dart';
import '../repositories/data_export_repository.dart';

/// Use case for exporting user data
///
/// Supports exporting transactions, accounts, budgets, categories, or all data.
/// Following Single Responsibility Principle.
class ExportData {
  final DataExportRepository repository;

  const ExportData(this.repository);

  Future<Either<Failure, dynamic>> call(ExportDataParams params) async {
    switch (params.dataType) {
      case ExportDataType.transactions:
        return await repository.exportTransactions(
          userId: params.userId,
          format: params.format,
          startDate: params.startDate,
          endDate: params.endDate,
        );

      case ExportDataType.accounts:
        return await repository.exportAccounts(
          userId: params.userId,
          format: params.format,
        );

      case ExportDataType.budgets:
        return await repository.exportBudgets(
          userId: params.userId,
          format: params.format,
        );

      case ExportDataType.categories:
        return await repository.exportCategories(
          userId: params.userId,
          format: params.format,
        );

      case ExportDataType.all:
        return await repository.exportAllData(
          userId: params.userId,
          format: params.format,
        );
    }
  }
}

/// Parameters for ExportData use case
class ExportDataParams extends Equatable {
  final String userId;
  final ExportDataType dataType;
  final ExportFormat format;
  final DateTime? startDate;
  final DateTime? endDate;

  const ExportDataParams({
    required this.userId,
    required this.dataType,
    this.format = ExportFormat.csv,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [userId, dataType, format, startDate, endDate];
}
