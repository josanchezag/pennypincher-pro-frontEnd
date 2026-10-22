import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/budget/data/datasource/monthly_budget_remote_datasource.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';

import '../../../helpers/budget_fixtures.dart';
import '../../../helpers/fake_http_adapter.dart';

void main() {
  late FakeHttpAdapter adapter;
  late MonthlyBudgetRemoteDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter(
      (_) async => FakeResponse(200, envelope(octoberBudgetJson)),
    );
    dataSource = MonthlyBudgetRemoteDataSource(fakeDio(adapter));
  });

  test('gets the budget of a month by year and month', () async {
    final budget = await dataSource.getByMonth(DateTime(2026, 10));

    expect(adapter.requests.single.method, 'GET');
    expect(adapter.requests.single.path, '/monthly-budgets/2026/10');
    expect(budget.toEntity(), octoberBudget);
  });

  test('creates the budget of a month', () async {
    await dataSource.create(DateTime(2026, 10));

    final request = adapter.requests.single;
    expect(request.method, 'POST');
    expect(request.path, '/monthly-budgets');
    expect(request.data, {'year': 2026, 'month': 10});
  });

  test('replaces both settings, sending null to clear one', () async {
    await dataSource.update(
      'b-2026-10',
      const BudgetSettings(exchangeRate: Money.fromCents(395025)),
    );

    final request = adapter.requests.single;
    expect(request.method, 'PUT');
    expect(request.path, '/monthly-budgets/b-2026-10');
    expect(request.data, {'exchangeRate': 3950.25, 'workDays': null});
  });

  test('recalculates a budget', () async {
    await dataSource.recalculate('b-2026-10');

    expect(adapter.requests.single.method, 'POST');
    expect(
      adapter.requests.single.path,
      '/monthly-budgets/b-2026-10/recalculate',
    );
  });

  test('reads missing settings and skips unknown components', () async {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope({
            ...octoberBudgetJson,
            'exchangeRate': null,
            'workDays': null,
            'monthlyCashFlow': -2847077.64,
            'components': [
              {
                'component': 'BUSINESS',
                'amount': 1,
                'percentage': 60,
                'idealPercentage': 60,
              },
              {
                'component': 'LOANS',
                'amount': '3280231.00',
                'percentage': 108,
              },
            ],
          }),
        );

    final budget = (await dataSource.getByMonth(DateTime(2026, 10))).toEntity();

    expect(budget.settings, const BudgetSettings());
    expect(budget.monthlyCashFlow, const Money.fromCents(-284707764));
    expect(budget.components, const [
      BudgetComponent(
        type: BudgetComponentType.loans,
        amount: Money.fromPesos(3280231),
        percentage: 108,
      ),
    ]);
  });

  test('rejects a budget without totals', () {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope({...octoberBudgetJson, 'totalIncome': null}),
        );

    expect(
      () => dataSource.getByMonth(DateTime(2026, 10)),
      throwsA(
        isA<AppException>()
            .having((e) => e.code, 'code', ErrorCodes.invalidResponse),
      ),
    );
  });

  test('surfaces a missing month as a 404', () {
    adapter.handler = (_) async => FakeResponse(
          404,
          errorEnvelope('NOT_FOUND', 'Monthly budget not found'),
        );

    expect(
      () => dataSource.getByMonth(DateTime(2026, 11)),
      throwsA(
        isA<AppException>().having((e) => e.statusCode, 'statusCode', 404),
      ),
    );
  });
}
