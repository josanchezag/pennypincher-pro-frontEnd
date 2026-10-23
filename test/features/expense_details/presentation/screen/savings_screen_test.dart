import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/confirmation_dialog.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/savings_account_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/expenses_hub_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/expense_texts.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/expenses_hub_screen.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/savings_screen.dart';

import '../../../../helpers/crud_screen_helpers.dart';
import '../../../../helpers/expense_fixtures.dart';
import '../../../../helpers/expense_mocks.dart';
import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/pump_app.dart';

const CrudScreenConfig<SavingsAccount, BalanceDraft> _config =
    SavingsScreen.config;
const CrudLoaded<SavingsAccount> _loaded =
    CrudLoaded([vacations, emergencyFund, cdt]);

void main() {
  setUpAll(() {
    registerFallbackValue(const CrudLoadRequested<BalanceDraft>());
    return loadAppFonts();
  });

  Future<MockSavingsAccountBloc> pumpSavings(
    WidgetTester tester,
    CrudState<SavingsAccount> state, {
    Size size = TestViewports.desktop,
    Stream<CrudState<SavingsAccount>> stream = const Stream.empty(),
  }) async {
    final bloc = registerSavingsAccountBloc(state, stream: stream);
    await tester.pumpApp(location: AppRoute.expensesSavings.path, size: size);
    return bloc;
  }

  testWidgets('starts loading the savings accounts when it opens',
      (tester) async {
    final bloc = await pumpSavings(tester, const CrudLoading());

    expect(find.byType(LoadingSkeleton), findsOneWidget);
    verify(() => bloc.add(const CrudLoadRequested<BalanceDraft>())).called(1);
  });

  testWidgets('encourages adding the first savings account', (tester) async {
    await pumpSavings(tester, const CrudLoaded([]));

    expect(find.text(_config.emptyTitle), findsOneWidget);
    expect(find.textContaining('Start your reserves'), findsOneWidget);
    expectStat(tester, ExpenseTexts.totalSavingsBalance, Money.zero);
    expect(find.byKey(CrudScreen.addButtonKey), findsOneWidget);
  });

  for (final size in TestViewports.expenseWidths) {
    testWidgets('shows the total balance first, in green, at ${size.width}',
        (tester) async {
      await pumpSavings(tester, _loaded, size: size);

      final balance = statCard(tester, ExpenseTexts.totalSavingsBalance);
      final first = tester.widget<StatCard>(find.byType(StatCard).first);
      expect(first, same(balance));
      expect(balance.valueColor, AppColors.success);
      expectStat(
        tester,
        ExpenseTexts.totalSavingsBalance,
        const Money.fromCents(2970000050),
      );
      expectStat(
        tester,
        ExpenseTexts.totalMonthlyContributions,
        const Money.fromPesos(800000),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('lists the accounts by name below the totals at ${size.width}',
        (tester) async {
      await pumpSavings(tester, _loaded, size: size);

      final cdtTop = topOf(tester, find.text('CDT Bancolombia'));
      expect(topOf(tester, find.byType(StatCard).first), lessThan(cdtTop));
      expect(
        cdtTop,
        lessThanOrEqualTo(topOf(tester, find.text('Fondo de emergencia'))),
      );
      expect(labeledAmount(emergencyFund.monthlyContribution), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('asks for the balance before the contribution', (tester) async {
    await pumpSavings(tester, const CrudLoaded([]));

    await tester.tap(find.byKey(CrudScreen.addButtonKey));
    await tester.pumpAndSettle();

    expect(
      topOf(tester, fieldLabeled(ExpenseTexts.currentBalance)),
      lessThan(topOf(tester, fieldLabeled(ExpenseTexts.monthlyContribution))),
    );
  });

  testWidgets('adds a savings account from the bottom sheet', (tester) async {
    final bloc = await pumpSavings(tester, const CrudLoaded([]));

    await tester.tap(find.byKey(CrudScreen.addButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('Add savings account'), findsWidgets);
    await fillAndSave(tester, {
      CrudTexts.nameLabel: ' Vacaciones ',
      ExpenseTexts.currentBalance: '1.200.000',
      ExpenseTexts.monthlyContribution: '300000',
    });

    verify(
      () => bloc.add(
        const CrudSaveRequested(
          BalanceDraft(
            name: 'Vacaciones',
            monthlyAmount: Money.fromPesos(300000),
            balance: Money.fromPesos(1200000),
          ),
        ),
      ),
    ).called(1);
  });

  testWidgets('edits an account and keeps the sheet open when saving fails',
      (tester) async {
    final states = StreamController<CrudState<SavingsAccount>>();
    addTearDown(states.close);
    final bloc = await pumpSavings(tester, _loaded, stream: states.stream);

    await tester.tap(find.text('CDT Bancolombia'));
    await tester.pumpAndSettle();
    expect(find.text('Edit savings account'), findsOneWidget);
    await fillAndSave(tester, {ExpenseTexts.currentBalance: '21.000.000'});
    verify(
      () => bloc.add(
        const CrudSaveRequested(
          BalanceDraft(
            name: 'CDT Bancolombia',
            monthlyAmount: Money.zero,
            balance: Money.fromPesos(21000000),
          ),
          id: 's2',
        ),
      ),
    ).called(1);

    await failSave(tester, states, _loaded.items);
    expect(find.text('21.000.000'), findsOneWidget);
  });

  testWidgets('refreshes the totals after a change', (tester) async {
    final states = StreamController<CrudState<SavingsAccount>>();
    addTearDown(states.close);
    await pumpSavings(tester, const CrudLoaded([cdt]), stream: states.stream);

    states.add(const CrudLoaded([cdt, vacations]));
    await tester.pumpAndSettle();

    expectStat(
      tester,
      ExpenseTexts.totalSavingsBalance,
      const Money.fromPesos(21200000),
    );
  });

  testWidgets('deletes an account after confirming', (tester) async {
    final bloc = await pumpSavings(tester, _loaded);

    await tester.tap(find.byTooltip(_config.deleteTooltip('Vacaciones')));
    await tester.pumpAndSettle();
    expect(find.text('Delete savings account?'), findsOneWidget);
    await tester.tap(find.text(ConfirmationDialog.cancelLabel));
    await tester.pumpAndSettle();
    verifyNever(() => bloc.add(const CrudDeleteRequested('s3')));

    await tester.tap(find.byTooltip(_config.deleteTooltip('Vacaciones')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(CrudTexts.delete));
    await tester.pumpAndSettle();

    verify(() => bloc.add(const CrudDeleteRequested('s3'))).called(1);
  });

  testWidgets('goes back to the expenses hub', (tester) async {
    await pumpSavings(tester, _loaded);
    registerExpensesHubBloc(const ExpensesHubState());

    await tester.tap(find.byTooltip(_config.backTooltip));
    await tester.pumpAndSettle();

    expect(find.byType(ExpensesHubScreen), findsOneWidget);
  });
}
