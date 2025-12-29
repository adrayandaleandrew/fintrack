import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/encrypted_box_helper.dart';
import '../models/transaction_model.dart';
import '../../domain/entities/transaction.dart';
import 'transaction_local_datasource.dart';

/// Hive-based local data source for transaction caching with encryption
///
/// All data is encrypted using AES-256 encryption with keys stored in secure storage.
/// Stores transactions in a Hive box with the structure:
/// Box<Map<String, dynamic>> where key is userId and value is List of transactions
class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final EncryptedBoxHelper _boxHelper;
  static const String _boxName = 'transactions';

  TransactionLocalDataSourceImpl({required EncryptedBoxHelper boxHelper})
      : _boxHelper = boxHelper;

  /// Get or open the encrypted Hive box
  Future<Box<Map<dynamic, dynamic>>> _getBox() async {
    return await _boxHelper.openBox<Map<dynamic, dynamic>>(_boxName);
  }

  @override
  Future<void> cacheTransactions(
    String userId,
    List<TransactionModel> transactions,
  ) async {
    try {
      final box = await _getBox();

      // Convert transactions to JSON
      final transactionsJson = transactions.map((t) => t.toJson()).toList();

      // Store with userId as key
      await box.put(userId, {'transactions': transactionsJson});
    } catch (e) {
      throw CacheException('Failed to cache transactions: ${e.toString()}');
    }
  }

  @override
  Future<List<TransactionModel>> getCachedTransactions(String userId) async {
    try {
      final box = await _getBox();

      final data = box.get(userId);

      if (data == null || data['transactions'] == null) {
        throw CacheException('No cached transactions found for user');
      }

      final transactionsJson = (data['transactions'] as List)
          .map((json) => Map<String, dynamic>.from(json as Map))
          .toList();

      return transactionsJson
          .map((json) => TransactionModel.fromJson(json))
          .toList();
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Failed to get cached transactions: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheTransaction(TransactionModel transaction) async {
    try {
      // Get existing transactions
      List<TransactionModel> transactions;
      try {
        transactions = await getCachedTransactions(transaction.userId);
      } catch (_) {
        transactions = [];
      }

      // Add new transaction
      transactions.add(transaction);

      // Save back to cache
      await cacheTransactions(transaction.userId, transactions);
    } catch (e) {
      throw CacheException('Failed to cache transaction: ${e.toString()}');
    }
  }

  @override
  Future<TransactionModel> getCachedTransactionById(String id) async {
    try {
      final box = await _getBox();

      // Search through all users' transactions
      for (final key in box.keys) {
        final data = box.get(key);
        if (data != null && data['transactions'] != null) {
          final transactionsJson = (data['transactions'] as List)
              .map((json) => Map<String, dynamic>.from(json as Map))
              .toList();

          for (final json in transactionsJson) {
            if (json['id'] == id) {
              return TransactionModel.fromJson(json);
            }
          }
        }
      }

      throw CacheException('Transaction not found in cache');
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Failed to get cached transaction: ${e.toString()}');
    }
  }

  @override
  Future<void> updateCachedTransaction(TransactionModel transaction) async {
    try {
      // Get existing transactions
      final transactions = await getCachedTransactions(transaction.userId);

      // Find and update
      final index = transactions.indexWhere((t) => t.id == transaction.id);

      if (index == -1) {
        throw CacheException('Transaction not found in cache');
      }

      transactions[index] = transaction;

      // Save back to cache
      await cacheTransactions(transaction.userId, transactions);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Failed to update cached transaction: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteCachedTransaction(String id) async {
    try {
      // Find the transaction to get userId
      final transaction = await getCachedTransactionById(id);

      // Get existing transactions
      final transactions = await getCachedTransactions(transaction.userId);

      // Remove transaction
      transactions.removeWhere((t) => t.id == id);

      // Save back to cache
      await cacheTransactions(transaction.userId, transactions);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Failed to delete cached transaction: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache(String userId) async {
    try {
      final box = await _getBox();
      await box.delete(userId);
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }

  @override
  Future<List<TransactionModel>> filterCachedTransactions({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    String? accountId,
    String? categoryId,
    TransactionType? type,
  }) async {
    try {
      var transactions = await getCachedTransactions(userId);

      // Apply filters
      if (startDate != null) {
        transactions = transactions
            .where((t) =>
                t.date.isAfter(startDate) ||
                t.date.isAtSameMomentAs(startDate))
            .toList();
      }

      if (endDate != null) {
        transactions = transactions
            .where((t) =>
                t.date.isBefore(endDate) || t.date.isAtSameMomentAs(endDate))
            .toList();
      }

      if (accountId != null) {
        transactions = transactions
            .where((t) => t.accountId == accountId || t.toAccountId == accountId)
            .toList();
      }

      if (categoryId != null) {
        transactions = transactions
            .where((t) => t.categoryId == categoryId)
            .toList();
      }

      if (type != null) {
        transactions = transactions.where((t) => t.type == type).toList();
      }

      // Sort by date (newest first)
      transactions.sort((a, b) => b.date.compareTo(a.date));

      return transactions;
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Failed to filter cached transactions: ${e.toString()}');
    }
  }

  @override
  Future<List<TransactionModel>> searchCachedTransactions({
    required String userId,
    required String query,
  }) async {
    try {
      final transactions = await getCachedTransactions(userId);
      final lowerQuery = query.toLowerCase();

      final results = transactions.where((t) {
        final matchesDescription =
            t.description.toLowerCase().contains(lowerQuery);
        final matchesNotes =
            t.notes?.toLowerCase().contains(lowerQuery) ?? false;
        return matchesDescription || matchesNotes;
      }).toList();

      // Sort by date (newest first)
      results.sort((a, b) => b.date.compareTo(a.date));

      return results;
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Failed to search cached transactions: ${e.toString()}');
    }
  }
}
