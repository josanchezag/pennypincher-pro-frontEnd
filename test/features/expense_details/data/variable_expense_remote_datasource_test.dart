import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/variable_expense_remote_datasource.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/variable_expense_entity.dart';

import '../../../helpers/expense_fixtures.dart';
import '../../../helpers/fake_http_adapter.dart';

void main() {
  late FakeHttpAdapter adapter;
  late VariableExpenseRemoteDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter(
      (_) async => FakeResponse(200, envelope(nannyJson)),
    );
    dataSource = VariableExpenseRemoteDataSource(fakeDio(adapter));
  });

  test('sends and reads categories with several words', () async {
    final expense = await dataSource.create(
      const CategorizedDraft(
        name: 'Empleada',
        amount: Money.fromPesos(1800000),
        category: VariableExpenseCategory.householdStaff,
      ),
    );

    expect(adapter.requests.single.path, '/variable-expenses');
    expect(adapter.requests.single.data, {
      'name': 'Empleada',
      'monthlyAmount': 1800000,
      'category': 'HOUSEHOLD_STAFF',
    });
    expect(expense, nanny);
  });

  test('lists the variable expenses and maps unknown categories to other',
      () async {
    adapter.handler = (_) async => FakeResponse(
          200,
          envelope([
            nannyJson,
            {...nannyJson, 'id': 'v9', 'category': 'TRAVEL'},
          ]),
        );

    final expenses = await dataSource.getAll();

    expect(adapter.requests.single.path, '/variable-expenses');
    expect(expenses.first, nanny);
    expect(expenses.last.category, VariableExpenseCategory.other);
  });
}
