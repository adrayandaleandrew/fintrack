import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_datasource.dart';
import '../datasources/category_remote_datasource.dart';

/// Implementation of CategoryRepository
///
/// Coordinates between remote and local data sources.
/// Handles data flow and error transformation.
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;
  final CategoryLocalDataSource localDataSource;

  const CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Category>>> getCategories({
    required String userId,
    CategoryType? type,
  }) async {
    try {
      // Try to get from remote
      final categories = await remoteDataSource.getCategories(
        userId: userId,
        type: type,
      );

      // Cache the categories
      await localDataSource.cacheCategories(categories);

      return Right(categories);
    } on ServerException catch (e) {
      // If remote fails, try to get from cache
      try {
        final cachedCategories = await localDataSource.getCachedCategories(
          userId: userId,
        );

        // Apply type filter if needed
        if (type != null) {
          final filtered = cachedCategories
              .where((category) => category.type == type)
              .toList();
          return Right(filtered);
        }

        return Right(cachedCategories);
      } on CacheException {
        return Left(ServerFailure(e.message));
      }
    } on NetworkException catch (e) {
      // Try cache on network error
      try {
        final cachedCategories = await localDataSource.getCachedCategories(
          userId: userId,
        );

        // Apply type filter if needed
        if (type != null) {
          final filtered = cachedCategories
              .where((category) => category.type == type)
              .toList();
          return Right(filtered);
        }

        return Right(cachedCategories);
      } on CacheException {
        return Left(NetworkFailure(e.message));
      }
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> getCategoryById({
    required String categoryId,
  }) async {
    try {
      final category = await remoteDataSource.getCategoryById(
        categoryId: categoryId,
      );

      // Cache the category
      await localDataSource.cacheCategory(category);

      return Right(category);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      // Try cache on server error
      try {
        final cachedCategory = await localDataSource.getCachedCategory(
          categoryId: categoryId,
        );
        return Right(cachedCategory);
      } on CacheException {
        return Left(ServerFailure(e.message));
      }
    } on NetworkException catch (e) {
      // Try cache on network error
      try {
        final cachedCategory = await localDataSource.getCachedCategory(
          categoryId: categoryId,
        );
        return Right(cachedCategory);
      } on CacheException {
        return Left(NetworkFailure(e.message));
      }
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> createCategory({
    required String userId,
    required String name,
    required CategoryType type,
    required String icon,
    required String color,
    int sortOrder = 0,
  }) async {
    try {
      final category = await remoteDataSource.createCategory(
        userId: userId,
        name: name,
        type: type,
        icon: icon,
        color: color,
        sortOrder: sortOrder,
      );

      // Cache the new category
      await localDataSource.cacheCategory(category);

      return Right(category);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> updateCategory({
    required String categoryId,
    String? name,
    String? icon,
    String? color,
    int? sortOrder,
  }) async {
    try {
      final category = await remoteDataSource.updateCategory(
        categoryId: categoryId,
        name: name,
        icon: icon,
        color: color,
        sortOrder: sortOrder,
      );

      // Update cache
      await localDataSource.cacheCategory(category);

      return Right(category);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory({
    required String categoryId,
  }) async {
    try {
      await remoteDataSource.deleteCategory(categoryId: categoryId);

      // Remove from cache
      await localDataSource.removeCachedCategory(categoryId: categoryId);

      return const Right(null);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getDefaultCategories() async {
    try {
      final categories = await remoteDataSource.getDefaultCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> initializeDefaultCategories({
    required String userId,
  }) async {
    try {
      final categories = await remoteDataSource.initializeDefaultCategories(
        userId: userId,
      );

      // Cache the default categories
      await localDataSource.cacheCategories(categories);

      return Right(categories);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
