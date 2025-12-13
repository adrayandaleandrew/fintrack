import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

/// Use case for getting predefined default categories
class GetDefaultCategories {
  final CategoryRepository repository;

  GetDefaultCategories({required this.repository});

  Future<Either<Failure, List<Category>>> call() async {
    return await repository.getDefaultCategories();
  }
}
