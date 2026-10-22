part of 'net_worth_bloc.dart';

/// Inputs of [NetWorthBloc].
sealed class NetWorthEvent extends Equatable {
  const NetWorthEvent();

  @override
  List<Object?> get props => const [];
}

/// Load (or reload after an error) the live totals and the history.
final class NetWorthLoadRequested extends NetWorthEvent {
  const NetWorthLoadRequested();
}

/// Save the net worth of the current month as a snapshot.
final class NetWorthSnapshotRequested extends NetWorthEvent {
  const NetWorthSnapshotRequested();
}
