import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_sheet.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/liability_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/screen/liabilities_screen.dart';

import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/net_worth_fixtures.dart';
import '../../../../helpers/net_worth_mocks.dart';
import '../../../../helpers/pump_app.dart';

const CrudScreenConfig<Liability, CategorizedDraft<LiabilityCategory>> _config =
    LiabilitiesScreen.config;

Finder _field(String label) => find.widgetWithText(TextField, label);

void main() {
  setUpAll(loadAppFonts);

  Future<MockLiabilityBloc> pumpLiabilities(
    WidgetTester tester,
    CrudState<Liability> state, {
    Size size = TestViewports.mobile,
  }) async {
    final bloc = registerLiabilityBloc(state);
    await tester.pumpApp(
      location: AppRoute.netWorthLiabilities.path,
      size: size,
    );
    return bloc;
  }

  testWidgets('starts loading the liabilities when it opens', (tester) async {
    final bloc = await pumpLiabilities(tester, const CrudLoading());

    expect(find.byType(LoadingSkeleton), findsOneWidget);
    verify(
      () => bloc.add(
        const CrudLoadRequested<CategorizedDraft<LiabilityCategory>>(),
      ),
    ).called(1);
  });

  testWidgets('shows the total debt in red and groups by category',
      (tester) async {
    await pumpLiabilities(tester, const CrudLoaded([davivienda, nuCard]));

    final total = tester.widget<StatCard>(find.byType(StatCard));
    expect(total.label, 'Total liabilities');
    expect(total.valueColor, AppColors.error);
    expect(total.value, contains('48.700.000'));
    expect(find.text('CREDIT CARD'), findsNWidgets(2));
    expect(find.text('BANK LOAN'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows an empty state without liabilities', (tester) async {
    await pumpLiabilities(tester, const CrudLoaded([]));

    expect(find.text('No liabilities'), findsOneWidget);
    expect(find.text(_config.emptyMessage), findsOneWidget);
  });

  testWidgets('uses two columns on desktop', (tester) async {
    await pumpLiabilities(
      tester,
      const CrudLoaded([davivienda, nuCard]),
      size: TestViewports.desktop,
    );

    expect(find.byType(SliverGrid), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('creates a liability with its current balance', (tester) async {
    final bloc = await pumpLiabilities(tester, const CrudLoaded([]));

    await tester.tap(find.byKey(CrudScreen.addButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('Add liability'), findsWidgets);
    await tester.enterText(_field(CrudTexts.nameLabel), 'Préstamo tío');
    await tester.enterText(_field('Current balance'), '5.000.000');
    await tester.tap(find.text(CrudTexts.categoryLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Family debt').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ItemFormSheet.saveKey));
    await tester.pump();

    verify(
      () => bloc.add(
        const CrudSaveRequested(
          CategorizedDraft(
            name: 'Préstamo tío',
            amount: Money.fromPesos(5000000),
            category: LiabilityCategory.familyDebt,
          ),
        ),
      ),
    ).called(1);
  });

  testWidgets('deletes a liability after confirmation', (tester) async {
    final bloc = await pumpLiabilities(tester, const CrudLoaded([nuCard]));

    await tester.tap(find.byTooltip(_config.deleteTooltip(nuCard.name)));
    await tester.pumpAndSettle();
    expect(find.text('Delete liability?'), findsOneWidget);
    await tester.tap(find.text(CrudTexts.delete));
    await tester.pumpAndSettle();

    verify(() => bloc.add(const CrudDeleteRequested('l1'))).called(1);
  });
}
