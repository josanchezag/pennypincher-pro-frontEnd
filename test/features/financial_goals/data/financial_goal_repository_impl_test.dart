import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/financial_goals/data/datasource/financial_goal_remote_datasource.dart';
import 'package:pennypincher_pro/features/financial_goals/data/repository/financial_goal_repository_impl.dart';

import '../../../helpers/fake_http_adapter.dart';
import '../../../helpers/goal_fixtures.dart';

void main() {
  late FakeHttpAdapter adapter;
  late FinancialGoalRepositoryImpl repository;

  setUp(() {
    adapter = FakeHttpAdapter((options) async {
      final body = options.path.endsWith('all-projections')
          ? [securityProjectionJson]
          : [
              securityJson,
              {...securityJson, 'id': 'g9', 'name': 'Casa'},
            ];
      return FakeResponse(200, envelope(body));
    });
    repository = FinancialGoalRepositoryImpl(
      FinancialGoalRemoteDataSource(fakeDio(adapter)),
    );
  });

  test('joins every goal with its projection', () async {
    final goals = (await repository.getAll()).getOrElse(() => []);

    expect(
      adapter.requests.map((r) => r.path),
      unorderedEquals(['/financial-goals', '/financial-goals/all-projections']),
    );
    expect(goals.map((goal) => goal.id), ['g1', 'g9']);
    expect(goals.first.projection?.progressPercentage, 69.97);
    expect(goals.first.progressPercentage, 69.97);
    expect(goals.last.projection, isNull);
  });

  test('keeps the goals without projections when only those fail', () async {
    adapter.handler = (options) async => options.path.endsWith('projections')
        ? FakeResponse(500, errorEnvelope('INTERNAL_ERROR', 'Boom'))
        : FakeResponse(200, envelope([securityJson]));

    final goals = (await repository.getAll()).getOrElse(() => []);

    expect(goals.single.id, 'g1');
    expect(goals.single.projection, isNull);
  });

  test('fails the whole load when the goals fail', () async {
    adapter.handler = (options) async => options.path.endsWith('projections')
        ? FakeResponse(200, envelope([securityProjectionJson]))
        : FakeResponse(500, errorEnvelope('INTERNAL_ERROR', 'Boom'));

    final result = await repository.getAll();

    expect(result, isA<Left<Failure, Object>>());
    expect(result.fold((failure) => failure.message, (_) => ''), 'Boom');
  });

  test('fails the whole load when both requests fail', () async {
    adapter.handler = (_) async => throw Exception('offline');

    final result = await repository.getAll();

    expect(result.isLeft(), isTrue);
  });

  test('loads the projection of one goal', () async {
    adapter.handler =
        (_) async => FakeResponse(200, envelope(securityProjectionJson));

    final result = await repository.getProjection('g1');

    expect(adapter.requests.single.path, '/financial-goals/g1/projection');
    expect(result.isRight(), isTrue);
  });

  test('reports a projection of a goal that does not exist', () async {
    adapter.handler = (_) async =>
        FakeResponse(404, errorEnvelope('NOT_FOUND', 'Goal not found'));

    final result = await repository.getProjection('g9');

    expect(
      result.fold((failure) => failure, (_) => null),
      isA<NotFoundFailure>(),
    );
  });

  test('adds the standard goals', () async {
    final result = await repository.createDefaults();

    expect(adapter.requests.single.path, '/financial-goals/defaults');
    expect(result.getOrElse(() => []), hasLength(2));
  });

  test('reports standard goals that could not be added', () async {
    adapter.handler = (_) async => throw Exception('offline');

    final result = await repository.createDefaults();

    expect(result.isLeft(), isTrue);
  });
}
