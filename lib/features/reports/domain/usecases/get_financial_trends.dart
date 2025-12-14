import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/financial_trends.dart';
import '../repositories/reports_repository.dart';

/// Use case for getting financial trends (income vs expense over time)
///
/// Returns a series of data points for line chart visualization.
class GetFinancialTrends {
  final ReportsRepository repository;

  GetFinancialTrends(this.repository);

  Future<Either<Failure, FinancialTrends>> call(
    GetFinancialTrendsParams params,
  ) async {
    // Validate date range
    if (params.endDate.isBefore(params.startDate)) {
      return Left(
        ValidationFailure('End date must be after start date'),
      );
    }

    // Validate groupBy parameter
    if (!['day', 'week', 'month'].contains(params.groupBy)) {
      return Left(
        ValidationFailure('groupBy must be one of: day, week, month'),
      );
    }

    return await repository.getFinancialTrends(
      userId: params.userId,
      startDate: params.startDate,
      endDate: params.endDate,
      groupBy: params.groupBy,
      currencyCode: params.currencyCode,
    );
  }
}

/// Parameters for GetFinancialTrends use case
class GetFinancialTrendsParams {
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final String groupBy; // day, week, month
  final String currencyCode;

  const GetFinancialTrendsParams({
    required this.userId,
    required this.startDate,
    required this.endDate,
    this.groupBy = 'month',
    this.currencyCode = 'USD',
  });
}
