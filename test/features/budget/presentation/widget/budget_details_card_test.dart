import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/monthly_budget_bloc.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/budget_details_card.dart';

import '../../../../helpers/exchange_rate_fixtures.dart';
import '../../../../helpers/l10n.dart';
import '../../../../helpers/load_fonts.dart';

const BudgetSettings _settings =
    BudgetSettings(exchangeRate: todayTrm, workDays: 22);
final DateTime _today = DateTime(2026, 10, 22);

void main() {
  setUpAll(loadAppFonts);
  tearDown(() => Intl.defaultLocale = testLocale.languageCode);

  Future<List<BudgetSettings>> pumpCard(
    WidgetTester tester, {
    ExchangeRateMode mode = ExchangeRateMode.manual,
    Money? eurCop,
    AppCurrency currency = AppCurrency.cop,
    Locale locale = testLocale,
    BudgetSettings settings = _settings,
  }) async {
    Intl.defaultLocale = locale.languageCode;
    final changes = <BudgetSettings>[];
    await tester.pumpWidget(
      localizedApp(
        locale: locale,
        home: MoneyFormatScope(
          formatter: MoneyFormatter.of(currency, locale.languageCode),
          child: Scaffold(
            body: BudgetDetailsCard(
              settings: settings,
              enabled: true,
              exchangeRateMode: mode,
              rateDate: _today,
              eurCop: eurCop,
              onChanged: changes.add,
            ),
          ),
        ),
      ),
    );
    return changes;
  }

  Finder caption() => find.byKey(BudgetDetailsCard.exchangeRateCaptionKey);

  testWidgets('keeps the pencil of a past month without a caption',
      (tester) async {
    await pumpCard(tester);

    expect(find.text('COP 3,316.70'), findsOneWidget);
    expect(find.byKey(BudgetDetailsCard.exchangeRateEditKey), findsOneWidget);
    expect(caption(), findsNothing);
    expect(find.byKey(BudgetDetailsCard.eurCopKey), findsNothing);
  });

  testWidgets("shows today's TRM of the current month without a pencil",
      (tester) async {
    await pumpCard(
      tester,
      mode: ExchangeRateMode.automatic,
      eurCop: todayEurCop,
    );

    expect(find.text('COP 3,316.70'), findsOneWidget);
    expect(find.byKey(BudgetDetailsCard.exchangeRateEditKey), findsNothing);
    expect(
      find.text(l10n.budgetExchangeRateAutomatic('Oct 22, 2026')),
      findsOneWidget,
    );
    expect(find.byKey(BudgetDetailsCard.workDaysEditKey), findsOneWidget);
  });

  testWidgets('shows the EUR/COP close read only', (tester) async {
    await pumpCard(
      tester,
      mode: ExchangeRateMode.automatic,
      eurCop: todayEurCop,
    );

    expect(find.text(l10n.budgetEurCopClose), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(BudgetDetailsCard.eurCopKey)).data,
      'COP 3,632.10',
    );
    expect(find.byType(IconButton), findsOneWidget);
  });

  testWidgets('hides the pencil while the rates load', (tester) async {
    await pumpCard(tester, mode: ExchangeRateMode.pending);

    expect(find.byKey(BudgetDetailsCard.exchangeRateEditKey), findsNothing);
    expect(caption(), findsNothing);
  });

  testWidgets("lets the TRM be edited when today's is unavailable",
      (tester) async {
    final changes = await pumpCard(
      tester,
      mode: ExchangeRateMode.unavailable,
    );

    expect(
      find.text(l10n.budgetExchangeRateUnavailable),
      findsOneWidget,
    );
    await tester.tap(find.byKey(BudgetDetailsCard.exchangeRateEditKey));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '3400');
    await tester.tap(find.text(l10n.commonSave));
    await tester.pumpAndSettle();

    expect(changes, [
      const BudgetSettings(exchangeRate: Money.fromUnits(3400), workDays: 22),
    ]);
  });

  testWidgets("says when saving today's TRM failed", (tester) async {
    await pumpCard(tester, mode: ExchangeRateMode.saveFailed);

    expect(find.text(l10n.budgetExchangeRateSaveFailed), findsOneWidget);
    expect(find.byKey(BudgetDetailsCard.exchangeRateEditKey), findsOneWidget);
  });

  testWidgets('hides the TRM of a euro account but not the EUR/COP close',
      (tester) async {
    await pumpCard(
      tester,
      mode: ExchangeRateMode.automatic,
      eurCop: todayEurCop,
      currency: AppCurrency.eur,
    );

    expect(find.text(l10n.budgetExchangeRate), findsNothing);
    expect(caption(), findsNothing);
    expect(find.byKey(BudgetDetailsCard.eurCopKey), findsOneWidget);
  });

  testWidgets('writes the captions in Spanish', (tester) async {
    await pumpCard(
      tester,
      mode: ExchangeRateMode.automatic,
      eurCop: todayEurCop,
      locale: AppLocales.spanish,
    );

    expect(find.text('EUR/COP (cierre)'), findsOneWidget);
    expect(
      find.text('TRM de hoy (22 oct 2026), se actualiza automáticamente.'),
      findsOneWidget,
    );
    expect(find.text('\$ 3.632,10'), findsOneWidget);
  });
}
