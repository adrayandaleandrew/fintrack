import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

/// Use case for getting all categories
///
/// Retrieves categories for a user, optionally filtered by type.
class GetCategories {
  final CategoryRepository repository;

  GetCategories({required this.repository});

  Future<Either<Failure, List<Category>>> call(GetCategoriesParams params) async {
    return await repository.getCategories(
      userId: params.userId,
      type: params.type,
    );
  }
}

/// Parameters for GetCategories use case
class GetCategoriesParams {
  final String userId;
  final CategoryType? type;

  GetCategoriesParams({
    required this.userId,
    this.type,
  });
}
