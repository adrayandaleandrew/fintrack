import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/budget_repository.dart';

/// Use case for deleting a budget
///
/// Removes a budget from the system.
class DeleteBudget {
  final BudgetRepository repository;

  const DeleteBudget(this.repository);

  /// Execute the use case
  ///
  /// [params] - Parameters containing budgetId to delete
  /// Returns success or failure
  Future<Either<Failure, void>> call(DeleteBudgetParams params) async {
    return await repository.deleteBudget(budgetId: params.budgetId);
  }
}

/// Parameters for DeleteBudget use case
class DeleteBudgetParams extends Equatable {
  final String budgetId;

  const DeleteBudgetParams({required this.budgetId});

  @override
  List<Object?> get props => [budgetId];
}
