import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction.dart';

/// Repository interface for transaction operations
///
/// Defines the contract for transaction data access.
/// Implementations handle data sources (remote API, local cache).
abstract class TransactionRepository {
  /// Get all transactions for a user
  ///
  /// Returns list of transactions ordered by date (newest first)
  Future<Either<Failure, List<Transaction>>> getTransactions(String userId);

  /// Get a single transaction by ID
  ///
  /// Returns transaction if found, otherwise returns Failure
  Future<Either<Failure, Transaction>> getTransactionById(String id);

  /// Create a new transaction
  ///
  /// Validates transaction data and updates account balance(s).
  /// For transfers, updates both source and destination account balances.
  Future<Either<Failure, Transaction>> createTransaction(Transaction transaction);

  /// Update an existing transaction
  ///
  /// Recalculates account balances based on the difference between old and new values.
  /// Cannot change transaction type (income/expense/transfer).
  Future<Either<Failure, Transaction>> updateTransaction(Transaction transaction);

  /// Delete a transaction
  ///
  /// Restores account balance(s) by reversing the transaction effect.
  Future<Either<Failure, void>> deleteTransaction(String id);

  /// Filter transactions by multiple criteria
  ///
  /// Supports filtering by:
  /// - Date range (startDate, endDate)
  /// - Account ID
  /// - Category ID
  /// - Transaction type
  Future<Either<Failure, List<Transaction>>> filterTransactions({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    String? accountId,
    String? categoryId,
    TransactionType? type,
  });

  /// Search transactions by description
  ///
  /// Case-insensitive search in transaction descriptions and notes.
  Future<Either<Failure, List<Transaction>>> searchTransactions({
    required String userId,
    required String query,
  });

  /// Get transactions for a specific account
  ///
  /// Returns all transactions associated with the account (including transfers).
  Future<Either<Failure, List<Transaction>>> getTransactionsByAccount(
    String accountId,
  );

  /// Get transactions for a specific category
  ///
  /// Returns all transactions in the category.
  Future<Either<Failure, List<Transaction>>> getTransactionsByCategory(
    String categoryId,
  );

  /// Get transactions within a date range
  ///
  /// Useful for monthly reports and budget tracking.
  Future<Either<Failure, List<Transaction>>> getTransactionsByDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Calculate total for a transaction type
  ///
  /// Useful for dashboard summaries (total income, total expenses).
  Future<Either<Failure, double>> getTotalByType({
    required String userId,
    required TransactionType type,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get recent transactions
  ///
  /// Returns the most recent N transactions for dashboard display.
  Future<Either<Failure, List<Transaction>>> getRecentTransactions({
    required String userId,
    int limit = 10,
  });
}
