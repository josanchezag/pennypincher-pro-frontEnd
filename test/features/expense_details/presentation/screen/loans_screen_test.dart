import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_tile.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/loan_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/expense_texts.dart';

import '../../../../helpers/crud_screen_helpers.dart';
import '../../../../helpers/expense_fixtures.dart';
import '../../../../helpers/expense_mocks.dart';
import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/pump_app.dart';

const CrudLoaded<Loan> _loaded = CrudLoaded([carLoan, davivienda, familyLoan]);

Finder _progressOf(String name) => find.descendant(
      of: find.ancestor(of: find.text(name), matching: find.byType(ItemTile)),
      matching: find.byType(ShareProgress),
    );

void main() {
  setUpAll(() {
    registerFallbackValue(const CrudLoadRequested<BalanceDraft>());
    return loadAppFonts();
  });

  Future<MockLoanBloc> pumpLoans(
    WidgetTester tester,
    CrudState<Loan> state, {
    Size size = TestViewports.desktop,
  }) async {
    final bloc = registerLoanBloc(state);
    await tester.pumpApp(location: AppRoute.expensesLoans.path, size: size);
    return bloc;
  }

  testWidgets('starts loading the loans and shows an empty state',
      (tester) async {
    final bloc = await pumpLoans(tester, const CrudLoaded([]));

    verify(() => bloc.add(const CrudLoadRequested<BalanceDraft>())).called(1);
    expect(find.text('No loans'), findsOneWidget);
    expect(find.textContaining('Add your loans'), findsOneWidget);
  });

  for (final size in TestViewports.expenseWidths) {
    testWidgets('shows installments, balances and totals at ${size.width}',
        (tester) async {
      await pumpLoans(tester, _loaded, size: size);

      expect(
        find.text(CurrencyFormatter.format(carLoan.totalBalance)),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          ExpenseTexts.monthlyInstallment,
          findRichText: true,
        ),
        findsNWidgets(3),
      );
      await tester.ensureVisible(find.byType(StatCard).last);
      await tester.pumpAndSettle();
      expectStat(
        tester,
        ExpenseTexts.totalOutstandingDebt,
        const Money.fromCents(8650000025),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('shows the paid progress only when the original is tracked',
      (tester) async {
    await pumpLoans(tester, _loaded);

    final car = tester.widget<ShareProgress>(_progressOf('Prestamo carro'));
    expect(car.share, closeTo(0.4, 1e-9));
    expect(car.label, '${PercentFormatter.format(40)} paid');
    expect(_progressOf('Davivienda 7141'), findsNothing);
    final family = tester.widget<ShareProgress>(_progressOf('Familia'));
    expect(family.share, 0);
  });

  testWidgets('reads the paid share once, from its label', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpLoans(tester, _loaded);

    final tile = tester.getSemantics(find.text('Prestamo carro'));
    expect(tile.label, contains('${PercentFormatter.format(40)} paid'));
    expect(tile.value, isEmpty);
    semantics.dispose();
  });

  testWidgets('adds a loan without its original amount', (tester) async {
    final bloc = await pumpLoans(tester, const CrudLoaded([]));

    await tester.tap(find.byKey(CrudScreen.addButtonKey));
    await tester.pumpAndSettle();
    expect(find.text(CrudTexts.optionalAmountHelper), findsOneWidget);
    await fillAndSave(tester, {
      CrudTexts.nameLabel: 'Davivienda 7141',
      ExpenseTexts.monthlyInstallment: '2.080.231',
      ExpenseTexts.remainingBalance: '45.500.000,25',
    });

    verify(
      () => bloc.add(
        const CrudSaveRequested(
          BalanceDraft(
            name: 'Davivienda 7141',
            monthlyAmount: Money.fromPesos(2080231),
            balance: Money.fromCents(4550000025),
          ),
        ),
      ),
    ).called(1);
  });

  for (final (typed, original) in [
    ('5,5', const Money.fromCents(550)),
    (' ', null),
  ]) {
    testWidgets('edits the original amount of a loan to "$typed"',
        (tester) async {
      final bloc = await pumpLoans(tester, _loaded);

      await tester.tap(find.text('Prestamo carro'));
      await tester.pumpAndSettle();
      expect(find.text('Edit loan'), findsOneWidget);
      expect(find.text('50000000'), findsOneWidget);
      await fillAndSave(tester, {ExpenseTexts.originalAmount: typed});

      verify(
        () => bloc.add(
          CrudSaveRequested(
            BalanceDraft(
              name: 'Prestamo carro',
              monthlyAmount: const Money.fromPesos(1200000),
              balance: const Money.fromPesos(30000000),
              originalAmount: original,
            ),
            id: 'l1',
          ),
        ),
      ).called(1);
    });
  }

  testWidgets('rejects an invalid original amount', (tester) async {
    final bloc = await pumpLoans(tester, const CrudLoaded([]));

    await tester.tap(find.byKey(CrudScreen.addButtonKey));
    await tester.pumpAndSettle();
    await fillAndSave(tester, {
      CrudTexts.nameLabel: 'Familia',
      ExpenseTexts.monthlyInstallment: '0',
      ExpenseTexts.remainingBalance: '1',
      ExpenseTexts.originalAmount: '1,500',
    });

    expect(find.text(CrudTexts.amountInvalid), findsOneWidget);
    verifyNever(
      () => bloc.add(any(that: isA<CrudSaveRequested<BalanceDraft>>())),
    );
  });
}
