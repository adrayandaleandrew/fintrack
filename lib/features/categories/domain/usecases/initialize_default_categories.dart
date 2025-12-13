import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

/// Use case for initializing default categories for a new user
class InitializeDefaultCategories {
  final CategoryRepository repository;

  InitializeDefaultCategories({required this.repository});

  Future<Either<Failure, List<Category>>> call(
    InitializeDefaultCategoriesParams params,
  ) async {
    return await repository.initializeDefaultCategories(userId: params.userId);
  }
}

/// Parameters for InitializeDefaultCategories use case
class InitializeDefaultCategoriesParams {
  final String userId;

  InitializeDefaultCategoriesParams({required this.userId});
}
