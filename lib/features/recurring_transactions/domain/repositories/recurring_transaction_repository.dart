import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../entities/recurring_transaction.dart';

/// Recurring transaction repository interface
///
/// Defines contracts for recurring transaction data operations.
/// Implementations can use mock data or real API.
abstract class RecurringTransactionRepository {
  /// Get all recurring transactions for a user
  ///
  /// [userId] - User identifier
  /// [activeOnly] - If true, returns only active recurring transactions
  /// Returns list of recurring transactions or failure
  Future<Either<Failure, List<RecurringTransaction>>>
      getRecurringTransactions({
    required String userId,
    bool activeOnly = false,
  });

  /// Get a single recurring transaction by ID
  ///
  /// [recurringTransactionId] - Recurring transaction identifier
  /// Returns recurring transaction or failure
  Future<Either<Failure, RecurringTransaction>> getRecurringTransactionById({
    required String recurringTransactionId,
  });

  /// Get recurring transactions by account
  ///
  /// [accountId] - Account identifier
  /// Returns list of recurring transactions or failure
  Future<Either<Failure, List<RecurringTransaction>>>
      getRecurringTransactionsByAccount({
    required String accountId,
  });

  /// Get recurring transactions by category
  ///
  /// [categoryId] - Category identifier
  /// Returns list of recurring transactions or failure
  Future<Either<Failure, List<RecurringTransaction>>>
      getRecurringTransactionsByCategory({
    required String categoryId,
  });

  /// Create a new recurring transaction
  ///
  /// [recurringTransaction] - Recurring transaction entity to create
  /// Returns created recurring transaction with generated ID or failure
  Future<Either<Failure, RecurringTransaction>> createRecurringTransaction({
    required RecurringTransaction recurringTransaction,
  });

  /// Update an existing recurring transaction
  ///
  /// [recurringTransaction] - Recurring transaction entity with updated values
  /// Returns updated recurring transaction or failure
  Future<Either<Failure, RecurringTransaction>> updateRecurringTransaction({
    required RecurringTransaction recurringTransaction,
  });

  /// Delete a recurring transaction
  ///
  /// [recurringTransactionId] - Recurring transaction identifier
  /// Returns success or failure
  Future<Either<Failure, void>> deleteRecurringTransaction({
    required String recurringTransactionId,
  });

  /// Get due recurring transactions that need to be processed
  ///
  /// Returns list of recurring transactions that are due or failure
  Future<Either<Failure, List<RecurringTransaction>>>
      getDueRecurringTransactions();

  /// Generate a transaction from a recurring transaction
  ///
  /// [recurringTransactionId] - Recurring transaction identifier
  /// [occurrenceDate] - Date for the generated transaction
  /// Returns generated transaction or failure
  Future<Either<Failure, Transaction>> generateTransaction({
    required String recurringTransactionId,
    required DateTime occurrenceDate,
  });

  /// Process all due recurring transactions
  ///
  /// Generates transactions for all due recurring transactions
  /// Returns list of generated transactions or failure
  Future<Either<Failure, List<Transaction>>> processDueRecurringTransactions();
}
