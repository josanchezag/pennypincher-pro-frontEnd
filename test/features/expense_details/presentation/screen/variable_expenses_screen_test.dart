import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_sheet.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/variable_expense_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/expense_texts.dart';

import '../../../../helpers/expense_fixtures.dart';
import '../../../../helpers/expense_mocks.dart';
import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/pump_app.dart';

typedef _Draft = CategorizedDraft<VariableExpenseCategory>;

const CrudLoaded<VariableExpense> _loaded =
    CrudLoaded([restaurants, netflix, nanny]);

void main() {
  setUpAll(() {
    registerFallbackValue(const CrudLoadRequested<_Draft>());
    return loadAppFonts();
  });

  Future<MockVariableExpenseBloc> pumpVariable(
    WidgetTester tester,
    CrudState<VariableExpense> state, {
    Size size = TestViewports.desktop,
  }) async {
    final bloc = registerVariableExpenseBloc(state);
    await tester.pumpApp(location: AppRoute.expensesVariable.path, size: size);
    return bloc;
  }

  testWidgets('starts loading and shows an empty state', (tester) async {
    final bloc = await pumpVariable(tester, const CrudLoaded([]));

    verify(() => bloc.add(const CrudLoadRequested<_Draft>())).called(1);
    expect(find.text('No variable expenses'), findsOneWidget);
  });

  for (final size in TestViewports.expenseWidths) {
    testWidgets('groups by category in enum order at ${size.width}',
        (tester) async {
      await pumpVariable(tester, _loaded, size: size);

      expect(
        tester.widget<StatCard>(find.byType(StatCard)).value,
        CurrencyFormatter.format(const Money.fromPesos(2444900)),
      );
      expect(find.byType(ChoiceChip), findsNWidgets(8));
      expect(
        tester.getTopLeft(find.text('STREAMING').first).dy,
        lessThan(tester.getTopLeft(find.text('HOUSEHOLD STAFF').first).dy),
      );
      expect(
        tester.getTopLeft(find.text('HOUSEHOLD STAFF').first).dy,
        lessThan(tester.getTopLeft(find.text('DINING').first).dy),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('filters by category', (tester) async {
    await pumpVariable(tester, _loaded);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Dining'));
    await tester.pumpAndSettle();

    expect(find.text('Restaurantes'), findsOneWidget);
    expect(find.text('Netflix'), findsNothing);
  });

  testWidgets('edits a variable expense', (tester) async {
    final bloc = await pumpVariable(tester, _loaded);

    await tester.tap(find.text('Empleada'));
    await tester.pumpAndSettle();
    expect(find.text('Edit variable expense'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextField, ExpenseTexts.monthlyAmount),
      '1.900.000',
    );
    await tester.tap(find.byKey(ItemFormSheet.saveKey));
    await tester.pump();

    verify(
      () => bloc.add(
        const CrudSaveRequested(
          CategorizedDraft(
            name: 'Empleada',
            amount: Money.fromPesos(1900000),
            category: VariableExpenseCategory.householdStaff,
          ),
          id: 'v2',
        ),
      ),
    ).called(1);
    expect(find.byKey(CrudScreen.addButtonKey), findsOneWidget);
    expect(CrudTexts.allCategories, 'All');
  });
}
