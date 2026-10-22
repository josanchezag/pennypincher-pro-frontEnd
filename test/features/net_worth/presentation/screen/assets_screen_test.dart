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
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/confirmation_dialog.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/core/widgets/placeholder_screen.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/screen/assets_screen.dart';

import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/net_worth_fixtures.dart';
import '../../../../helpers/net_worth_mocks.dart';
import '../../../../helpers/pump_app.dart';

const CrudScreenConfig<AssetCategory> _config = AssetsScreen.config;
const CrudLoaded<Asset> _loaded = CrudLoaded([car, apartment, wallet]);

Finder _field(String label) => find.widgetWithText(TextField, label);

void main() {
  setUpAll(() {
    registerFallbackValue(const CrudLoadRequested<AssetCategory>());
    return loadAppFonts();
  });

  Future<MockAssetBloc> pumpAssets(
    WidgetTester tester,
    CrudState<Asset> state, {
    Size size = TestViewports.mobile,
    Stream<CrudState<Asset>> stream = const Stream.empty(),
  }) async {
    final bloc = registerAssetBloc(state, stream: stream);
    await tester.pumpApp(location: AppRoute.netWorthAssets.path, size: size);
    return bloc;
  }

  testWidgets('starts loading the assets when it opens', (tester) async {
    final bloc = await pumpAssets(tester, const CrudLoading());

    expect(find.byType(AssetsScreen), findsOneWidget);
    expect(find.byType(LoadingSkeleton), findsOneWidget);
    expect(find.byKey(CrudScreen.addButtonKey), findsNothing);
    verify(() => bloc.add(const CrudLoadRequested<AssetCategory>())).called(1);
  });

  testWidgets('offers a retry when loading fails', (tester) async {
    final bloc = await pumpAssets(
      tester,
      const CrudLoadFailure('Could not reach the server.'),
    );
    clearInteractions(bloc);

    expect(find.text(CrudTexts.loadErrorTitle), findsOneWidget);
    expect(find.text('Could not reach the server.'), findsOneWidget);
    await tester.tap(find.text(CrudTexts.retry));

    verify(() => bloc.add(const CrudLoadRequested<AssetCategory>())).called(1);
  });

  testWidgets('shows an empty state without assets', (tester) async {
    await pumpAssets(tester, const CrudLoaded([]));

    expect(find.text('No assets'), findsOneWidget);
    expect(find.text(_config.emptyMessage), findsOneWidget);
    expect(find.byKey(CrudScreen.addButtonKey), findsOneWidget);
  });

  testWidgets('groups assets by category with subtotals and a total',
      (tester) async {
    await pumpAssets(tester, _loaded);

    final total = tester.widget<StatCard>(find.byType(StatCard));
    expect(total.label, 'Total assets');
    expect(total.value, contains('412.150.001'));
    expect(find.text('REAL ESTATE'), findsNWidgets(2));
    expect(find.text('VEHICLE'), findsNWidgets(2));
    expect(find.text('Apto Madera'), findsOneWidget);
    expect(find.byType(SliverGrid), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('labels tiles and actions for screen readers', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpAssets(tester, _loaded);

    expect(find.bySemanticsLabel(RegExp('^Apto Madera')), findsOneWidget);
    expect(find.byTooltip(_config.addLabel), findsOneWidget);
    expect(find.byTooltip(_config.deleteTooltip('Apto Madera')), findsOne);
    semantics.dispose();
  });

  testWidgets('lays the assets out in two columns from tablet up',
      (tester) async {
    await pumpAssets(tester, _loaded, size: TestViewports.tablet);

    final grid = tester.widget<SliverGrid>(find.byType(SliverGrid).first);
    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 2);
    expect(tester.takeException(), isNull);
  });

  Future<void> fillNewAsset(WidgetTester tester) async {
    await tester.tap(find.byKey(CrudScreen.addButtonKey));
    await tester.pumpAndSettle();
    await tester.enterText(_field(CrudTexts.nameLabel), '  Moto  ');
    await tester.enterText(_field('Value'), '8.500.000,50');
    await tester.tap(find.text(CrudTexts.categoryLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vehicle').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ItemFormSheet.saveKey));
    await tester.pump();
  }

  const moto = Asset(
    id: 'a9',
    name: 'Moto',
    value: Money.fromCents(850000050),
    category: AssetCategory.vehicle,
  );

  testWidgets('keeps the add sheet open until the asset is saved',
      (tester) async {
    final states = StreamController<CrudState<Asset>>();
    addTearDown(states.close);
    final bloc = await pumpAssets(
      tester,
      const CrudLoaded([]),
      stream: states.stream,
    );

    await fillNewAsset(tester);

    verify(
      () => bloc.add(
        const CrudSaveRequested(
          ItemDraft(
            name: 'Moto',
            amount: Money.fromCents(850000050),
            category: AssetCategory.vehicle,
          ),
        ),
      ),
    ).called(1);
    states.add(const CrudLoaded([], busy: true));
    await tester.pump();
    expect(find.byType(ItemFormSheet<Asset, AssetCategory>), findsOneWidget);
    final save = tester.widget<FilledButton>(find.byKey(ItemFormSheet.saveKey));
    expect(save.onPressed, isNull);

    states.add(const CrudLoaded([moto]));
    await tester.pumpAndSettle();
    expect(find.byType(ItemFormSheet<Asset, AssetCategory>), findsNothing);
  });

  testWidgets('shows a failed save inside the sheet and keeps the input',
      (tester) async {
    final states = StreamController<CrudState<Asset>>();
    addTearDown(states.close);
    await pumpAssets(tester, const CrudLoaded([]), stream: states.stream);

    await fillNewAsset(tester);
    states
      ..add(const CrudLoaded([], busy: true))
      ..add(
        const CrudLoaded(
          [],
          errorMessage: 'Validation failed: name is too long',
          failedAction: CrudAction.save,
        ),
      );
    await tester.pumpAndSettle();

    expect(find.byKey(ItemFormSheet.errorKey), findsOneWidget);
    expect(find.text('Validation failed: name is too long'), findsOneWidget);
    expect(find.text('8.500.000,50'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
    final save = tester.widget<FilledButton>(find.byKey(ItemFormSheet.saveKey));
    expect(save.onPressed, isNotNull);
  });

  testWidgets('names the sheet for screen readers', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpAssets(tester, const CrudLoaded([]));

    await tester.tap(find.byKey(CrudScreen.addButtonKey));
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.text(_config.addLabel).last),
      matchesSemantics(label: 'Add asset', isHeader: true, namesRoute: true),
    );
    expect(find.text(CrudTexts.amountHelper), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('validates the add sheet before saving', (tester) async {
    final bloc = await pumpAssets(tester, const CrudLoaded([]));
    clearInteractions(bloc);

    await tester.tap(find.byKey(CrudScreen.addButtonKey));
    await tester.pumpAndSettle();
    await tester.enterText(_field('Value'), '1.50.000');
    await tester.tap(find.byKey(ItemFormSheet.saveKey));
    await tester.pumpAndSettle();

    expect(find.text(CrudTexts.nameRequired), findsOneWidget);
    expect(find.text(CrudTexts.amountInvalid), findsOneWidget);
    expect(find.text(CrudTexts.categoryRequired), findsOneWidget);
    verifyNever(() => bloc.add(any()));
  });

  testWidgets('edits an asset from its tile', (tester) async {
    final bloc = await pumpAssets(tester, _loaded);

    await tester.tap(find.text('Carro Mazda'));
    await tester.pumpAndSettle();
    expect(find.text('Edit asset'), findsOneWidget);
    expect(find.text('62000000'), findsOneWidget);
    await tester.enterText(_field('Value'), '58.000.000');
    await tester.tap(find.byKey(ItemFormSheet.saveKey));
    await tester.pump();

    verify(
      () => bloc.add(
        const CrudSaveRequested(
          ItemDraft(
            name: 'Carro Mazda',
            amount: Money.fromPesos(58000000),
            category: AssetCategory.vehicle,
          ),
          id: 'a2',
        ),
      ),
    ).called(1);
  });

  testWidgets('deletes an asset only after confirmation', (tester) async {
    final bloc = await pumpAssets(tester, _loaded);
    final deleteButton = find.byTooltip(_config.deleteTooltip('Billetera'));

    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text(ConfirmationDialog.cancelLabel));
    await tester.pumpAndSettle();
    verifyNever(() => bloc.add(const CrudDeleteRequested('a3')));

    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
    expect(find.text(_config.deleteMessage('Billetera')), findsOneWidget);
    await tester.tap(find.text(CrudTexts.delete));
    await tester.pumpAndSettle();

    verify(() => bloc.add(const CrudDeleteRequested('a3'))).called(1);
  });

  testWidgets('reports a failed delete in the screen snack bar',
      (tester) async {
    final states = StreamController<CrudState<Asset>>();
    addTearDown(states.close);
    await pumpAssets(tester, _loaded, stream: states.stream);

    states.add(
      const CrudLoaded(
        [car],
        errorMessage: 'Asset not found',
        failedAction: CrudAction.delete,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(AssetsScreen),
        matching: find.text('Asset not found'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('returns to the net worth screen', (tester) async {
    await pumpAssets(tester, _loaded);

    await tester.tap(find.byTooltip(_config.backTooltip));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(PlaceholderScreen),
        matching: find.text(AppRoute.netWorth.title),
      ),
      findsOneWidget,
    );
  });
}
