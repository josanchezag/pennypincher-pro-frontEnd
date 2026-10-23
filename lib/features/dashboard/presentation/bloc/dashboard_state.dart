part of 'dashboard_bloc.dart';

/// Progress of the first load of the summary.
enum DashboardStatus { loading, loaded, failure }

/// Outcome of an action, reported once (for example with a snack bar).
enum DashboardNotice { snapshotSaved, snapshotFailed, refreshFailed }

/// State of the dashboard.
///
/// Once [status] is loaded, [summary] stays visible while it is
/// [refreshing] or [recordingSnapshot]. [loadError] explains a failed first
/// load. [notice] and [noticeMessage] report the action that just ended,
/// for one state only. [period] picks the greeting, as of the last load.
final class DashboardState extends Equatable {
  const DashboardState({
    required this.period,
    this.status = DashboardStatus.loading,
    this.summary,
    this.loadError,
    this.refreshing = false,
    this.recordingSnapshot = false,
    this.notice,
    this.noticeMessage,
  });

  final PartOfDay period;
  final DashboardStatus status;
  final DashboardSummary? summary;
  final String? loadError;
  final bool refreshing;
  final bool recordingSnapshot;
  final DashboardNotice? notice;
  final String? noticeMessage;

  bool get isBusy => refreshing || recordingSnapshot;

  /// A copy without the report of a finished action.
  DashboardState copyWith({
    PartOfDay? period,
    DashboardStatus? status,
    DashboardSummary? summary,
    String? loadError,
    bool? refreshing,
    bool? recordingSnapshot,
    DashboardNotice? notice,
    String? noticeMessage,
  }) =>
      DashboardState(
        period: period ?? this.period,
        status: status ?? this.status,
        summary: summary ?? this.summary,
        loadError: loadError ?? this.loadError,
        refreshing: refreshing ?? this.refreshing,
        recordingSnapshot: recordingSnapshot ?? this.recordingSnapshot,
        notice: notice,
        noticeMessage: noticeMessage,
      );

  @override
  List<Object?> get props => [
        period,
        status,
        summary,
        loadError,
        refreshing,
        recordingSnapshot,
        notice,
        noticeMessage,
      ];
}
