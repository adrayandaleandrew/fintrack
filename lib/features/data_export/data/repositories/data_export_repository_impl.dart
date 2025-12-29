import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../../transactions/data/models/transaction_model.dart';
import '../../../accounts/domain/repositories/account_repository.dart';
import '../../../accounts/data/models/account_model.dart';
import '../../../budgets/domain/repositories/budget_repository.dart';
import '../../../budgets/data/models/budget_model.dart';
import '../../../categories/domain/repositories/category_repository.dart';
import '../../../categories/data/models/category_model.dart';
import '../../domain/entities/export_format.dart';
import '../../domain/repositories/data_export_repository.dart';
import '../services/csv_formatter.dart';

/// Implementation of DataExportRepository
///
/// Handles CSV export/import using csv package and path_provider.
/// Following Clean Architecture: Repository coordinates between services.
class DataExportRepositoryImpl implements DataExportRepository {
  final TransactionRepository transactionRepository;
  final AccountRepository accountRepository;
  final BudgetRepository budgetRepository;
  final CategoryRepository categoryRepository;
  final CsvFormatter csvFormatter;

  const DataExportRepositoryImpl({
    required this.transactionRepository,
    required this.accountRepository,
    required this.budgetRepository,
    required this.categoryRepository,
    required this.csvFormatter,
  });

