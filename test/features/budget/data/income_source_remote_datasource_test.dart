import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/budget/data/datasource/income_source_remote_datasource.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';

import '../../../helpers/budget_fixtures.dart';
import '../../../helpers/fake_http_adapter.dart';

const ItemDraft<IncomeCategory> _draft = ItemDraft(
  name: 'AvenueCode',
  amount: Money.fromCents(2415292236),
  category: IncomeCategory.employment,
);

void main() {
  late FakeHttpAdapter adapter;
  late IncomeSourceRemoteDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter(
      (_) async => FakeResponse(200, envelope(avenueCodeJson)),
    );
    dataSource = IncomeSourceRemoteDataSource(fakeDio(adapter));
  });

  test('lists the income sources', () async {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope([
            avenueCodeJson,
            {
              'id': 'i3',
              'name': 'Arriendo Madera',
              'amount': 4000000,
              'category': 'RENTAL',
            },
          ]),
        );

    final sources = await dataSource.getAll();

    expect(adapter.requests.single.method, 'GET');
    expect(adapter.requests.single.path, '/income-sources');
    expect(sources, [avenueCode, arriendoMadera]);
  });

  test('creates an income source with its amount as a JSON number', () async {
    final source = await dataSource.create(_draft);

    final request = adapter.requests.single;
    expect(request.method, 'POST');
    expect(request.path, '/income-sources');
    expect(request.data, {
      'name': 'AvenueCode',
      'amount': 24152922.36,
      'category': 'EMPLOYMENT',
    });
    expect(source, avenueCode);
  });

  test('updates and deletes an income source by id', () async {
    await dataSource.update('i1', _draft);
    adapter.handler = (_) async => const FakeResponse(204);
    await dataSource.delete('i1');

    expect(adapter.requests.first.method, 'PUT');
    expect(adapter.requests.first.path, '/income-sources/i1');
    expect(adapter.requests.last.method, 'DELETE');
    expect(adapter.requests.last.path, '/income-sources/i1');
  });

  test('reads every category and maps an unknown one to other', () async {
    for (final (name, category) in [
      ('FREELANCE', IncomeCategory.freelance),
      ('INVESTMENT', IncomeCategory.investment),
      ('BUSINESS', IncomeCategory.business),
      ('ROYALTIES', IncomeCategory.other),
    ]) {
      adapter.handler = (_) async => FakeResponse(
            200,
            envelope({...avenueCodeJson, 'category': name}),
          );

      final source = await dataSource.create(_draft);

      expect(source.category, category);
    }
  });

  test('surfaces the backend error and status', () {
    adapter.handler = (_) async => FakeResponse(
          404,
          errorEnvelope('NOT_FOUND', 'Income source not found'),
        );

    expect(
      () => dataSource.delete('missing'),
      throwsA(
        isA<AppException>()
            .having((e) => e.code, 'code', 'NOT_FOUND')
            .having((e) => e.statusCode, 'statusCode', 404),
      ),
    );
  });
}
