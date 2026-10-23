part of 'goal_projection_bloc.dart';

/// Inputs of [GoalProjectionBloc].
sealed class GoalProjectionEvent extends Equatable {
  const GoalProjectionEvent();

  @override
  List<Object?> get props => const [];
}

/// Load (or reload after an error) the projection of the goal [goalId].
final class GoalProjectionRequested extends GoalProjectionEvent {
  const GoalProjectionRequested(this.goalId);

  final String goalId;

  @override
  List<Object?> get props => [goalId];
}
