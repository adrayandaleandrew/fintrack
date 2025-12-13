import '../models/category_model.dart';

/// Category local data source interface
///
/// Defines the contract for local storage of category data.
/// Handles caching categories locally for offline access.
abstract class CategoryLocalDataSource {
  /// Caches a list of categories locally
  ///
  /// Throws [CacheException] on error
  Future<void> cacheCategories(List<CategoryModel> categories);

  /// Gets cached categories for a user
  ///
  /// Returns [List<CategoryModel>] if cached
  /// Throws [CacheException] if not found or error
  Future<List<CategoryModel>> getCachedCategories({required String userId});

  /// Caches a single category
  ///
  /// Throws [CacheException] on error
  Future<void> cacheCategory(CategoryModel category);

  /// Gets a cached category by ID
  ///
  /// Returns [CategoryModel] if cached
  /// Throws [CacheException] if not found
  Future<CategoryModel> getCachedCategory({required String categoryId});

  /// Removes a category from cache
  ///
  /// Throws [CacheException] on error
  Future<void> removeCachedCategory({required String categoryId});

  /// Clears all cached categories
  ///
  /// Throws [CacheException] on error
  Future<void> clearCache();
}
