import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import 'auth_local_datasource.dart';

/// Implementation of AuthLocalDataSource
///
/// Uses SharedPreferences for user data caching
/// and FlutterSecureStorage for secure token storage.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  // Keys for storage
  static const String _cachedUserKey = 'CACHED_USER';
  static const String _authTokenKey = 'AUTH_TOKEN';
  static const String _isLoggedInKey = 'IS_LOGGED_IN';

  const AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.secureStorage,
  });

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await sharedPreferences.setString(_cachedUserKey, userJson);
      await sharedPreferences.setBool(_isLoggedInKey, true);
    } catch (e) {
      throw CacheException('Failed to cache user: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> getCachedUser() async {
    try {
      final userJson = sharedPreferences.getString(_cachedUserKey);

      if (userJson == null) {
        throw CacheException('No cached user found');
      }

      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Failed to get cached user: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await sharedPreferences.remove(_cachedUserKey);
      await sharedPreferences.setBool(_isLoggedInKey, false);
    } catch (e) {
      throw CacheException('Failed to clear cached user: ${e.toString()}');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final isLoggedIn = sharedPreferences.getBool(_isLoggedInKey);
      return isLoggedIn ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> storeAuthToken(String token) async {
    try {
      await secureStorage.write(key: _authTokenKey, value: token);
    } catch (e) {
      throw CacheException('Failed to store auth token: ${e.toString()}');
    }
  }

  @override
  Future<String> getAuthToken() async {
    try {
      final token = await secureStorage.read(key: _authTokenKey);

      if (token == null) {
        throw CacheException('No auth token found');
      }

      return token;
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException('Failed to get auth token: ${e.toString()}');
    }
  }

  @override
  Future<void> clearAuthToken() async {
    try {
      await secureStorage.delete(key: _authTokenKey);
    } catch (e) {
      throw CacheException('Failed to clear auth token: ${e.toString()}');
    }
  }
}
