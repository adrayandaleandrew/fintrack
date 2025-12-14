import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/monthly_comparison.dart';
import '../repositories/reports_repository.dart';

/// Use case for getting monthly comparison data
///
/// Returns financial data for the last N months for bar chart visualization.
class GetMonthlyComparison {
  final ReportsRepository repository;

  GetMonthlyComparison(this.repository);

  Future<Either<Failure, MonthlyComparison>> call(
    GetMonthlyComparisonParams params,
  ) async {
    // Validate month count
    if (params.monthCount < 1) {
      return Left(
        ValidationFailure('Month count must be at least 1'),
      );
    }

    if (params.monthCount > 24) {
      return Left(
        ValidationFailure('Month count cannot exceed 24'),
      );
    }

    return await repository.getMonthlyComparison(
      userId: params.userId,
      monthCount: params.monthCount,
      currencyCode: params.currencyCode,
    );
  }
}

/// Parameters for GetMonthlyComparison use case
class GetMonthlyComparisonParams {
  final String userId;
  final int monthCount;
  final String currencyCode;

  const GetMonthlyComparisonParams({
    required this.userId,
    this.monthCount = 6,
    this.currencyCode = 'USD',
  });
}
