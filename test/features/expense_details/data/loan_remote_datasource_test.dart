import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/loan_remote_datasource.dart';

import '../../../helpers/expense_fixtures.dart';
import '../../../helpers/fake_http_adapter.dart';

const BalanceDraft _tracked = BalanceDraft(
  name: 'Prestamo carro',
  monthlyAmount: Money.fromPesos(1200000),
  balance: Money.fromPesos(30000000),
  originalAmount: Money.fromPesos(50000000),
);

void main() {
  late FakeHttpAdapter adapter;
  late LoanRemoteDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter(
      (_) async => FakeResponse(200, envelope(carLoanJson)),
    );
    dataSource = LoanRemoteDataSource(fakeDio(adapter));
  });

  test('lists loans with and without their original amount', () async {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope([
            carLoanJson,
            {
              'id': 'l2',
              'name': 'Davivienda 7141',
              'monthlyPayment': 2080231,
              'totalBalance': 45500000.25,
              'originalAmount': null,
            },
          ]),
        );

    final loans = await dataSource.getAll();

    expect(adapter.requests.single.path, '/loans');
    expect(loans, [carLoan, davivienda]);
  });

  test('creates a loan with its original amount', () async {
    final loan = await dataSource.create(_tracked);

    final request = adapter.requests.single;
    expect(request.method, 'POST');
    expect(request.path, '/loans');
    expect(request.data, {
      'name': 'Prestamo carro',
      'monthlyPayment': 1200000,
      'totalBalance': 30000000,
      'originalAmount': 50000000,
    });
    expect(loan, carLoan);
  });

  test('clears the original amount by sending it as null', () async {
    await dataSource.update(
      'l1',
      const BalanceDraft(
        name: 'Prestamo carro',
        monthlyAmount: Money.fromPesos(1200000),
        balance: Money.fromPesos(30000000),
      ),
    );

    final request = adapter.requests.single;
    expect(request.method, 'PUT');
    expect(request.path, '/loans/l1');
    expect(request.data, containsPair('originalAmount', null));
  });
}
