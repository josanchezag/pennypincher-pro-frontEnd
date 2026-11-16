import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/financial_goals/data/model/goal_json_codec.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_income_mode.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/reference_return.dart';

import '../../../helpers/goal_fixtures.dart';

void main() {
  const codec = GoalJsonCodec();

  test('reads a goal based on the current income with its figures', () {
    final goal = codec.fromJson(incomeIndependenceJson);

    expect(goal, incomeIndependence.copyWith(projection: null));
    expect(goal.incomeMode, GoalIncomeMode.currentIncome);
    expect(goal.incomeFactor, 1.0);
    expect(goal.monthlyIncomeBasis, monthlyIncome);
    expect(goal.desiredMonthlyIncome, monthlyIncome);
    expect(goal.requiredMonthlyInvestment, const Money.fromCents(176243439));
    expect(
      goal.referenceReturn,
      const ReferenceReturn(
        annualRate: 0.10,
        annualAmount: Money.fromCents(12540536612),
        monthlyAmount: Money.fromUnits(10000000),
      ),
    );
  });

  test('reads a goal without the income fields as a manual goal', () {
    final goal = codec.fromJson(securityJson);

    expect(goal.incomeMode, GoalIncomeMode.manual);
    expect(goal.incomeFactor, isNull);
    expect(goal.monthlyIncomeBasis, isNull);
    expect(goal.desiredMonthlyIncome, isNull);
    expect(goal.requiredMonthlyInvestment, isNull);
    expect(goal.referenceReturn, isNull);
  });

  test('reads the null income fields of a manual goal', () {
    final goal = codec.fromJson({
      ...securityJson,
      'incomeMode': 'MANUAL',
      'incomeFactor': null,
      'monthlyIncomeBasis': null,
      'desiredMonthlyIncome': null,
      'requiredMonthlyInvestment': 1062718.5,
      'referenceReturn': {
        'annualRate': 0.1,
        'annualAmount': 60500000,
        'monthlyAmount': '4824354.96',
      },
    });

    expect(goal.incomeMode, GoalIncomeMode.manual);
    expect(goal.desiredMonthlyIncome, isNull);
    expect(goal.requiredMonthlyInvestment, const Money.fromCents(106271850));
    expect(
      goal.referenceReturn?.monthlyAmount,
      const Money.fromCents(482435496),
    );
  });

  test('reads a typed income goal and an unknown mode as manual', () {
    expect(
      codec.fromJson(
        {...securityJson, 'incomeMode': 'DESIRED_INCOME'},
      ).incomeMode,
      GoalIncomeMode.desiredIncome,
    );
    expect(
      codec.fromJson({...securityJson, 'incomeMode': 'FUTURE_MODE'}).incomeMode,
      GoalIncomeMode.manual,
    );
  });
}
