import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/net_worth/data/datasource/liability_remote_datasource.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/liability_entity.dart';

import '../../../helpers/fake_http_adapter.dart';
import '../../../helpers/net_worth_fixtures.dart';

const ItemDraft<LiabilityCategory> _draft = ItemDraft(
  name: 'Tarjeta Nu Bank',
  amount: Money.fromPesos(3200000),
  category: LiabilityCategory.creditCard,
);

void main() {
  late FakeHttpAdapter adapter;
  late LiabilityRemoteDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter(
      (_) async => FakeResponse(200, envelope(nuCardJson)),
    );
    dataSource = LiabilityRemoteDataSource(fakeDio(adapter));
  });

  test('lists the liabilities with their current balance', () async {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope([
            nuCardJson,
            {
              'id': 'l2',
              'name': 'Prestamo Davivienda 7141',
              'currentBalance': 45500000.25,
              'category': 'BANK_LOAN',
            },
          ]),
        );

    final liabilities = await dataSource.getAll();

    expect(adapter.requests.single.path, '/liabilities');
    expect(liabilities, [nuCard, davivienda]);
  });

  test('sends the balance as currentBalance when creating', () async {
    final liability = await dataSource.create(_draft);

    final request = adapter.requests.single;
    expect(request.method, 'POST');
    expect(request.path, '/liabilities');
    expect(request.data, {
      'name': 'Tarjeta Nu Bank',
      'currentBalance': 3200000,
      'category': 'CREDIT_CARD',
    });
    expect(liability, nuCard);
  });

  test('updates and deletes a liability by id', () async {
    await dataSource.update('l1', _draft);
    adapter.handler = (_) async => const FakeResponse(204);
    await dataSource.delete('l1');

    expect(adapter.requests.first.method, 'PUT');
    expect(adapter.requests.first.path, '/liabilities/l1');
    expect(adapter.requests.last.method, 'DELETE');
    expect(adapter.requests.last.path, '/liabilities/l1');
  });
}
