import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/usecase/get_goal_projection.dart';

part 'goal_projection_event.dart';
part 'goal_projection_state.dart';

/// State of the projection screen of one goal. A new instance is created
/// per screen.
@injectable
class GoalProjectionBloc
    extends Bloc<GoalProjectionEvent, GoalProjectionState> {
  GoalProjectionBloc(this._getProjection)
      : super(const GoalProjectionLoading()) {
    on<GoalProjectionRequested>(_onRequested);
  }

  final GetGoalProjection _getProjection;

  Future<void> _onRequested(
    GoalProjectionRequested event,
    Emitter<GoalProjectionState> emit,
  ) async {
    emit(const GoalProjectionLoading());
    final result = await _getProjection(event.goalId);
    emit(
      result.fold(
        (failure) => GoalProjectionFailure(
          failure.message,
          notFound: failure is NotFoundFailure,
        ),
        GoalProjectionLoaded.new,
      ),
    );
  }
}
