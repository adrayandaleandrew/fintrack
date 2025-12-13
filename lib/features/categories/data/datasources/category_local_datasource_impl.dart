import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/category_model.dart';
import 'category_local_datasource.dart';

/// Implementation of CategoryLocalDataSource using Hive
///
/// Uses Hive box for caching categories locally.
class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final HiveInterface hive;

  static const String _boxName = 'categories';

  const CategoryLocalDataSourceImpl({required this.hive});

  Future<Box> _getBox() async {
    if (!hive.isBoxOpen(_boxName)) {
      return await hive.openBox(_boxName);
    }
    return hive.box(_boxName);
  }

  @override
  Future<void> cacheCategories(List<CategoryModel> categories) async {
    try {
      final box = await _getBox();

      // Group categories by userId
      final categoriesByUser = <String, List<Map<String, dynamic>>>{};

      for (final category in categories) {
        final userId = category.userId;
        categoriesByUser[userId] ??= [];
        categoriesByUser[userId]!.add(category.toJson());
      }

      // Store each user's categories
      for (final entry in categoriesByUser.entries) {
        await box.put(
          'user_${entry.key}_categories',
          json.encode(entry.value),
        );
      }
    } catch (e) {
      throw CacheException('Failed to cache categories: ${e.toString()}');
    }
  }

  @override
  Future<List<CategoryModel>> getCachedCategories({
    required String userId,
  }) async {
    try {
      final box = await _getBox();
      final key = 'user_${userId}_categories';
      final cachedData = box.get(key);

      if (cachedData == null) {
        throw CacheException('No cached categories found for user: $userId');
      }

      final categoriesList = json.decode(cachedData as String) as List;
      return categoriesList
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(
        'Failed to get cached categories: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> cacheCategory(CategoryModel category) async {
    try {
      final box = await _getBox();

      // Cache individual category
      await box.put(
        'category_${category.id}',
        json.encode(category.toJson()),
      );

      // Also update the user's categories list
      try {
        final categories = await getCachedCategories(userId: category.userId);
        final index = categories.indexWhere((c) => c.id == category.id);

        if (index != -1) {
          categories[index] = category;
        } else {
          categories.add(category);
        }

        await cacheCategories(categories);
      } catch (e) {
        // If no cached categories exist, create new list
        await cacheCategories([category]);
      }
    } catch (e) {
      throw CacheException('Failed to cache category: ${e.toString()}');
    }
  }

  @override
  Future<CategoryModel> getCachedCategory({
    required String categoryId,
  }) async {
    try {
      final box = await _getBox();
      final key = 'category_$categoryId';
      final cachedData = box.get(key);

      if (cachedData == null) {
        throw CacheException('No cached category found with ID: $categoryId');
      }

      final categoryJson =
          json.decode(cachedData as String) as Map<String, dynamic>;
      return CategoryModel.fromJson(categoryJson);
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(
        'Failed to get cached category: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> removeCachedCategory({required String categoryId}) async {
    try {
      final box = await _getBox();

      // Get category to find userId
      final category = await getCachedCategory(categoryId: categoryId);

      // Remove individual category
      await box.delete('category_$categoryId');

      // Update user's categories list
      try {
        final categories = await getCachedCategories(userId: category.userId);
        categories.removeWhere((c) => c.id == categoryId);
        await cacheCategories(categories);
      } catch (e) {
        // Ignore if user's list doesn't exist
      }
    } catch (e) {
      throw CacheException(
        'Failed to remove cached category: ${e.toString()}',
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
