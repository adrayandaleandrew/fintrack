import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/category_repository.dart';

/// Use case for deleting a category
class DeleteCategory {
  final CategoryRepository repository;

  DeleteCategory({required this.repository});

  Future<Either<Failure, void>> call(DeleteCategoryParams params) async {
    return await repository.deleteCategory(categoryId: params.categoryId);
  }
}

/// Parameters for DeleteCategory use case
class DeleteCategoryParams {
  final String categoryId;

  DeleteCategoryParams({required this.categoryId});
}
