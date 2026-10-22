import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/time/clock.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_snapshot_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_summary_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/usecase/net_worth_use_cases.dart';

part 'net_worth_event.dart';
part 'net_worth_state.dart';

/// State of the net worth overview. A new instance is created per screen.
@injectable
class NetWorthBloc extends Bloc<NetWorthEvent, NetWorthState> {
  NetWorthBloc(
    this._getCurrent,
    this._getSnapshots,
    this._createSnapshot,
    this._clock,
  ) : super(const NetWorthLoading()) {
    on<NetWorthLoadRequested>(_onLoadRequested);
    on<NetWorthSnapshotRequested>(_onSnapshotRequested);
  }

  final GetCurrentNetWorth _getCurrent;
  final GetNetWorthSnapshots _getSnapshots;
  final CreateSnapshot _createSnapshot;
  final Clock _clock;

  /// Both requests run in parallel; the first failure is reported.
  Future<void> _onLoadRequested(
    NetWorthLoadRequested event,
    Emitter<NetWorthState> emit,
  ) async {
    emit(const NetWorthLoading());
    final currentRequest = _getCurrent();
    final history = await _getSnapshots();
    final current = await currentRequest;
    emit(
      current.fold(
        (failure) => NetWorthLoadFailure(failure.message),
        (summary) => history.fold(
          (failure) => NetWorthLoadFailure(failure.message),
          (snapshots) => NetWorthLoaded(
            current: summary,
            history: snapshots,
            month: NetWorthSnapshot.monthOf(_clock.now()),
          ),
        ),
      ),
    );
  }

  Future<void> _onSnapshotRequested(
    NetWorthSnapshotRequested event,
    Emitter<NetWorthState> emit,
  ) async {
    final loaded = state;
    if (loaded is! NetWorthLoaded || loaded.creatingSnapshot) {
      return;
    }
    emit(loaded.copyWith(creatingSnapshot: true));
    final result = await _createSnapshot(_clock.now());
    emit(
      result.fold(
        (failure) => loaded.copyWith(errorMessage: failure.message),
        (snapshot) => loaded.copyWith(
          history: NetWorthSnapshot.merge(loaded.history, snapshot),
        ),
      ),
    );
  }
}
