import 'dart:async';

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
import 'package:pennypincher_pro/core/widgets/confirmation_dialog.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/screen/income_sources_screen.dart';

import '../../../../helpers/budget_fixtures.dart';
import '../../../../helpers/budget_mocks.dart';
import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/pump_app.dart';

const CrudScreenConfig<IncomeSource, CategorizedDraft<IncomeCategory>> _config =
    IncomeSourcesScreen.config;
const CrudLoaded<IncomeSource> _loaded =
    CrudLoaded([arriendoMadera, remoti, avenueCode]);

Finder _field(String label) => find.widgetWithText(TextField, label);

void main() {
  setUpAll(() {
    registerFallbackValue(
      const CrudLoadRequested<CategorizedDraft<IncomeCategory>>(),
    );
    return loadAppFonts();
  });

  Future<MockIncomeSourceBloc> pumpIncome(
    WidgetTester tester,
    CrudState<IncomeSource> state, {
    Size size = TestViewports.mobile,
    Stream<CrudState<IncomeSource>> stream = const Stream.empty(),
  }) async {
    final bloc = registerIncomeSourceBloc(state, stream: stream);
    await tester.pumpApp(location: AppRoute.budgetIncome.path, size: size);
    return bloc;
  }

  testWidgets('starts loading the income sources when it opens',
      (tester) async {
    final bloc = await pumpIncome(tester, const CrudLoading());

    expect(find.byType(IncomeSourcesScreen), findsOneWidget);
    expect(find.byType(LoadingSkeleton), findsOneWidget);
    verify(
      () => bloc.add(
        const CrudLoadRequested<CategorizedDraft<IncomeCategory>>(),
      ),
    ).called(1);
  });

  testWidgets('shows an encouraging empty state', (tester) async {
    await pumpIncome(tester, const CrudLoaded([]));

    expect(find.text('No income sources'), findsOneWidget);
    expect(
      find.textContaining('Add your first income source'),
      findsOneWidget,
    );
    expect(find.byKey(CrudScreen.addButtonKey), findsOneWidget);
  });

  testWidgets('groups income by category under the monthly total',
      (tester) async {
    await pumpIncome(tester, _loaded);

    final total = tester.widget<StatCard>(find.byType(StatCard));
    expect(total.label, 'Total monthly income');
    expect(
      total.value,
      CurrencyFormatter.format(const Money.fromPesos(37152922)),
    );
    expect(find.text('EMPLOYMENT'), findsNWidgets(3));
    expect(find.text('RENTAL'), findsNWidgets(2));
    expect(
      tester.getTopLeft(find.text('AvenueCode')).dy,
      lessThan(tester.getTopLeft(find.text('Remoti')).dy),
    );
    expect(
      tester.getTopLeft(find.text('Remoti')).dy,
      lessThan(tester.getTopLeft(find.text('Arriendo Madera')).dy),
    );
    expect(
      find.text(CurrencyFormatter.format(const Money.fromPesos(24152922))),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('lays the income out in two columns on desktop', (tester) async {
    await pumpIncome(tester, _loaded, size: TestViewports.desktop);

    expect(find.byType(SliverGrid), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('adds an income source from the bottom sheet', (tester) async {
    final states = StreamController<CrudState<IncomeSource>>();
    addTearDown(states.close);
    final bloc = await pumpIncome(
      tester,
      const CrudLoaded([]),
      stream: states.stream,
    );

    await tester.tap(find.byKey(CrudScreen.addButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('Add income source'), findsWidgets);
    await tester.enterText(_field(CrudTexts.nameLabel), ' Airbnb Barranca ');
    await tester.enterText(_field('Monthly amount'), '2.500.000');
    await tester.tap(find.text(CrudTexts.categoryLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rental').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ItemFormSheet.saveKey));
    await tester.pump();

    verify(
      () => bloc.add(
        const CrudSaveRequested(
          CategorizedDraft(
            name: 'Airbnb Barranca',
            amount: Money.fromPesos(2500000),
            category: IncomeCategory.rental,
          ),
        ),
      ),
    ).called(1);
  });

  testWidgets('edits an income source from its tile', (tester) async {
    final bloc = await pumpIncome(tester, _loaded);

    await tester.tap(find.text('Remoti'));
    await tester.pumpAndSettle();
    expect(find.text('Edit income source'), findsOneWidget);
    await tester.enterText(_field('Monthly amount'), '9.500.000');
    await tester.tap(find.byKey(ItemFormSheet.saveKey));
    await tester.pump();

    verify(
      () => bloc.add(
        const CrudSaveRequested(
          CategorizedDraft(
            name: 'Remoti',
            amount: Money.fromPesos(9500000),
            category: IncomeCategory.employment,
          ),
          id: 'i2',
        ),
      ),
    ).called(1);
  });

  testWidgets('deletes an income source only after confirmation',
      (tester) async {
    final bloc = await pumpIncome(tester, _loaded);

    await tester.tap(find.byTooltip(_config.deleteTooltip('Arriendo Madera')));
    await tester.pumpAndSettle();
    expect(find.text('Delete income source?'), findsOneWidget);
    await tester.tap(find.text(ConfirmationDialog.cancelLabel));
    await tester.pumpAndSettle();
    verifyNever(() => bloc.add(const CrudDeleteRequested('i3')));

    await tester.tap(find.byTooltip(_config.deleteTooltip('Arriendo Madera')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(CrudTexts.delete));
    await tester.pumpAndSettle();

    verify(() => bloc.add(const CrudDeleteRequested('i3'))).called(1);
  });

  testWidgets('goes back to the budget overview', (tester) async {
    await pumpIncome(tester, _loaded);

    expect(_config.backTooltip, 'Back to Budget Overview');
    expect(find.byTooltip(_config.backTooltip), findsOneWidget);
  });
}
