import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

/// Use case for getting a single category by ID
class GetCategoryById {
  final CategoryRepository repository;

  GetCategoryById({required this.repository});

  Future<Either<Failure, Category>> call(GetCategoryByIdParams params) async {
    return await repository.getCategoryById(categoryId: params.categoryId);
  }
}

/// Parameters for GetCategoryById use case
class GetCategoryByIdParams {
  final String categoryId;

  GetCategoryByIdParams({required this.categoryId});
}
