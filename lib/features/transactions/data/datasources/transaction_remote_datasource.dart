import '../models/transaction_model.dart';
import '../../domain/entities/transaction.dart';

/// Remote data source for transaction operations
///
/// Defines the contract for transaction API operations.
/// Implementations should handle API calls and account balance updates.
abstract class TransactionRemoteDataSource {
  /// Get all transactions for a user
  ///
  /// Returns list of transactions ordered by date (newest first)
  Future<List<TransactionModel>> getTransactions(String userId);

  /// Get a single transaction by ID
  ///
  /// Throws [ServerException] if transaction not found
  Future<TransactionModel> getTransactionById(String id);

  /// Create a new transaction
  ///
  /// Updates account balance(s) automatically.
  /// For transfers, updates both source and destination accounts.
  /// Throws [ServerException] on validation errors or if accounts don't exist.
  Future<TransactionModel> createTransaction(TransactionModel transaction);

  /// Update an existing transaction
  ///
  /// Recalculates account balances by reversing old transaction and applying new one.
  /// Throws [ServerException] on validation errors or if transaction doesn't exist.
  Future<TransactionModel> updateTransaction(TransactionModel transaction);

  /// Delete a transaction
  ///
  /// Restores account balance(s) by reversing the transaction effect.
  /// Throws [ServerException] if transaction doesn't exist.
  Future<void> deleteTransaction(String id);

  /// Filter transactions by multiple criteria
  Future<List<TransactionModel>> filterTransactions({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    String? accountId,
    String? categoryId,
    TransactionType? type,
  });

  /// Search transactions by description
  Future<List<TransactionModel>> searchTransactions({
    required String userId,
    required String query,
  });

  /// Get transactions for a specific account
  Future<List<TransactionModel>> getTransactionsByAccount(String accountId);

  /// Get transactions for a specific category
  Future<List<TransactionModel>> getTransactionsByCategory(String categoryId);

  /// Get transactions within a date range
  Future<List<TransactionModel>> getTransactionsByDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Calculate total for a transaction type
  Future<double> getTotalByType({
    required String userId,
    required TransactionType type,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get recent transactions
  Future<List<TransactionModel>> getRecentTransactions({
    required String userId,
    int limit = 10,
  });
}
