import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/savings_account_remote_datasource.dart';

import '../../../helpers/expense_fixtures.dart';
import '../../../helpers/fake_http_adapter.dart';

const BalanceDraft _draft = BalanceDraft(
  name: 'Fondo de emergencia',
  monthlyAmount: Money.fromPesos(500000),
  balance: Money.fromCents(850000050),
);

void main() {
  late FakeHttpAdapter adapter;
  late SavingsAccountRemoteDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter(
      (_) async => FakeResponse(200, envelope(emergencyFundJson)),
    );
    dataSource = SavingsAccountRemoteDataSource(fakeDio(adapter));
  });

  test('lists the savings accounts', () async {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope([
            emergencyFundJson,
            {
              'id': 's2',
              'name': 'CDT Bancolombia',
              'monthlyContribution': 0,
              'currentBalance': 20000000,
            },
          ]),
        );

    final accounts = await dataSource.getAll();

    expect(adapter.requests.single.path, '/savings-accounts');
    expect(accounts, [emergencyFund, cdt]);
  });

  test('creates a savings account with its contribution and balance', () async {
    final account = await dataSource.create(_draft);

    final request = adapter.requests.single;
    expect(request.method, 'POST');
    expect(request.path, '/savings-accounts');
    expect(request.data, {
      'name': 'Fondo de emergencia',
      'monthlyContribution': 500000,
      'currentBalance': 8500000.5,
    });
    expect(account, emergencyFund);
  });

  test('updates and deletes a savings account by id', () async {
    await dataSource.update('s1', _draft);
    adapter.handler = (_) async => const FakeResponse(204);
    await dataSource.delete('s1');

    expect(adapter.requests.map((r) => '${r.method} ${r.path}'), [
      'PUT /savings-accounts/s1',
      'DELETE /savings-accounts/s1',
    ]);
  });
}
