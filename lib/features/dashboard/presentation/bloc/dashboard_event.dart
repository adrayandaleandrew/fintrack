import 'package:equatable/equatable.dart';

/// Base class for all dashboard events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load dashboard summary
class LoadDashboardSummary extends DashboardEvent {
  final String userId;

  const LoadDashboardSummary({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Event to refresh dashboard data
class RefreshDashboard extends DashboardEvent {
  final String userId;

  const RefreshDashboard({required this.userId});

  @override
  List<Object?> get props => [userId];
}
