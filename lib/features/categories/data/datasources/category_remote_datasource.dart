import '../../domain/entities/category.dart';
import '../models/category_model.dart';

/// Remote data source interface for categories
///
/// Defines the contract for remote API calls.
/// Throws exceptions on error (converted to Failures in repository).
abstract class CategoryRemoteDataSource {
  /// Gets all categories for a user
  ///
  /// [userId] - The ID of the user
  /// [type] - Optional filter by category type
  ///
  /// Returns [List<CategoryModel>]
  /// Throws [ServerException] on server error
  /// Throws [NetworkException] on network error
  Future<List<CategoryModel>> getCategories({
    required String userId,
    CategoryType? type,
  });

  /// Gets a single category by ID
  ///
  /// [categoryId] - The ID of the category
  ///
  /// Returns [CategoryModel]
  /// Throws [NotFoundException] if category not found
  /// Throws [ServerException] on server error
  Future<CategoryModel> getCategoryById({
    required String categoryId,
  });

  /// Creates a new category
  ///
  /// Returns [CategoryModel]
  /// Throws [ValidationException] on validation error
  /// Throws [ServerException] on server error
  Future<CategoryModel> createCategory({
    required String userId,
    required String name,
    required CategoryType type,
    required String icon,
    required String color,
    int sortOrder = 0,
  });

  /// Updates an existing category
  ///
  /// Returns [CategoryModel]
  /// Throws [NotFoundException] if category not found
  /// Throws [ValidationException] if trying to update default category
  /// Throws [ServerException] on server error
  Future<CategoryModel> updateCategory({
    required String categoryId,
    String? name,
    String? icon,
    String? color,
    int? sortOrder,
  });

  /// Deletes a category
  ///
  /// Throws [NotFoundException] if category not found
  /// Throws [ValidationException] if trying to delete default category
  /// Throws [ServerException] on server error
  Future<void> deleteCategory({
    required String categoryId,
  });

  /// Gets default categories
  ///
  /// Returns [List<CategoryModel>]
  Future<List<CategoryModel>> getDefaultCategories();

  /// Initializes default categories for a user
  ///
  /// Creates all default categories for a new user.
  ///
  /// Returns [List<CategoryModel>]
  /// Throws [ServerException] on server error
  Future<List<CategoryModel>> initializeDefaultCategories({
    required String userId,
  });
}
