import 'package:bloc/bloc.dart';
import '../../domain/usecases/get_dashboard_summary.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// BLoC for managing dashboard state
///
/// Handles loading and refreshing dashboard summary data.
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardSummary getDashboardSummary;

  DashboardBloc({
    required this.getDashboardSummary,
  }) : super(const DashboardInitial()) {
    on<LoadDashboardSummary>(_onLoadDashboardSummary);
    on<RefreshDashboard>(_onRefreshDashboard);
  }

  /// Handle LoadDashboardSummary event
  Future<void> _onLoadDashboardSummary(
    LoadDashboardSummary event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    final result = await getDashboardSummary(
      GetDashboardSummaryParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(DashboardError(message: failure.message)),
      (summary) => emit(DashboardLoaded(summary: summary)),
    );
  }

  /// Handle RefreshDashboard event
  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    // Don't show loading for refresh, keep current state visible
    final result = await getDashboardSummary(
      GetDashboardSummaryParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(DashboardError(message: failure.message)),
      (summary) => emit(DashboardLoaded(summary: summary)),
    );
  }
}
