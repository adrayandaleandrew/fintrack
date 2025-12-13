import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

/// Use case for creating a new category
class CreateCategory {
  final CategoryRepository repository;

  CreateCategory({required this.repository});

  Future<Either<Failure, Category>> call(CreateCategoryParams params) async {
    return await repository.createCategory(
      userId: params.userId,
      name: params.name,
      type: params.type,
      icon: params.icon,
      color: params.color,
      sortOrder: params.sortOrder,
    );
  }
}

/// Parameters for CreateCategory use case
class CreateCategoryParams {
  final String userId;
  final String name;
  final CategoryType type;
  final String icon;
  final String color;
  final int sortOrder;

  CreateCategoryParams({
    required this.userId,
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    this.sortOrder = 0,
  });
}
