import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/budget.dart';
import '../repositories/budget_repository.dart';

/// Use case for getting all budgets for a user
///
/// Retrieves all budgets with optional filtering for active budgets only.
class GetBudgets {
  final BudgetRepository repository;

  const GetBudgets(this.repository);

  /// Execute the use case
  ///
  /// [params] - Parameters containing userId and filter options
  /// Returns list of budgets or failure
  Future<Either<Failure, List<Budget>>> call(GetBudgetsParams params) async {
    return await repository.getBudgets(
      userId: params.userId,
      activeOnly: params.activeOnly,
    );
  }
}

/// Parameters for GetBudgets use case
class GetBudgetsParams extends Equatable {
  final String userId;
  final bool activeOnly;

  const GetBudgetsParams({
    required this.userId,
    this.activeOnly = false,
  });

  @override
  List<Object?> get props => [userId, activeOnly];
}
