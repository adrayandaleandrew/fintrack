import '../../../transactions/data/models/transaction_model.dart';
import '../models/recurring_transaction_model.dart';

/// Recurring transaction remote data source interface
///
/// Defines contracts for recurring transaction API operations.
/// Can be implemented with mock data or real API.
abstract class RecurringTransactionRemoteDataSource {
  /// Get all recurring transactions for a user
  ///
  /// [userId] - User identifier
  /// [activeOnly] - If true, returns only active recurring transactions
  /// Returns list of recurring transaction models
  /// Throws ServerException on error
  Future<List<RecurringTransactionModel>> getRecurringTransactions({
    required String userId,
    bool activeOnly = false,
  });

  /// Get a single recurring transaction by ID
  ///
  /// [recurringTransactionId] - Recurring transaction identifier
  /// Returns recurring transaction model
  /// Throws ServerException if not found or on error
  Future<RecurringTransactionModel> getRecurringTransactionById({
    required String recurringTransactionId,
  });

  /// Get recurring transactions by account
  ///
  /// [accountId] - Account identifier
  /// Returns list of recurring transaction models
  /// Throws ServerException on error
  Future<List<RecurringTransactionModel>> getRecurringTransactionsByAccount({
    required String accountId,
  });

  /// Get recurring transactions by category
  ///
  /// [categoryId] - Category identifier
  /// Returns list of recurring transaction models
  /// Throws ServerException on error
  Future<List<RecurringTransactionModel>> getRecurringTransactionsByCategory({
    required String categoryId,
  });

  /// Create a new recurring transaction
  ///
  /// [recurringTransaction] - Recurring transaction model to create
  /// Returns created recurring transaction with generated ID
  /// Throws ServerException on error
  Future<RecurringTransactionModel> createRecurringTransaction({
    required RecurringTransactionModel recurringTransaction,
  });

  /// Update an existing recurring transaction
  ///
  /// [recurringTransaction] - Recurring transaction model with updated values
  /// Returns updated recurring transaction
  /// Throws ServerException if not found or on error
  Future<RecurringTransactionModel> updateRecurringTransaction({
    required RecurringTransactionModel recurringTransaction,
  });

  /// Delete a recurring transaction
  ///
  /// [recurringTransactionId] - Recurring transaction identifier
  /// Throws ServerException if not found or on error
  Future<void> deleteRecurringTransaction({
    required String recurringTransactionId,
  });

  /// Get due recurring transactions
  ///
  /// Returns list of recurring transactions that are due
  /// Throws ServerException on error
  Future<List<RecurringTransactionModel>> getDueRecurringTransactions();

  /// Generate a transaction from a recurring transaction
  ///
  /// [recurringTransactionId] - Recurring transaction identifier
  /// [occurrenceDate] - Date for the generated transaction
  /// Returns generated transaction
  /// Throws ServerException if not found or on error
  Future<TransactionModel> generateTransaction({
    required String recurringTransactionId,
    required DateTime occurrenceDate,
  });
}
