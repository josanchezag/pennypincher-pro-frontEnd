part of 'net_worth_report_bloc.dart';

/// Progress of loading a report.
enum ReportStatus { loading, loaded, failure }

/// State of the net worth report of [range]: its [trend] once loaded, or
/// the [error] that stopped it.
final class NetWorthReportState extends Equatable {
  const NetWorthReportState({
    this.range = defaultRange,
    this.status = ReportStatus.loading,
    this.trend,
    this.error,
  });

  static const TimeRange defaultRange = TimeRange.oneYear;

  final TimeRange range;
  final ReportStatus status;
  final NetWorthTrend? trend;
  final String? error;

  @override
  List<Object?> get props => [range, status, trend, error];
}
