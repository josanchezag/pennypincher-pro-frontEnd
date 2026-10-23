import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/confirmation_dialog.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/credit_card_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/expenses_hub_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/expense_texts.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/credit_cards_screen.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/expenses_hub_screen.dart';

import '../../../../helpers/crud_screen_helpers.dart';
import '../../../../helpers/expense_fixtures.dart';
import '../../../../helpers/expense_mocks.dart';
import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/pump_app.dart';

const CrudScreenConfig<CreditCard, BalanceDraft> _config =
    CreditCardsScreen.config;
const CrudLoaded<CreditCard> _loaded = CrudLoaded([visaCard, nuCard, amexCard]);

void main() {
  setUpAll(() {
    registerFallbackValue(const CrudLoadRequested<BalanceDraft>());
    return loadAppFonts();
  });

  Future<MockCreditCardBloc> pumpCards(
    WidgetTester tester,
    CrudState<CreditCard> state, {
    Size size = TestViewports.desktop,
    Stream<CrudState<CreditCard>> stream = const Stream.empty(),
  }) async {
    final bloc = registerCreditCardBloc(state, stream: stream);
    await tester.pumpApp(
      location: AppRoute.expensesCreditCards.path,
      size: size,
    );
    return bloc;
  }

  testWidgets('starts loading the credit cards when it opens', (tester) async {
    final bloc = await pumpCards(tester, const CrudLoading());

    expect(find.byType(LoadingSkeleton), findsOneWidget);
    verify(() => bloc.add(const CrudLoadRequested<BalanceDraft>())).called(1);
  });

  testWidgets('shows an empty state with zero totals', (tester) async {
    await pumpCards(tester, const CrudLoaded([]));

    expect(find.text('No credit cards'), findsOneWidget);
    expect(find.textContaining('Add your credit cards'), findsOneWidget);
    expectStat(tester, ExpenseTexts.totalMonthlyPayments, Money.zero);
    expect(find.byKey(CrudScreen.addButtonKey), findsOneWidget);
  });

  for (final size in TestViewports.expenseWidths) {
    testWidgets('lists the cards by name at ${size.width}', (tester) async {
      await pumpCards(tester, _loaded, size: size);

      expect(
        topOf(tester, find.text('amex Platinum')),
        lessThanOrEqualTo(topOf(tester, find.text('Visa Bancolombia'))),
      );
      expect(
        find.text(CurrencyFormatter.format(nuCard.totalBalance)),
        findsOneWidget,
      );
      expect(labeledAmount(visaCard.monthlyPayment), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows the totals below the cards at ${size.width}',
        (tester) async {
      await pumpCards(tester, _loaded, size: size);

      final totals = find.byType(StatCard);
      await tester.ensureVisible(totals.last);
      await tester.pumpAndSettle();
      expect(
        topOf(tester, totals.first),
        greaterThan(topOf(tester, find.text('Visa Bancolombia'))),
      );
      expectStat(
        tester,
        ExpenseTexts.totalOutstandingBalance,
        const Money.fromPesos(46956922),
      );
      expectStat(
        tester,
        ExpenseTexts.totalMonthlyPayments,
        const Money.fromCents(205000050),
      );
      expect(tester.takeException(), isNull);
    });
  }

  for (final size in TestViewports.expenseWidths) {
    testWidgets('wraps long names so similar cards stay apart at ${size.width}',
        (tester) async {
      const names = [
        'Visa Bancolombia Platinum personal',
        'Visa Bancolombia Platinum empresa',
      ];
      await pumpCards(
        tester,
        CrudLoaded([
          for (final (index, name) in names.indexed)
            visaCard.copyWith(id: 'long$index', name: name),
        ]),
        size: size,
      );

      for (final name in names) {
        final paragraph = tester.renderObject<RenderParagraph>(find.text(name));
        expect(paragraph.didExceedMaxLines, isFalse);
      }
    });

    testWidgets('fits the tiles at text scale 1.5 at ${size.width}',
        (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await pumpCards(tester, _loaded, size: size);

      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('adds a credit card from the bottom sheet', (tester) async {
    final bloc = await pumpCards(tester, const CrudLoaded([]));

    await tester.tap(find.byKey(CrudScreen.addButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('Add credit card'), findsWidgets);
    await fillAndSave(tester, {
      CrudTexts.nameLabel: ' Tarjeta Nu Bank ',
      ExpenseTexts.monthlyPayment: '0',
      ExpenseTexts.totalBalance: '12.407.700',
    });

    verify(
      () => bloc.add(
        const CrudSaveRequested(
          BalanceDraft(
            name: 'Tarjeta Nu Bank',
            monthlyAmount: Money.zero,
            balance: Money.fromPesos(12407700),
          ),
        ),
      ),
    ).called(1);
  });

  testWidgets('validates both amounts before saving', (tester) async {
    final bloc = await pumpCards(tester, const CrudLoaded([]));

    await tester.tap(find.byKey(CrudScreen.addButtonKey));
    await tester.pumpAndSettle();
    await fillAndSave(tester, {
      CrudTexts.nameLabel: 'Visa',
      ExpenseTexts.monthlyPayment: '1,500',
    });

    expect(find.text(CrudTexts.amountInvalid), findsOneWidget);
    expect(find.text(CrudTexts.amountRequired), findsOneWidget);
    verifyNever(
      () => bloc.add(any(that: isA<CrudSaveRequested<BalanceDraft>>())),
    );
  });

  testWidgets('edits a card and keeps the sheet open when saving fails',
      (tester) async {
    final states = StreamController<CrudState<CreditCard>>();
    addTearDown(states.close);
    final bloc = await pumpCards(tester, _loaded, stream: states.stream);

    await tester.tap(find.text('Visa Bancolombia'));
    await tester.pumpAndSettle();
    expect(find.text('Edit credit card'), findsOneWidget);
    expect(find.text('1250000,50'), findsOneWidget);
    await fillAndSave(tester, {ExpenseTexts.totalBalance: '28.000.000'});
    verify(
      () => bloc.add(
        const CrudSaveRequested(
          BalanceDraft(
            name: 'Visa Bancolombia',
            monthlyAmount: Money.fromCents(125000050),
            balance: Money.fromPesos(28000000),
          ),
          id: 'c2',
        ),
      ),
    ).called(1);

    await failSave(tester, states, _loaded.items);
    expect(find.text('28.000.000'), findsOneWidget);
  });

  testWidgets('deletes a card after confirming from the button',
      (tester) async {
    final bloc = await pumpCards(tester, _loaded);

    await tester.tap(find.byTooltip(_config.deleteTooltip('Tarjeta Nu Bank')));
    await tester.pumpAndSettle();
    expect(find.text('Delete credit card?'), findsOneWidget);
    await tester.tap(find.text(ConfirmationDialog.cancelLabel));
    await tester.pumpAndSettle();
    verifyNever(() => bloc.add(const CrudDeleteRequested('c1')));

    await tester.tap(find.byTooltip(_config.deleteTooltip('Tarjeta Nu Bank')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(CrudTexts.delete));
    await tester.pumpAndSettle();

    verify(() => bloc.add(const CrudDeleteRequested('c1'))).called(1);
  });

  testWidgets('deletes a card after confirming a swipe', (tester) async {
    final bloc = await pumpCards(tester, _loaded);

    await tester.drag(find.text('amex Platinum'), const Offset(-600, 0));
    await tester.pumpAndSettle();
    expect(find.text('Delete credit card?'), findsOneWidget);
    await tester.tap(find.text(CrudTexts.delete));
    await tester.pumpAndSettle();

    verify(() => bloc.add(const CrudDeleteRequested('c3'))).called(1);
    expect(find.text('amex Platinum'), findsOneWidget);
  });

  testWidgets('goes back to the expenses hub', (tester) async {
    await pumpCards(tester, _loaded);
    registerExpensesHubBloc(const ExpensesHubState());

    await tester.tap(find.byTooltip(_config.backTooltip));
    await tester.pumpAndSettle();

    expect(_config.backTooltip, 'Back to Expenses');
    expect(find.byType(ExpensesHubScreen), findsOneWidget);
  });
}
