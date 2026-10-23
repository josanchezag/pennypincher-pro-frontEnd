part of 'goal_projection_bloc.dart';

/// State of the projection of one goal.
sealed class GoalProjectionState extends Equatable {
  const GoalProjectionState();

  @override
  List<Object?> get props => const [];
}

final class GoalProjectionLoading extends GoalProjectionState {
  const GoalProjectionLoading();
}

/// The projection could not be loaded. When [notFound], the goal no longer
/// exists; otherwise it can be retried.
final class GoalProjectionFailure extends GoalProjectionState {
  const GoalProjectionFailure(this.message, {this.notFound = false});

  final String message;
  final bool notFound;

  @override
  List<Object?> get props => [message, notFound];
}

final class GoalProjectionLoaded extends GoalProjectionState {
  const GoalProjectionLoaded(this.projection);

  final GoalProjection projection;

  @override
  List<Object?> get props => [projection];
}
