import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

/// Use case for updating an existing budget
///
/// Validates and updates a budget in the system.
class UpdateBudget {
  final BudgetRepository repository;

  const UpdateBudget(this.repository);

  /// Execute the use case
  ///
  /// [params] - Parameters containing budget to update
  /// Returns updated budget or failure
  Future<Either<Failure, Budget>> call(UpdateBudgetParams params) async {
    // Validation
    if (params.budget.amount <= 0) {
      return Left(ValidationFailure('Budget amount must be greater than zero'));
    }

    if (params.budget.alertThreshold < 0 || params.budget.alertThreshold > 100) {
      return Left(
        ValidationFailure('Alert threshold must be between 0 and 100'),
      );
    }

    if (params.budget.endDate != null &&
        params.budget.endDate!.isBefore(params.budget.startDate)) {
      return Left(ValidationFailure('End date must be after start date'));
    }

    return await repository.updateBudget(budget: params.budget);
  }
}

/// Parameters for UpdateBudget use case
class UpdateBudgetParams extends Equatable {
  final Budget budget;

  const UpdateBudgetParams({required this.budget});

  @override
  List<Object?> get props => [budget];
}
