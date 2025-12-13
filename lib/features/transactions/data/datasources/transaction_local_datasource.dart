import '../models/transaction_model.dart';
import '../../domain/entities/transaction.dart';

/// Local data source for transaction caching
///
/// Handles offline storage using Hive.
abstract class TransactionLocalDataSource {
  /// Cache all transactions for a user
  Future<void> cacheTransactions(String userId, List<TransactionModel> transactions);

  /// Get cached transactions for a user
  ///
  /// Throws [CacheException] if no cached data found
  Future<List<TransactionModel>> getCachedTransactions(String userId);

  /// Cache a single transaction
  Future<void> cacheTransaction(TransactionModel transaction);

  /// Get a cached transaction by ID
  ///
  /// Throws [CacheException] if transaction not found
  Future<TransactionModel> getCachedTransactionById(String id);

  /// Update a cached transaction
  Future<void> updateCachedTransaction(TransactionModel transaction);

  /// Delete a cached transaction
  Future<void> deleteCachedTransaction(String id);

  /// Clear all cached transactions for a user
  Future<void> clearCache(String userId);

  /// Filter cached transactions
  Future<List<TransactionModel>> filterCachedTransactions({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    String? accountId,
    String? categoryId,
    TransactionType? type,
  });

  /// Search cached transactions
  Future<List<TransactionModel>> searchCachedTransactions({
    required String userId,
    required String query,
  });
}
