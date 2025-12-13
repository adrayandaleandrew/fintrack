import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

/// Use case for updating an existing category
class UpdateCategory {
  final CategoryRepository repository;

  UpdateCategory({required this.repository});

  Future<Either<Failure, Category>> call(UpdateCategoryParams params) async {
    return await repository.updateCategory(
      categoryId: params.categoryId,
      name: params.name,
      icon: params.icon,
      color: params.color,
      sortOrder: params.sortOrder,
    );
  }
}

/// Parameters for UpdateCategory use case
class UpdateCategoryParams {
  final String categoryId;
  final String? name;
  final String? icon;
  final String? color;
  final int? sortOrder;

  UpdateCategoryParams({
    required this.categoryId,
    this.name,
    this.icon,
    this.color,
    this.sortOrder,
  });
}
