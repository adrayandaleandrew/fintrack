import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/encrypted_box_helper.dart';
import '../models/account_model.dart';
import 'account_local_datasource.dart';

/// Implementation of AccountLocalDataSource using encrypted Hive storage
///
/// All data is encrypted using AES-256 encryption with keys stored in secure storage.
/// Uses Hive box for caching accounts locally.
class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  final EncryptedBoxHelper _boxHelper;

  static const String _boxName = 'accounts';

  const AccountLocalDataSourceImpl({required EncryptedBoxHelper boxHelper})
      : _boxHelper = boxHelper;

  Future<Box> _getBox() async {
    return await _boxHelper.openBox(_boxName);
  }

  @override
  Future<void> cacheAccounts(List<AccountModel> accounts) async {
    try {
      final box = await _getBox();

      // Group accounts by userId
      final accountsByUser = <String, List<Map<String, dynamic>>>{};

      for (final account in accounts) {
        final userId = account.userId;
        accountsByUser[userId] ??= [];
        accountsByUser[userId]!.add(account.toJson());
      }

      // Store each user's accounts
      for (final entry in accountsByUser.entries) {
        await box.put(
          'user_${entry.key}_accounts',
          json.encode(entry.value),
        );
      }
    } catch (e) {
      throw CacheException('Failed to cache accounts: ${e.toString()}');
    }
  }

  @override
  Future<List<AccountModel>> getCachedAccounts({
    required String userId,
  }) async {
    try {
      final box = await _getBox();
      final key = 'user_${userId}_accounts';
      final cachedData = box.get(key);

      if (cachedData == null) {
        throw CacheException('No cached accounts found for user: $userId');
      }

      final accountsList = json.decode(cachedData as String) as List;
      return accountsList
          .map((json) => AccountModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(
        'Failed to get cached accounts: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> cacheAccount(AccountModel account) async {
    try {
      final box = await _getBox();

      // Cache individual account
      await box.put(
        'account_${account.id}',
        json.encode(account.toJson()),
      );

      // Also update the user's accounts list
      try {
        final accounts = await getCachedAccounts(userId: account.userId);
        final index = accounts.indexWhere((a) => a.id == account.id);

        if (index != -1) {
          accounts[index] = account;
        } else {
          accounts.add(account);
        }

        await cacheAccounts(accounts);
      } catch (e) {
        // If no cached accounts exist, create new list
        await cacheAccounts([account]);
      }
    } catch (e) {
      throw CacheException('Failed to cache account: ${e.toString()}');
    }
  }

  @override
  Future<AccountModel> getCachedAccount({
    required String accountId,
  }) async {
    try {
      final box = await _getBox();
      final key = 'account_$accountId';
      final cachedData = box.get(key);

      if (cachedData == null) {
        throw CacheException('No cached account found with ID: $accountId');
      }

      final accountJson = json.decode(cachedData as String) as Map<String, dynamic>;
      return AccountModel.fromJson(accountJson);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(
        'Failed to get cached account: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> removeCachedAccount({required String accountId}) async {
    try {
      final box = await _getBox();

      // Get account to find userId
      final account = await getCachedAccount(accountId: accountId);

      // Remove individual account
      await box.delete('account_$accountId');

      // Update user's accounts list
      try {
        final accounts = await getCachedAccounts(userId: account.userId);
        accounts.removeWhere((a) => a.id == accountId);
        await cacheAccounts(accounts);
      } catch (e) {
        // Ignore if user's list doesn't exist
      }
    } catch (e) {
      throw CacheException(
        'Failed to remove cached account: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }
}
