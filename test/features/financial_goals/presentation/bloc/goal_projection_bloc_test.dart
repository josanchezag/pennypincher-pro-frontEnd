import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/usecase/get_goal_projection.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/bloc/goal_projection_bloc.dart';

import '../../../../helpers/goal_fixtures.dart';

class _MockGetProjection extends Mock implements GetGoalProjection {}

void main() {
  late _MockGetProjection getProjection;

  setUp(() => getProjection = _MockGetProjection());

  GoalProjectionBloc build() => GoalProjectionBloc(getProjection);

  test('starts loading', () {
    final bloc = build();
    addTearDown(bloc.close);

    expect(bloc.state, const GoalProjectionLoading());
  });

  blocTest<GoalProjectionBloc, GoalProjectionState>(
    'loads the projection of the goal',
    setUp: () => when(() => getProjection('g1'))
        .thenAnswer((_) async => Right(security.projection!)),
    build: build,
    act: (bloc) => bloc.add(const GoalProjectionRequested('g1')),
    expect: () => [
      const GoalProjectionLoading(),
      GoalProjectionLoaded(security.projection!),
    ],
  );

  blocTest<GoalProjectionBloc, GoalProjectionState>(
    'reports a goal that no longer exists',
    setUp: () => when(() => getProjection('g9')).thenAnswer(
      (_) async => const Left(NotFoundFailure('Goal not found')),
    ),
    build: build,
    act: (bloc) => bloc.add(const GoalProjectionRequested('g9')),
    expect: () => [
      const GoalProjectionLoading(),
      const GoalProjectionFailure('Goal not found', notFound: true),
    ],
  );

  blocTest<GoalProjectionBloc, GoalProjectionState>(
    'reports a failure that can be retried',
    setUp: () => when(() => getProjection('g1'))
        .thenAnswer((_) async => const Left(NetworkFailure('Offline'))),
    build: build,
    act: (bloc) => bloc.add(const GoalProjectionRequested('g1')),
    expect: () => [
      const GoalProjectionLoading(),
      const GoalProjectionFailure('Offline'),
    ],
  );
}
