import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/budget_usage.dart';
import '../repositories/budget_repository.dart';

/// Use case for calculating budget usage
///
/// Calculates how much of a budget has been spent in the current period.
class CalculateBudgetUsage {
  final BudgetRepository repository;

  const CalculateBudgetUsage(this.repository);

  /// Execute the use case
  ///
  /// [params] - Parameters containing budgetId
  /// Returns budget usage with spent amount or failure
  Future<Either<Failure, BudgetUsage>> call(
    CalculateBudgetUsageParams params,
  ) async {
    return await repository.calculateBudgetUsage(budgetId: params.budgetId);
  }
}

/// Parameters for CalculateBudgetUsage use case
class CalculateBudgetUsageParams extends Equatable {
  final String budgetId;

  const CalculateBudgetUsageParams({required this.budgetId});

  @override
  List<Object?> get props => [budgetId];
}
