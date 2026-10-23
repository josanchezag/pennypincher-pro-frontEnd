import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/expense_summary_remote_datasource.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/expense_summary_entity.dart';

import '../../../helpers/fake_http_adapter.dart';

void main() {
  late FakeHttpAdapter adapter;
  late ExpenseSummaryRemoteDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter((_) async => const FakeResponse(500));
    dataSource = ExpenseSummaryRemoteDataSource(fakeDio(adapter));
  });

  void answer(Map<String, Object?> summary) =>
      adapter.handler = (_) async => FakeResponse(200, envelope(summary));

  test('reads the payments and outstanding balance of credit cards', () async {
    answer({
      'totalMonthlyPayments': 1250000.50,
      'totalOutstandingBalance': 42956922.00,
      'count': 3,
    });

    final summary = await dataSource.getSummary(ExpenseKind.creditCards);

    expect(adapter.requests.single.method, 'GET');
    expect(adapter.requests.single.path, '/credit-cards/summary');
    expect(
      summary,
      const ExpenseSummary(
        monthlyTotal: Money.fromCents(125000050),
        balanceTotal: Money.fromPesos(42956922),
        count: 3,
      ),
    );
  });

  test('reads the monthly amount of fixed and variable expenses', () async {
    answer({
      'totalMonthlyAmount': 2347709.00,
      'count': 2,
      'byCategory': [
        {'category': 'EDUCATION', 'totalMonthlyAmount': 2347709.00, 'count': 2},
      ],
    });

    final fixed = await dataSource.getSummary(ExpenseKind.fixedExpenses);
    final variable = await dataSource.getSummary(ExpenseKind.variableExpenses);

    expect(adapter.requests.first.path, '/fixed-expenses/summary');
    expect(adapter.requests.last.path, '/variable-expenses/summary');
    expect(
      fixed,
      const ExpenseSummary(monthlyTotal: Money.fromPesos(2347709), count: 2),
    );
    expect(variable, fixed);
  });

  test('reads loans and savings from their own keys', () async {
    answer({
      'totalMonthlyPayments': 3280231,
      'totalOutstandingBalance': 98000000,
      'count': 2,
    });
    final loans = await dataSource.getSummary(ExpenseKind.loans);
    answer({
      'totalMonthlyContributions': 1500000,
      'totalCurrentBalance': 25000000,
      'count': 1,
    });
    final savings = await dataSource.getSummary(ExpenseKind.savings);

    expect(adapter.requests.first.path, '/loans/summary');
    expect(adapter.requests.last.path, '/savings-accounts/summary');
    expect(loans.balanceTotal, const Money.fromPesos(98000000));
    expect(savings.monthlyTotal, const Money.fromPesos(1500000));
    expect(savings.balanceTotal, const Money.fromPesos(25000000));
  });

  test('surfaces the backend error and an unexpected shape', () async {
    adapter.handler = (_) async =>
        FakeResponse(503, errorEnvelope('UNAVAILABLE', 'Try again later'));

    await expectLater(
      dataSource.getSummary(ExpenseKind.loans),
      throwsA(
        isA<AppException>().having((e) => e.statusCode, 'statusCode', 503),
      ),
    );

    answer({'totalMonthlyAmount': 10});
    await expectLater(
      dataSource.getSummary(ExpenseKind.fixedExpenses),
      throwsA(isA<AppException>()),
    );
  });
}
