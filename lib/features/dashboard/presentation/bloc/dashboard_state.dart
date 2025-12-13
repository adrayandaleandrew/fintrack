import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_summary.dart';

/// Base class for all dashboard states
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial state when BLoC is created
class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

/// State when dashboard is being loaded
class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

/// State when dashboard data is successfully loaded
class DashboardLoaded extends DashboardState {
  final DashboardSummary summary;

  const DashboardLoaded({required this.summary});

  @override
  List<Object?> get props => [summary];
}

/// State when dashboard data fails to load
class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}