  @override
  Future<Either<Failure, ExportResult>> exportTransactions({
    required String userId,
    required ExportFormat format,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Get transactions from repository
      final transactionsResult =
          await transactionRepository.getTransactions(userId);

      return await transactionsResult.fold(
        (failure) => Left(failure),
        (transactions) async {
          // Filter by date range if provided
          var filteredTransactions = transactions;
          if (startDate != null || endDate != null) {
            filteredTransactions = transactions.where((txn) {
              if (startDate != null && txn.date.isBefore(startDate)) {
                return false;
              }
              if (endDate != null && txn.date.isAfter(endDate)) {
                return false;
              }
              return true;
            }).toList();
          }

          // Convert entities to models
          final transactionModels = filteredTransactions
              .map((txn) => TransactionModel.fromEntity(txn))
              .toList();

          // Convert to CSV
          final csvContent = csvFormatter.transactionsToCsv(transactionModels);

          // Save to file
          final filePath = await _saveToFile(
            'transactions',
            format,
            csvContent,
          );

          return Right(ExportResult(
            filePath: filePath,
            format: format,
            recordCount: filteredTransactions.length,
            exportedAt: DateTime.now(),
          ));
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure('Failed to export transactions: $e'));
    }
  }

  @override
  Future<Either<Failure, ExportResult>> exportAccounts({
    required String userId,
    required ExportFormat format,
  }) async {
    try {
      final accountsResult =
          await accountRepository.getAccounts(userId: userId);

      return await accountsResult.fold(
        (failure) => Left(failure),
        (accounts) async {
          // Convert entities to models
          final accountModels = accounts
              .map((acc) => AccountModel.fromEntity(acc))
              .toList();

          final csvContent = csvFormatter.accountsToCsv(accountModels);

          final filePath = await _saveToFile('accounts', format, csvContent);

          return Right(ExportResult(
            filePath: filePath,
            format: format,
            recordCount: accounts.length,
            exportedAt: DateTime.now(),
          ));
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure('Failed to export accounts: $e'));
    }
  }

  @override
  Future<Either<Failure, ExportResult>> exportBudgets({
    required String userId,
    required ExportFormat format,
  }) async {
    try {
      final budgetsResult = await budgetRepository.getBudgets(userId: userId);

      return await budgetsResult.fold(
        (failure) => Left(failure),
        (budgets) async {
          // Convert entities to models
          final budgetModels = budgets
              .map((budget) => BudgetModel.fromEntity(budget))
              .toList();

          final csvContent = csvFormatter.budgetsToCsv(budgetModels);

          final filePath = await _saveToFile('budgets', format, csvContent);

          return Right(ExportResult(
            filePath: filePath,
            format: format,
            recordCount: budgets.length,
            exportedAt: DateTime.now(),
          ));
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure('Failed to export budgets: $e'));
    }
  }

  @override
  Future<Either<Failure, ExportResult>> exportCategories({
    required String userId,
    required ExportFormat format,
  }) async {
    try {
      final categoriesResult =
          await categoryRepository.getCategories(userId: userId);

      return await categoriesResult.fold(
        (failure) => Left(failure),
        (categories) async {
          // Convert entities to models
          final categoryModels = categories
              .map((cat) => CategoryModel.fromEntity(cat))
              .toList();

          final csvContent = csvFormatter.categoriesToCsv(categoryModels);

          final filePath = await _saveToFile('categories', format, csvContent);

          return Right(ExportResult(
            filePath: filePath,
            format: format,
            recordCount: categories.length,
            exportedAt: DateTime.now(),
          ));
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure('Failed to export categories: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ExportResult>>> exportAllData({
    required String userId,
    required ExportFormat format,
  }) async {
    try {
      final results = <ExportResult>[];

      // Export transactions
      final transactionsResult = await exportTransactions(
        userId: userId,
        format: format,
      );
      transactionsResult.fold(
        (failure) => throw Exception(failure.message),
        (result) => results.add(result),
      );

      // Export accounts
      final accountsResult = await exportAccounts(
        userId: userId,
        format: format,
      );
      accountsResult.fold(
        (failure) => throw Exception(failure.message),
        (result) => results.add(result),
      );

      // Export budgets
      final budgetsResult = await exportBudgets(
        userId: userId,
        format: format,
      );
      budgetsResult.fold(
        (failure) => throw Exception(failure.message),
        (result) => results.add(result),
      );

      // Export categories
      final categoriesResult = await exportCategories(
        userId: userId,
        format: format,
      );
      categoriesResult.fold(
        (failure) => throw Exception(failure.message),
        (result) => results.add(result),
      );

      return Right(results);
    } catch (e) {
      return Left(UnexpectedFailure('Failed to export all data: $e'));
    }
  }

  @override
  Future<Either<Failure, ImportResult>> importTransactions({
    required String userId,
    required String filePath,
    required ExportFormat format,
  }) async {
    try {
      // Read file content
      final file = File(filePath);
      if (!await file.exists()) {
        return Left(ValidationFailure('File not found: $filePath'));
      }

      final csvContent = await file.readAsString();

      // Parse CSV
      final transactions = csvFormatter.csvToTransactions(csvContent);

      int successCount = 0;
      int failureCount = 0;
      final errors = <String>[];

      // Import each transaction
      for (final transaction in transactions) {
        final result = await transactionRepository.createTransaction(
          transaction,
        );

        result.fold(
          (failure) {
            failureCount++;
            errors.add('Row ${successCount + failureCount}: ${failure.message}');
          },
          (_) => successCount++,
        );
      }

      return Right(ImportResult(
        successCount: successCount,
        failureCount: failureCount,
        errors: errors,
        importedAt: DateTime.now(),
      ));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to import transactions: $e'));
    }
  }

  @override
  Future<Either<Failure, ImportResult>> importAccounts({
    required String userId,
    required String filePath,
    required ExportFormat format,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return Left(ValidationFailure('File not found: $filePath'));
      }

      final csvContent = await file.readAsString();
      final accounts = csvFormatter.csvToAccounts(csvContent);

      int successCount = 0;
      int failureCount = 0;
      final errors = <String>[];

      for (final account in accounts) {
        final result = await accountRepository.createAccount(
          userId: userId,
          name: account.name,
          type: account.type,
          initialBalance: account.balance,
          currency: account.currency,
          icon: account.icon,
          color: account.color,
          notes: account.notes,
          creditLimit: account.creditLimit,
          interestRate: account.interestRate,
        );

        result.fold(
          (failure) {
            failureCount++;
            errors.add('Row ${successCount + failureCount}: ${failure.message}');
          },
          (_) => successCount++,
        );
      }

      return Right(ImportResult(
        successCount: successCount,
        failureCount: failureCount,
        errors: errors,
        importedAt: DateTime.now(),
      ));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to import accounts: $e'));
    }
  }

  @override
  Future<Either<Failure, ImportResult>> importBudgets({
    required String userId,
    required String filePath,
    required ExportFormat format,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return Left(ValidationFailure('File not found: $filePath'));
      }

      final csvContent = await file.readAsString();
      final budgets = csvFormatter.csvToBudgets(csvContent);

      int successCount = 0;
      int failureCount = 0;
      final errors = <String>[];

      for (final budget in budgets) {
        final result = await budgetRepository.createBudget(
          budget: budget,
        );

        result.fold(
          (failure) {
            failureCount++;
            errors.add('Row ${successCount + failureCount}: ${failure.message}');
          },
          (_) => successCount++,
        );
      }

      return Right(ImportResult(
        successCount: successCount,
        failureCount: failureCount,
        errors: errors,
        importedAt: DateTime.now(),
      ));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to import budgets: $e'));
    }
  }

  @override
  Future<Either<Failure, ImportResult>> importCategories({
    required String userId,
    required String filePath,
    required ExportFormat format,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return Left(ValidationFailure('File not found: $filePath'));
      }

      final csvContent = await file.readAsString();
      final categories = csvFormatter.csvToCategories(csvContent);

      int successCount = 0;
      int failureCount = 0;
      final errors = <String>[];

      for (final category in categories) {
        final result = await categoryRepository.createCategory(
          category: category,
        );

        result.fold(
          (failure) {
            failureCount++;
            errors.add('Row ${successCount + failureCount}: ${failure.message}');
          },
          (_) => successCount++,
        );
      }

      return Right(ImportResult(
        successCount: successCount,
        failureCount: failureCount,
        errors: errors,
        importedAt: DateTime.now(),
      ));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to import categories: $e'));
    }
  }

  /// Save content to file in app documents directory
  ///
  /// Returns full file path.
  Future<String> _saveToFile(
    String baseName,
    ExportFormat format,
    String content,
  ) async {
    try {
      // Get documents directory
      final directory = await getApplicationDocumentsDirectory();

      // Create Finance Tracker exports subdirectory
      final exportsDir = Directory('${directory.path}/FinanceTracker/Exports');
      if (!await exportsDir.exists()) {
        await exportsDir.create(recursive: true);
      }

      // Generate filename with timestamp
      final timestamp = DateTime.now().toIso8601String().split('.')[0];
      final fileName =
          '${baseName}_${timestamp.replaceAll(':', '-')}${format.fileExtension}';
      final filePath = '${exportsDir.path}/$fileName';

      // Write file
      final file = File(filePath);
      await file.writeAsString(content);

      return filePath;
    } catch (e) {
      throw ServerException('Failed to save file: $e');
    }
  }
}
