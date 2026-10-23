import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/expense_details/data/datasource/fixed_expense_remote_datasource.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/fixed_expense_entity.dart';

import '../../../helpers/expense_fixtures.dart';
import '../../../helpers/fake_http_adapter.dart';

List<String> _calls(FakeHttpAdapter adapter) => [
      for (final request in adapter.requests)
        '${request.method} ${request.path}',
    ];

void main() {
  late FakeHttpAdapter adapter;
  late FixedExpenseRemoteDataSource dataSource;

  setUp(() {
    adapter = FakeHttpAdapter(
      (_) async => FakeResponse(200, envelope(schoolAnaJson)),
    );
    dataSource = FixedExpenseRemoteDataSource(fakeDio(adapter));
  });

  test('lists and creates fixed expenses', () async {
    adapter.handler = (_) async => FakeResponse(200, envelope([schoolAnaJson]));
    expect(await dataSource.getAll(), [schoolAna]);
    adapter.handler = (_) async => FakeResponse(200, envelope(schoolAnaJson));
    final created = await dataSource.create(
      const CategorizedDraft(
        name: 'Colegio Ana',
        amount: Money.fromPesos(1347709),
        category: FixedExpenseCategory.education,
      ),
    );

    expect(created, schoolAna);
    expect(_calls(adapter), ['GET /fixed-expenses', 'POST /fixed-expenses']);
    expect(adapter.requests.last.data, {
      'name': 'Colegio Ana',
      'monthlyAmount': 1347709,
      'category': 'EDUCATION',
    });
  });

  test('updates and deletes a fixed expense by id', () async {
    await dataSource.update(
      'f1',
      const CategorizedDraft(
        name: 'Diezmo',
        amount: Money.fromCents(50),
        category: FixedExpenseCategory.charity,
      ),
    );
    adapter.handler = (_) async => const FakeResponse(204);
    await dataSource.delete('f1');

    expect(
      _calls(adapter),
      ['PUT /fixed-expenses/f1', 'DELETE /fixed-expenses/f1'],
    );
    expect(adapter.requests.first.data, containsPair('category', 'CHARITY'));
  });

  test('reads every category and maps an unknown one to other', () async {
    for (final category in FixedExpenseCategory.values) {
      final name = category == FixedExpenseCategory.other
          ? 'PETS'
          : category.name.toUpperCase();
      adapter.handler = (_) async => FakeResponse(
            200,
            envelope({...schoolAnaJson, 'category': name}),
          );

      final expense = await dataSource.create(
        const CategorizedDraft(
          name: 'x',
          amount: Money.zero,
          category: FixedExpenseCategory.other,
        ),
      );

      expect(expense.category, category);
    }
  });
}
