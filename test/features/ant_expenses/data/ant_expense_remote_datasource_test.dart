import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/ant_expenses/data/datasource/ant_expense_remote_datasource.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';

import '../../../helpers/ant_fixtures.dart';
import '../../../helpers/fake_http_adapter.dart';
import '../../../helpers/l10n.dart';

void main() {
  late FakeHttpAdapter adapter;
  late AntExpenseRemoteDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter((_) async => const FakeResponse(500));
    dataSource = AntExpenseRemoteDataSource(fakeDio(adapter));
  });

  void answer(Object? data, {int status = 200}) =>
      adapter.handler = (_) async => FakeResponse(status, envelope(data));

  group('open expenses', () {
    test('lists the current period with every field', () async {
      answer([coffeeJson]);

      final items = await dataSource.getAll();

      expect(adapter.requests.single.method, 'GET');
      expect(adapter.requests.single.path, '/ant-expenses');
      expect(items.single, coffee);
      expect(items.single.name, 'Tinto en la oficina');
    });

    test('reads a cut expense and a missing description', () async {
      answer([
        octoberSnackJson,
        {...coffeeJson, 'description': null, 'category': 'NEW_KIND'},
      ]);

      final items = await dataSource.getAll();

      expect(items.first, octoberSnack);
      expect(items.first.open, isFalse);
      expect(items.last.description, isNull);
      expect(items.last.name, isEmpty);
      expect(items.last.category, AntExpenseCategory.other);
    });

    test('creates an expense sending the local day and the category', () async {
      answer(coffeeJson, status: 201);

      final created = await dataSource.create(
        AntExpenseDraft(
          amount: const Money.fromCents(350050),
          category: AntExpenseCategory.deliveryAndTips,
          spentOn: DateTime(2026, 11, 5),
        ),
      );

      final request = adapter.requests.single;
      expect(request.method, 'POST');
      expect(request.path, '/ant-expenses');
      expect(request.data, {
        'amount': 3500.5,
        'category': 'DELIVERY_AND_TIPS',
        'description': null,
        'spentOn': '2026-11-05',
      });
      expect(created, coffee);
    });

    test('updates and deletes one expense by its id', () async {
      answer(coffeeJson);
      await dataSource.update(
        'ae 1',
        AntExpenseDraft(
          amount: const Money.fromUnits(3500),
          category: AntExpenseCategory.coffeeAndDrinks,
          spentOn: DateTime(2026, 11, 4),
          description: 'Tinto',
        ),
      );
      adapter.handler = (_) async => const FakeResponse(204);
      await dataSource.delete('ae-1');

      expect(adapter.requests.first.method, 'PUT');
      expect(adapter.requests.first.path, '/ant-expenses/ae%201');
      expect(adapter.requests.first.data, {
        'amount': 3500,
        'category': 'COFFEE_AND_DRINKS',
        'description': 'Tinto',
        'spentOn': '2026-11-04',
      });
      expect(adapter.requests.last.method, 'DELETE');
      expect(adapter.requests.last.path, '/ant-expenses/ae-1');
    });

    test('explains that a cut expense can no longer change', () async {
      adapter.handler = (_) async => FakeResponse(
            409,
            errorEnvelope(
              'ANT_EXPENSE_ALREADY_CUT',
              'The ant expense is already included in a budget cut',
            ),
          );

      await expectLater(
        dataSource.delete('ae-9'),
        throwsA(
          isA<AppException>()
              .having((e) => e.code, 'code', ErrorCodes.antExpenseAlreadyCut)
              .having((e) => e.statusCode, 'statusCode', 409)
              .having(
                (e) => e.message,
                'message',
                l10n.errorAntExpenseAlreadyCut,
              ),
        ),
      );
    });
  });

  group('reports', () {
    test('reads the summary of the current period', () async {
      answer(antSummaryJson);

      final summary = await dataSource.getSummary();

      expect(adapter.requests.single.path, '/ant-expenses/summary');
      expect(summary, antSummary);
      expect(summary.limit!.exceeded, isFalse);
    });

    test('reads the zeros and nulls of a new user', () async {
      answer(emptySummaryJson);

      expect(await dataSource.getSummary(), emptySummary);
    });

    test('reads a limit already passed', () async {
      answer({
        ...antSummaryJson,
        'limit': {
          'monthlyLimit': 20000,
          'usedPercentage': 135.00,
          'remaining': -7000.00,
        },
      });

      final limit = (await dataSource.getSummary()).limit!;

      expect(limit.usedPercentage, 135);
      expect(limit.remaining, const Money.fromUnits(-7000));
      expect(limit.exceeded, isTrue);
    });

    test('reads the cuts and the expenses of one cut', () async {
      answer([octoberCutJson]);
      final cuts = await dataSource.getCuts();
      answer([octoberSnackJson]);
      final items = await dataSource.getCutItems(octoberBudgetId);

      expect(adapter.requests.first.path, '/ant-expenses/cuts');
      expect(cuts.single, octoberCut);
      expect(
        adapter.requests.last.path,
        '/ant-expenses/cuts/$octoberBudgetId/items',
      );
      expect(items.single, octoberSnack);
    });

    test('asks the trend for the local month and number of months', () async {
      answer([
        {'year': 2025, 'month': 12, 'total': 0.00, 'count': 0},
        {'year': 2026, 'month': 1, 'total': 180500.5, 'count': 33},
      ]);

      final trend = await dataSource.getTrend(DateTime(2026), 2);

      final request = adapter.requests.single;
      expect(request.path, '/ant-expenses/trend');
      expect(request.queryParameters, {'month': '2026-01', 'months': 2});
      expect(trend.first.month, DateTime(2025, 12));
      expect(trend.first.total, Money.zero);
      expect(trend.last.total, const Money.fromCents(18050050));
      expect(trend.last.count, 33);
    });

    test('sets and removes the monthly limit', () async {
      answer({'monthlyLimit': 150000.00, 'updatedAt': '2026-11-05T10:00:00Z'});
      final saved = await dataSource.saveLimit(const Money.fromUnits(150000));
      answer({'monthlyLimit': null, 'updatedAt': '2026-11-05T10:00:00Z'});
      final removed = await dataSource.saveLimit(null);

      expect(adapter.requests.first.method, 'PUT');
      expect(adapter.requests.first.path, '/ant-expenses/limit');
      expect(adapter.requests.first.data, {'monthlyLimit': 150000});
      expect(adapter.requests.last.data, {'monthlyLimit': null});
      expect(saved, const Money.fromUnits(150000));
      expect(removed, isNull);
    });

    test('rejects a summary without its breakdown', () async {
      answer({...antSummaryJson, 'byCategory': null});

      await expectLater(
        dataSource.getSummary(),
        throwsA(
          isA<AppException>()
              .having((e) => e.code, 'code', ErrorCodes.invalidResponse),
        ),
      );
    });
  });
}
