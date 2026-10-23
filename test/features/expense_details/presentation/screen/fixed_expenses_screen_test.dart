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
import 'package:pennypincher_pro/features/expense_details/domain/entity/fixed_expense_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/expense_texts.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/fixed_expenses_screen.dart';

import '../../../../helpers/expense_fixtures.dart';
import '../../../../helpers/expense_mocks.dart';
import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/pump_app.dart';

typedef _Draft = CategorizedDraft<FixedExpenseCategory>;

const CrudScreenConfig<FixedExpense, _Draft> _config =
    FixedExpensesScreen.config;
const CrudLoaded<FixedExpense> _loaded =
    CrudLoaded([rent, schoolAna, tithe, englishClasses]);

Finder _chip(String label) => find.widgetWithText(ChoiceChip, label);

Finder _field(String label) => find.widgetWithText(TextField, label);

String _total(WidgetTester tester) =>
    tester.widget<StatCard>(find.byType(StatCard)).value;

void main() {
  setUpAll(() {
    registerFallbackValue(const CrudLoadRequested<_Draft>());
    return loadAppFonts();
  });

  Future<MockFixedExpenseBloc> pumpFixed(
    WidgetTester tester,
    CrudState<FixedExpense> state, {
    Size size = TestViewports.desktop,
  }) async {
    final bloc = registerFixedExpenseBloc(state);
    await tester.pumpApp(location: AppRoute.expensesFixed.path, size: size);
    return bloc;
  }

  testWidgets('starts loading and shows an empty state without chips',
      (tester) async {
    final bloc = await pumpFixed(tester, const CrudLoaded([]));

    verify(() => bloc.add(const CrudLoadRequested<_Draft>())).called(1);
    expect(find.text('No fixed expenses'), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNothing);
    expect(_total(tester), CurrencyFormatter.format(Money.zero));
  });

  for (final size in TestViewports.expenseWidths) {
    testWidgets('groups by category with subtotals at ${size.width}',
        (tester) async {
      await pumpFixed(tester, _loaded, size: size);

      expect(
        _total(tester),
        CurrencyFormatter.format(const Money.fromCents(926300150)),
      );
      expect(find.byType(ChoiceChip), findsNWidgets(12));
      final education = find.text('EDUCATION');
      final housing = find.text('HOUSING');
      expect(
        tester.getTopLeft(education.first).dy,
        lessThan(tester.getTopLeft(housing.first).dy),
      );
      expect(
        find.text(CurrencyFormatter.format(const Money.fromPesos(2347709))),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('filters by category and keeps the overall total',
      (tester) async {
    await pumpFixed(tester, _loaded);
    final total = _total(tester);

    await tester.tap(_chip('Education'));
    await tester.pumpAndSettle();

    expect(find.text('Colegio Ana'), findsOneWidget);
    expect(find.text('clases de ingles'), findsOneWidget);
    expect(find.text('Arriendo'), findsNothing);
    expect(find.text('Diezmo'), findsNothing);
    expect(_total(tester), total);
    expect(
      tester.widget<ChoiceChip>(_chip('Education')).selected,
      isTrue,
    );

    await tester.tap(_chip(CrudTexts.allCategories));
    await tester.pumpAndSettle();
    expect(find.text('Arriendo'), findsOneWidget);
  });

  testWidgets('shows an empty state for a category without expenses',
      (tester) async {
    await pumpFixed(tester, _loaded, size: TestViewports.expenseWidths.first);

    await tester.dragUntilVisible(
      _chip('Taxes'),
      find.byType(SingleChildScrollView),
      const Offset(-200, 0),
    );
    await tester.tap(_chip('Taxes'));
    await tester.pumpAndSettle();

    expect(find.text('${CrudTexts.emptyCategoryPrefix} Taxes'), findsOneWidget);
    expect(find.text(CrudTexts.emptyCategoryMessage), findsOneWidget);
    expect(find.text('Colegio Ana'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final size in TestViewports.expenseWidths.skip(1)) {
    testWidgets('wraps the chips within the screen at ${size.width}',
        (tester) async {
      await pumpFixed(tester, _loaded, size: size);

      for (final chip
          in tester.widgetList<ChoiceChip>(find.byType(ChoiceChip))) {
        final rect = tester.getRect(find.byWidget(chip));
        expect(rect.right, lessThanOrEqualTo(size.width));
      }
      await tester.tap(_chip('Other'));
      await tester.pumpAndSettle();
      final empty = find.text('${CrudTexts.emptyCategoryPrefix} Other');
      expect(empty, findsOneWidget);
    });
  }

  testWidgets('adds a fixed expense with its category', (tester) async {
    final bloc = await pumpFixed(tester, const CrudLoaded([]));

    await tester.tap(find.byKey(CrudScreen.addButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('Add fixed expense'), findsWidgets);
    await tester.enterText(_field(CrudTexts.nameLabel), 'Diezmo');
    await tester.enterText(_field(ExpenseTexts.monthlyAmount), '3.715.292');
    await tester.tap(find.text(CrudTexts.categoryLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Charity').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ItemFormSheet.saveKey));
    await tester.pump();

    verify(
      () => bloc.add(
        const CrudSaveRequested(
          CategorizedDraft(
            name: 'Diezmo',
            amount: Money.fromPesos(3715292),
            category: FixedExpenseCategory.charity,
          ),
        ),
      ),
    ).called(1);
  });

  testWidgets('edits and deletes a filtered expense', (tester) async {
    final bloc = await pumpFixed(tester, _loaded);
    await tester.tap(_chip('Housing'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Arriendo'));
    await tester.pumpAndSettle();
    expect(find.text('Edit fixed expense'), findsOneWidget);
    expect(find.text('3200000,50'), findsOneWidget);
    Navigator.of(
      tester.element(find.byType(ItemFormSheet<FixedExpense, _Draft>)),
    ).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(_config.deleteTooltip('Arriendo')));
    await tester.pumpAndSettle();
    expect(find.text('Delete fixed expense?'), findsOneWidget);
    await tester.tap(find.text(CrudTexts.delete));
    await tester.pumpAndSettle();

    verify(() => bloc.add(const CrudDeleteRequested('f3'))).called(1);
  });
}
