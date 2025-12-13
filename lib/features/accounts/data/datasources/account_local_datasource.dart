import '../models/account_model.dart';

/// Account local data source interface
///
/// Defines the contract for local storage of account data.
/// Handles caching accounts locally for offline access.
abstract class AccountLocalDataSource {
  /// Caches a list of accounts locally
  ///
  /// Throws [CacheException] on error
  Future<void> cacheAccounts(List<AccountModel> accounts);

  /// Gets cached accounts for a user
  ///
  /// Returns [List<AccountModel>] if cached
  /// Throws [CacheException] if not found or error
  Future<List<AccountModel>> getCachedAccounts({required String userId});

  /// Caches a single account
  ///
  /// Throws [CacheException] on error
  Future<void> cacheAccount(AccountModel account);

  /// Gets a cached account by ID
  ///
  /// Returns [AccountModel] if cached
  /// Throws [CacheException] if not found
  Future<AccountModel> getCachedAccount({required String accountId});

  /// Removes an account from cache
  ///
  /// Throws [CacheException] on error
  Future<void> removeCachedAccount({required String accountId});

  /// Clears all cached accounts
  ///
  /// Throws [CacheException] on error
  Future<void> clearCache();
}
