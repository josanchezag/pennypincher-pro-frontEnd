part of 'dashboard_bloc.dart';

/// Inputs of [DashboardBloc].
sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => const [];
}

/// Load the summary from scratch: when the screen opens or after an error.
final class DashboardLoadRequested extends DashboardEvent {
  const DashboardLoadRequested();
}

/// Reload the summary keeping the current one visible meanwhile.
final class DashboardRefreshRequested extends DashboardEvent {
  const DashboardRefreshRequested();
}

/// Save the net worth snapshot of the current month, then reload.
final class DashboardSnapshotRequested extends DashboardEvent {
  const DashboardSnapshotRequested();
}
