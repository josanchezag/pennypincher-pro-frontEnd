part of 'net_worth_bloc.dart';

/// State of the net worth overview.
sealed class NetWorthState extends Equatable {
  const NetWorthState();

  @override
  List<Object?> get props => const [];
}

final class NetWorthLoading extends NetWorthState {
  const NetWorthLoading();
}

/// The overview could not be loaded; it can be retried.
final class NetWorthLoadFailure extends NetWorthState {
  const NetWorthLoadFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Live totals and history. [baseline] is the latest snapshot before the
/// current month, the reference of the net worth change. While
/// [creatingSnapshot], the snapshot of the current month is being saved;
/// [errorMessage] reports a snapshot that could not be saved.
final class NetWorthLoaded extends NetWorthState {
  const NetWorthLoaded({
    required this.current,
    required this.history,
    required this.month,
    this.creatingSnapshot = false,
    this.errorMessage,
  });

  final NetWorthSummary current;
  final List<NetWorthSnapshot> history;

  /// First day of the current month.
  final DateTime month;
  final bool creatingSnapshot;
  final String? errorMessage;

  NetWorthSnapshot? get baseline =>
      NetWorthSnapshot.latestBefore(history, month);

  /// Live net worth minus the [baseline] one, when there is a baseline.
  Money? get change {
    final reference = baseline;
    return reference == null ? null : current.netWorth - reference.netWorth;
  }

  NetWorthLoaded copyWith({
    List<NetWorthSnapshot>? history,
    bool creatingSnapshot = false,
    String? errorMessage,
  }) =>
      NetWorthLoaded(
        current: current,
        history: history ?? this.history,
        month: month,
        creatingSnapshot: creatingSnapshot,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props =>
      [current, history, month, creatingSnapshot, errorMessage];
}
