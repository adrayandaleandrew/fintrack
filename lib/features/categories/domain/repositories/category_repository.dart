import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';

/// Repository interface for category operations
///
/// Defines the contract for category data access.
/// Implementations handle data fetching from remote and local sources.
abstract class CategoryRepository {
  /// Gets all categories for a user
  ///
  /// [userId] - The ID of the user
  /// [type] - Optional filter by category type (Income/Expense)
  ///
  /// Returns [Either<Failure, List<Category>>]
  Future<Either<Failure, List<Category>>> getCategories({
    required String userId,
    CategoryType? type,
  });

  /// Gets a single category by ID
  ///
  /// [categoryId] - The ID of the category to retrieve
  ///
  /// Returns [Either<Failure, Category>]
  Future<Either<Failure, Category>> getCategoryById({
    required String categoryId,
  });

  /// Creates a new custom category
  ///
  /// [userId] - The ID of the user creating the category
  /// [name] - Name of the category
  /// [type] - Type of category (Income/Expense)
  /// [icon] - Icon identifier
  /// [color] - Color hex code
  /// [sortOrder] - Optional sort order (default 0)
  ///
  /// Returns [Either<Failure, Category>]
  Future<Either<Failure, Category>> createCategory({
    required String userId,
    required String name,
    required CategoryType type,
    required String icon,
    required String color,
    int sortOrder = 0,
  });

  /// Updates an existing category
  ///
  /// Only custom categories can be updated (isDefault = false).
  /// Default categories cannot be modified.
  ///
  /// [categoryId] - The ID of the category to update
  /// [name] - New name (optional)
  /// [icon] - New icon (optional)
  /// [color] - New color (optional)
  /// [sortOrder] - New sort order (optional)
  ///
  /// Returns [Either<Failure, Category>]
  Future<Either<Failure, Category>> updateCategory({
    required String categoryId,
    String? name,
    String? icon,
    String? color,
    int? sortOrder,
  });

  /// Deletes a custom category
  ///
  /// Only custom categories can be deleted (isDefault = false).
  /// Default categories cannot be deleted.
  ///
  /// [categoryId] - The ID of the category to delete
  ///
  /// Returns [Either<Failure, void>]
  Future<Either<Failure, void>> deleteCategory({
    required String categoryId,
  });

  /// Gets default categories
  ///
  /// Returns predefined system categories (10 income, 15 expense).
  /// Default categories are created automatically for new users.
  ///
  /// Returns [Either<Failure, List<Category>>]
  Future<Either<Failure, List<Category>>> getDefaultCategories();

  /// Initializes default categories for a new user
  ///
  /// Creates all default categories for a user.
  /// Should be called during user registration.
  ///
  /// [userId] - The ID of the new user
  ///
  /// Returns [Either<Failure, List<Category>>]
  Future<Either<Failure, List<Category>>> initializeDefaultCategories({
    required String userId,
  });
}
