part of 'net_worth_report_bloc.dart';

/// Inputs of [NetWorthReportBloc].
sealed class NetWorthReportEvent extends Equatable {
  const NetWorthReportEvent();

  @override
  List<Object?> get props => const [];
}

/// Load (or reload after an error) the range shown.
final class NetWorthReportLoadRequested extends NetWorthReportEvent {
  const NetWorthReportLoadRequested();
}

/// Show the report of [range].
final class NetWorthReportRangeChanged extends NetWorthReportEvent {
  const NetWorthReportRangeChanged(this.range);

  final TimeRange range;

  @override
  List<Object?> get props => [range];
}
