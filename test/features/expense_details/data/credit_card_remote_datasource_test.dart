import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/credit_card_remote_datasource.dart';

import '../../../helpers/expense_fixtures.dart';
import '../../../helpers/fake_http_adapter.dart';

const BalanceDraft _draft = BalanceDraft(
  name: 'Visa Bancolombia',
  monthlyAmount: Money.fromCents(125000050),
  balance: Money.fromPesos(30549222),
);

void main() {
  late FakeHttpAdapter adapter;
  late CreditCardRemoteDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter(
      (_) async => FakeResponse(200, envelope(nuCardJson)),
    );
    dataSource = CreditCardRemoteDataSource(fakeDio(adapter));
  });

  test('lists the credit cards', () async {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope([
            nuCardJson,
            {
              'id': 'c2',
              'name': 'Visa Bancolombia',
              'monthlyPayment': 1250000.5,
              'totalBalance': 30549222,
            },
          ]),
        );

    final cards = await dataSource.getAll();

    expect(adapter.requests.single.method, 'GET');
    expect(adapter.requests.single.path, '/credit-cards');
    expect(cards, [nuCard, visaCard]);
  });

  test('creates a credit card with both amounts as JSON numbers', () async {
    final card = await dataSource.create(_draft);

    final request = adapter.requests.single;
    expect(request.method, 'POST');
    expect(request.path, '/credit-cards');
    expect(request.data, {
      'name': 'Visa Bancolombia',
      'monthlyPayment': 1250000.5,
      'totalBalance': 30549222,
    });
    expect(card, nuCard);
  });

  test('updates and deletes a credit card by id', () async {
    await dataSource.update('c1', _draft);
    adapter.handler = (_) async => const FakeResponse(204);
    await dataSource.delete('c1');

    expect(adapter.requests.first.method, 'PUT');
    expect(adapter.requests.first.path, '/credit-cards/c1');
    expect(adapter.requests.last.method, 'DELETE');
    expect(adapter.requests.last.path, '/credit-cards/c1');
  });

  test('rejects a credit card without its balance', () {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope({...nuCardJson}..remove('totalBalance')),
        );

    expect(
      () => dataSource.create(_draft),
      throwsA(isA<AppException>()),
    );
  });
}
