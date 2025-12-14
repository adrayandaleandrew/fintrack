import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_expense_breakdown.dart';
import '../../domain/usecases/get_financial_trends.dart';
import '../../domain/usecases/get_monthly_comparison.dart';
import 'reports_event.dart';
import 'reports_state.dart';

/// BLoC for managing reports state
///
/// Handles fetching and displaying various financial reports and analytics.
class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final GetExpenseBreakdown getExpenseBreakdown;
  final GetFinancialTrends getFinancialTrends;
  final GetMonthlyComparison getMonthlyComparison;

  ReportsBloc({
    required this.getExpenseBreakdown,
    required this.getFinancialTrends,
    required this.getMonthlyComparison,
  }) : super(const ReportsInitial()) {
    on<LoadExpenseBreakdown>(_onLoadExpenseBreakdown);
    on<LoadFinancialTrends>(_onLoadFinancialTrends);
    on<LoadMonthlyComparison>(_onLoadMonthlyComparison);
    on<ExportReportToCsv>(_onExportReportToCsv);
  }

  /// Load expense breakdown report
  Future<void> _onLoadExpenseBreakdown(
    LoadExpenseBreakdown event,
    Emitter<ReportsState> emit,
  ) async {
    emit(const ReportsLoading());

    final result = await getExpenseBreakdown(
      GetExpenseBreakdownParams(
        userId: event.userId,
        startDate: event.startDate,
        endDate: event.endDate,
        currencyCode: event.currencyCode,
      ),
    );

    result.fold(
      (failure) => emit(ReportsError(message: failure.message)),
      (breakdown) => emit(ExpenseBreakdownLoaded(breakdown: breakdown)),
    );
  }

  /// Load financial trends report
  Future<void> _onLoadFinancialTrends(
    LoadFinancialTrends event,
    Emitter<ReportsState> emit,
  ) async {
    emit(const ReportsLoading());

    final result = await getFinancialTrends(
      GetFinancialTrendsParams(
        userId: event.userId,
        startDate: event.startDate,
        endDate: event.endDate,
        groupBy: event.groupBy,
        currencyCode: event.currencyCode,
      ),
    );

    result.fold(
      (failure) => emit(ReportsError(message: failure.message)),
      (trends) => emit(FinancialTrendsLoaded(trends: trends)),
    );
  }

  /// Load monthly comparison report
  Future<void> _onLoadMonthlyComparison(
    LoadMonthlyComparison event,
    Emitter<ReportsState> emit,
  ) async {
    emit(const ReportsLoading());

    final result = await getMonthlyComparison(
      GetMonthlyComparisonParams(
        userId: event.userId,
        monthCount: event.monthCount,
        currencyCode: event.currencyCode,
      ),
    );

    result.fold(
      (failure) => emit(ReportsError(message: failure.message)),
      (comparison) => emit(MonthlyComparisonLoaded(comparison: comparison)),
    );
  }

  /// Export report to CSV
  Future<void> _onExportReportToCsv(
    ExportReportToCsv event,
    Emitter<ReportsState> emit,
  ) async {
    // TODO: Implement CSV export
    emit(
      const ReportsError(
        message: 'CSV export not yet implemented',
      ),
    );
  }
}
