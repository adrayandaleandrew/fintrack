import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

/// Use case for creating a new budget
///
/// Validates and creates a new budget in the system.
class CreateBudget {
  final BudgetRepository repository;

  const CreateBudget(this.repository);

  /// Execute the use case
  ///
  /// [params] - Parameters containing budget to create
  /// Returns created budget with generated ID or failure
  Future<Either<Failure, Budget>> call(CreateBudgetParams params) async {
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

    return await repository.createBudget(budget: params.budget);
  }
}

/// Parameters for CreateBudget use case
class CreateBudgetParams extends Equatable {
  final Budget budget;

  const CreateBudgetParams({required this.budget});

  @override
  List<Object?> get props => [budget];
}
