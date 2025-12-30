import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/export_format.dart';

/// Repository interface for data export/import operations
///
/// Following Clean Architecture: Domain layer defines the contract,
/// Data layer implements it with CSV/JSON handlers.
abstract class DataExportRepository {
  /// Export transactions to a file
  ///
  /// [userId] - User whose transactions to export
  /// [format] - Export format (CSV or JSON)
  /// [startDate] - Optional start date filter
  /// [endDate] - Optional end date filter
  ///
  /// Returns [ExportResult] with file path and metadata on success.
  Future<Either<Failure, ExportResult>> exportTransactions({
    required String userId,
    required ExportFormat format,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Export accounts to a file
  ///
  /// [userId] - User whose accounts to export
  /// [format] - Export format (CSV or JSON)
  ///
  /// Returns [ExportResult] with file path and metadata on success.
  Future<Either<Failure, ExportResult>> exportAccounts({
    required String userId,
    required ExportFormat format,
  });

  /// Export budgets to a file
  ///
  /// [userId] - User whose budgets to export
  /// [format] - Export format (CSV or JSON)
  ///
  /// Returns [ExportResult] with file path and metadata on success.
  Future<Either<Failure, ExportResult>> exportBudgets({
    required String userId,
    required ExportFormat format,
  });

  /// Export categories to a file
  ///
  /// [userId] - User whose categories to export
  /// [format] - Export format (CSV or JSON)
  ///
  /// Returns [ExportResult] with file path and metadata on success.
  Future<Either<Failure, ExportResult>> exportCategories({
    required String userId,
    required ExportFormat format,
  });

  /// Export all user data to files
  ///
  /// [userId] - User whose data to export
  /// [format] - Export format (CSV or JSON)
  ///
  /// Returns list of [ExportResult] for each data type.
  /// Creates multiple files: transactions.csv, accounts.csv, etc.
  Future<Either<Failure, List<ExportResult>>> exportAllData({
    required String userId,
    required ExportFormat format,
  });

  /// Import transactions from a file
  ///
  /// [userId] - User to import transactions for
  /// [filePath] - Path to import file
  /// [format] - Import format (CSV or JSON)
  ///
  /// Returns [ImportResult] with success/failure counts and errors.
  /// Validates data and skips invalid rows.
  Future<Either<Failure, ImportResult>> importTransactions({
    required String userId,
    required String filePath,
    required ExportFormat format,
  });

  /// Import accounts from a file
  ///
  /// [userId] - User to import accounts for
  /// [filePath] - Path to import file
  /// [format] - Import format (CSV or JSON)
  ///
  /// Returns [ImportResult] with success/failure counts and errors.
  Future<Either<Failure, ImportResult>> importAccounts({
    required String userId,
    required String filePath,
    required ExportFormat format,
  });

  /// Import budgets from a file
  ///
  /// [userId] - User to import budgets for
  /// [filePath] - Path to import file
  /// [format] - Import format (CSV or JSON)
  ///
  /// Returns [ImportResult] with success/failure counts and errors.
  Future<Either<Failure, ImportResult>> importBudgets({
    required String userId,
    required String filePath,
    required ExportFormat format,
  });

  /// Import categories from a file
  ///
  /// [userId] - User to import categories for
  /// [filePath] - Path to import file
  /// [format] - Import format (CSV or JSON)
  ///
  /// Returns [ImportResult] with success/failure counts and errors.
  Future<Either<Failure, ImportResult>> importCategories({
    required String userId,
    required String filePath,
    required ExportFormat format,
  });
}
