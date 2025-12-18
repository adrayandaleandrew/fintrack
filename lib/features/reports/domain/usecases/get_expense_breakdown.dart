import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/expense_breakdown.dart';
import '../repositories/reports_repository.dart';

/// Use case for getting expense breakdown by category
///
/// Returns expenses grouped by category with percentages for pie chart.
class GetExpenseBreakdown {
  final ReportsRepository repository;

  GetExpenseBreakdown(this.repository);

  Future<Either<Failure, ExpenseBreakdown>> call(
    GetExpenseBreakdownParams params,
  ) async {
    // Validate date range
    if (params.endDate.isBefore(params.startDate)) {
      return Left(
        ValidationFailure('End date must be after start date'),
      );
    }

    return await repository.getExpenseBreakdown(
      userId: params.userId,
      startDate: params.startDate,
      endDate: params.endDate,
      currencyCode: params.currencyCode,
    );
  }
}

/// Parameters for GetExpenseBreakdown use case
class GetExpenseBreakdownParams {
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final String currencyCode;

  const GetExpenseBreakdownParams({
    required this.userId,
    required this.startDate,
    required this.endDate,
    this.currencyCode = 'USD',
  });
}
