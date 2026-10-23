import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/financial_goals/data/datasource/financial_goal_remote_datasource.dart';
import 'package:pennypincher_pro/features/financial_goals/data/model/goal_json_codec.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';

import '../../../helpers/fake_http_adapter.dart';
import '../../../helpers/goal_fixtures.dart';

const GoalDraft _draft = GoalDraft(
  name: 'Libertad Absoluta',
  level: GoalLevel.absoluteFreedom,
  targetAmount: Money.fromCents(436600000050),
  monthlyInvestment: Money.zero,
  expectedAnnualReturn: 0.115,
);

void main() {
  late FakeHttpAdapter adapter;
  late FinancialGoalRemoteDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter(
      (_) async => FakeResponse(200, envelope(securityJson)),
    );
    dataSource = FinancialGoalRemoteDataSource(fakeDio(adapter));
  });

  test('lists the goals', () async {
    adapter.handler = (_) async => FakeResponse(200, envelope([securityJson]));

    final goals = await dataSource.getAll();

    expect(adapter.requests.single.path, '/financial-goals');
    expect(goals, [security.copyWith(projection: null)]);
  });

  test('creates a goal with the return as a fraction', () async {
    await dataSource.create(_draft);

    final request = adapter.requests.single;
    expect('${request.method} ${request.path}', 'POST /financial-goals');
    expect(request.data, {
      'name': 'Libertad Absoluta',
      'level': 'ABSOLUTE_FREEDOM',
      'targetAmount': 4366000000.5,
      'monthlyInvestment': 0,
      'expectedAnnualReturn': 0.115,
      'targetYears': null,
    });
  });

  test('updates with the target years and deletes by id', () async {
    await dataSource.update('g1', _draft.copyWithYears(16));
    adapter.handler = (_) async => const FakeResponse(204);
    await dataSource.delete('g1');

    expect(adapter.requests.map((r) => '${r.method} ${r.path}'), [
      'PUT /financial-goals/g1',
      'DELETE /financial-goals/g1',
    ]);
    expect((adapter.requests.first.data as Map)['targetYears'], 16);
  });

  test('adds the standard goals and returns the whole list', () async {
    adapter.handler = (_) async => FakeResponse(200, envelope([securityJson]));

    final goals = await dataSource.createDefaults();

    final request = adapter.requests.single;
    expect(
      '${request.method} ${request.path}',
      'POST /financial-goals/defaults',
    );
    expect(goals.single.name, 'Seguridad Financiera');
  });

  test('reads every projection with its data points', () async {
    adapter.handler =
        (_) async => FakeResponse(200, envelope([securityProjectionJson]));

    final projections = await dataSource.getAllProjections();

    expect(adapter.requests.single.path, '/financial-goals/all-projections');
    final projection = projections.single;
    expect(projection.goalId, 'g1');
    expect(projection.level, GoalLevel.financialSecurity);
    expect(projection.progressPercentage, 69.97);
    expect(projection.remainingAmount, const Money.fromPesos(181717227));
    expect(projection.projectedMonthsToGoal, 38);
    expect(projection.projectedYearsToGoal, 3.17);
    expect(projection.projectedAchievementDate, DateTime(2029, 12));
    expect(projection.alreadyReached, isFalse);
    expect(
      projection.dataPoints.last,
      ProjectionPoint(
        month: 1,
        date: DateTime(2026, 11),
        projectedValue: const Money.fromCents(42804037336),
      ),
    );
  });

  test('reads a projection that is not reachable', () async {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope([
            {
              ...securityProjectionJson,
              'reachable': false,
              'projectedMonthsToGoal': null,
              'projectedYearsToGoal': null,
              'projectedAchievementDate': null,
              'targetYears': null,
            },
          ]),
        );

    final projection = (await dataSource.getAllProjections()).single;

    expect(projection.reachable, isFalse);
    expect(projection.projectedMonthsToGoal, isNull);
    expect(projection.projectedAchievementDate, isNull);
    expect(projection.targetYears, isNull);
  });

  test('rejects a projection with an unexpected shape', () async {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope([
            {...securityProjectionJson, 'reachable': 'yes'},
          ]),
        );

    expect(dataSource.getAllProjections(), throwsA(isA<AppException>()));
  });

  test('reads an unknown level as the last one', () {
    expect(GoalJsonCodec.parseLevel('NEW_LEVEL'), GoalLevel.absoluteFreedom);
    expect(
      GoalJsonCodec.parseLevel('FINANCIAL_FREEDOM'),
      GoalLevel.financialFreedom,
    );
  });
}

extension on GoalDraft {
  GoalDraft copyWithYears(int years) => GoalDraft(
        name: name,
        level: level,
        targetAmount: targetAmount,
        monthlyInvestment: monthlyInvestment,
        expectedAnnualReturn: expectedAnnualReturn,
        targetYears: years,
      );
}
