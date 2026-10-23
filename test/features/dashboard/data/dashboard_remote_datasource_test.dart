import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/dashboard/data/datasource/dashboard_remote_datasource.dart';

import '../../../helpers/dashboard_fixtures.dart';
import '../../../helpers/fake_http_adapter.dart';

void main() {
  late FakeHttpAdapter adapter;
  late DashboardRemoteDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter(
      (_) async => FakeResponse(200, envelope(dashboardJson)),
    );
    dataSource = DashboardRemoteDataSource(fakeDio(adapter));
  });

  Matcher invalidResponse() => throwsA(
        isA<AppException>()
            .having((e) => e.code, 'code', ErrorCodes.invalidResponse),
      );

  test('asks for the summary of the reference month', () async {
    await dataSource.getSummary(DateTime(2026, 2));

    final request = adapter.requests.single;
    expect(request.method, 'GET');
    expect(request.path, '/dashboard/summary');
    expect(request.queryParameters, {'month': '2026-02'});
  });

  test('reads every block of the summary', () async {
    final summary = await dataSource.getSummary(DateTime(2026, 10));

    expect(summary, dashboardSummary);
  });

  test('reads a brand-new user with nulls and empty lists', () async {
    adapter.handler = (_) async => FakeResponse(200, envelope(newUserJson));

    final summary = await dataSource.getSummary(DateTime(2026, 10));

    expect(summary, newUserSummary);
    expect(summary.netWorth.change, isNull);
    expect(summary.budget.exists, isFalse);
    expect(summary.user.pictureUrl, isNull);
    expect(summary.isEmpty, isTrue);
  });

  test('keeps the change without a percentage after a zero net worth',
      () async {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope({
            ...dashboardJson,
            'netWorth': {
              ...dashboardNetWorthJson,
              'previousMonth': 0,
              'delta': -2500000.50,
              'deltaPercentage': null,
            },
          }),
        );

    final change =
        (await dataSource.getSummary(DateTime(2026, 10))).netWorth.change!;

    expect(change.previous, Money.zero);
    expect(change.delta, const Money.fromCents(-250000050));
    expect(change.percentage, isNull);
    expect(change.previousDate, DateTime(2026, 9));
  });

  test('rejects a budget that exists without its figures', () {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope({
            ...dashboardJson,
            'currentMonthBudget': {...dashboardBudgetJson, 'totalIncome': null},
          }),
        );

    expect(() => dataSource.getSummary(DateTime(2026, 10)), invalidResponse());
  });

  test('rejects a summary without the user profile', () {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope({...dashboardJson, 'userProfile': null}),
        );

    expect(() => dataSource.getSummary(DateTime(2026, 10)), invalidResponse());
  });

  test('posts the first day of the month for a snapshot', () async {
    adapter.handler = (_) async => FakeResponse(201, envelope({}));

    await dataSource.recordSnapshot(DateTime(2026, 10));

    final request = adapter.requests.single;
    expect(request.method, 'POST');
    expect(request.path, '/net-worth/snapshots');
    expect(request.data, {'snapshotDate': '2026-10-01'});
  });

  test('reports a failed snapshot with the backend message', () {
    adapter.handler = (_) async => FakeResponse(
          400,
          errorEnvelope('VALIDATION_FAILED', 'Snapshot date is in the future'),
        );

    expect(
      () => dataSource.recordSnapshot(DateTime(2026, 10)),
      throwsA(
        isA<AppException>()
            .having((e) => e.message, 'message', contains('future')),
      ),
    );
  });
}
