import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/time/clock.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/dashboard_summary_entity.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/part_of_day.dart';
import 'package:pennypincher_pro/features/dashboard/domain/usecase/dashboard_use_cases.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

/// State of the dashboard. A new instance is created per screen. Every
/// request is for the month of the device's local clock; a refresh or a
/// snapshot is ignored while another one runs.
@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._getSummary, this._recordSnapshot, Clock clock)
      : _clock = clock,
        super(DashboardState(period: PartOfDay.at(clock.now()))) {
    on<DashboardLoadRequested>(_onLoadRequested);
    on<DashboardRefreshRequested>(_onRefreshRequested);
    on<DashboardSnapshotRequested>(_onSnapshotRequested);
  }

  final GetDashboardSummary _getSummary;
  final RecordNetWorthSnapshot _recordSnapshot;
  final Clock _clock;

  Future<void> _onLoadRequested(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final now = _clock.now();
    emit(DashboardState(period: PartOfDay.at(now)));
    final result = await _getSummary(now);
    emit(
      result.fold(
        (failure) => state.copyWith(
          status: DashboardStatus.failure,
          loadError: failure.message,
        ),
        (summary) =>
            state.copyWith(status: DashboardStatus.loaded, summary: summary),
      ),
    );
  }

  Future<void> _onRefreshRequested(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    if (state.summary == null || state.isBusy) {
      return;
    }
    emit(state.copyWith(refreshing: true));
    final result = await _reload();
    emit(
      result.fold(
        (failure) => state.copyWith(
          refreshing: false,
          notice: DashboardNotice.refreshFailed,
          noticeMessage: failure.message,
        ),
        (summary) => _withSummary(summary, refreshing: false),
      ),
    );
  }

  /// Saves the snapshot and reloads the summary. A reload that fails after
  /// the snapshot was saved keeps the summary shown.
  Future<void> _onSnapshotRequested(
    DashboardSnapshotRequested event,
    Emitter<DashboardState> emit,
  ) async {
    if (state.summary == null || state.isBusy) {
      return;
    }
    emit(state.copyWith(recordingSnapshot: true));
    final saved = await _recordSnapshot(_clock.now());
    if (saved.isLeft()) {
      emit(
        state.copyWith(
          recordingSnapshot: false,
          notice: DashboardNotice.snapshotFailed,
          noticeMessage: saved.fold((failure) => failure.message, (_) => null),
        ),
      );
      return;
    }
    final reloaded = (await _reload()).fold((_) => state, _withSummary);
    emit(
      reloaded.copyWith(
        recordingSnapshot: false,
        notice: DashboardNotice.snapshotSaved,
      ),
    );
  }

  Future<Either<Failure, DashboardSummary>> _reload() =>
      _getSummary(_clock.now());

  DashboardState _withSummary(DashboardSummary summary, {bool? refreshing}) =>
      state.copyWith(
        summary: summary,
        period: PartOfDay.at(_clock.now()),
        refreshing: refreshing,
      );
}
