import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/time/clock.dart';
import 'package:pennypincher_pro/core/time/time_range.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_trend_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/usecase/net_worth_use_cases.dart';

part 'net_worth_report_event.dart';
part 'net_worth_report_state.dart';

/// State of the net worth report. A new instance is created per screen and
/// opens on [NetWorthReportState.defaultRange]. Ranges start at a month of
/// the device's local clock; a result that arrives after the user picked
/// another range is dropped.
@injectable
class NetWorthReportBloc
    extends Bloc<NetWorthReportEvent, NetWorthReportState> {
  NetWorthReportBloc(this._getTrend, this._clock)
      : super(const NetWorthReportState()) {
    on<NetWorthReportLoadRequested>((_, emit) => _load(state.range, emit));
    on<NetWorthReportRangeChanged>(_onRangeChanged);
  }

  final GetNetWorthTrend _getTrend;
  final Clock _clock;

  Future<void> _onRangeChanged(
    NetWorthReportRangeChanged event,
    Emitter<NetWorthReportState> emit,
  ) async {
    if (event.range != state.range) {
      await _load(event.range, emit);
    }
  }

  Future<void> _load(
    TimeRange range,
    Emitter<NetWorthReportState> emit,
  ) async {
    emit(NetWorthReportState(range: range));
    final result = await _getTrend(from: range.startFor(_clock.now()));
    if (state.range != range) {
      return;
    }
    emit(
      result.fold(
        (failure) => NetWorthReportState(
          range: range,
          status: ReportStatus.failure,
          error: failure.message,
        ),
        (trend) => NetWorthReportState(
          range: range,
          status: ReportStatus.loaded,
          trend: trend,
        ),
      ),
    );
  }
}
