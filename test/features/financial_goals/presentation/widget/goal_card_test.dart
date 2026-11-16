import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/progress_band.dart';
import 'package:pennypincher_pro/core/utils/app_currency.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/reference_return.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goal_styles.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/circular_progress_indicator_widget.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_card.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_figures.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_level_badge.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/halfway_celebration.dart';

import '../../../../helpers/goal_fixtures.dart';
import '../../../../helpers/l10n.dart';
import '../../../../helpers/load_fonts.dart';

Future<void> _pump(WidgetTester tester, Widget child, {double width = 360}) =>
    tester.pumpWidget(
      localizedApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(width: width, child: child),
          ),
        ),
      ),
    );

String _cop(int pesos) => testMoney.format(Money.fromUnits(pesos));

String _copCents(int cents) => testMoney.format(Money.fromCents(cents));

String _referenceText(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(GoalReferenceReturnLine.textKey)).data!;

/// WCAG contrast ratio between two colors.
double _contrast(Color a, Color b) {
  final (light, dark) = a.computeLuminance() > b.computeLuminance()
      ? (a.computeLuminance(), b.computeLuminance())
      : (b.computeLuminance(), a.computeLuminance());
  return (light + 0.05) / (dark + 0.05);
}

Color _ringColor(WidgetTester tester) => tester
    .widget<GoalCircularProgress>(find.byType(GoalCircularProgress))
    .color;

void main() {
  setUpAll(loadAppFonts);

  final bands = {
    24.96: AppColors.neutral,
    24.99: AppColors.neutral,
    25.0: AppColors.brandPrimary,
    49.96: AppColors.brandPrimary,
    49.99: AppColors.brandPrimary,
    50.0: AppColors.warning,
    74.96: AppColors.warning,
    74.99: AppColors.warning,
    75.0: AppColors.success,
    100.0: AppColors.success,
  };
  for (final MapEntry(key: percent, value: color) in bands.entries) {
    testWidgets('colors a progress of $percent %', (tester) async {
      await _pump(
        tester,
        GoalCard(goal: withProgress(security, percent), onTap: null),
      );

      expect(_ringColor(tester), color);
    });
  }

  final shownBelowBands = {74.96: 74.9, 49.96: 49.9, 24.96: 24.9, 57.3: 57.3};
  for (final MapEntry(key: percent, value: shown) in shownBelowBands.entries) {
    testWidgets('shows $percent % as $shown % in the band it is in',
        (tester) async {
      await _pump(
        tester,
        GoalCard(goal: withProgress(security, percent), onTap: null),
      );

      expect(find.text(PercentFormatter.format(shown)), findsOneWidget);
      expect(_ringColor(tester), ProgressBand.of(shown).color);
    });
  }

  test('treats a negative progress as just starting', () {
    expect(ProgressBand.of(-3), ProgressBand.starting);
  });

  const levels = {
    GoalLevel.financialSecurity: AppColors.brandPrimary,
    GoalLevel.financialIndependence: Color(0xFF0D9488),
    GoalLevel.financialFreedom: Color(0xFF7C3AED),
    GoalLevel.absoluteFreedom: AppColors.accentGold,
  };
  for (final MapEntry(key: level, value: color) in levels.entries) {
    testWidgets('badges the ${level.name} level in its color', (tester) async {
      await _pump(tester, GoalLevelBadge(level: level));

      expect(
        tester.widget<GoalLevelBadge>(find.byType(GoalLevelBadge)).color,
        color,
      );
      final box = tester.widget<Container>(find.byType(Container).first);
      expect((box.decoration! as BoxDecoration).color, color);
      final text =
          tester.widget<Text>(find.text(level.label(l10n).toUpperCase()));
      expect(_contrast(text.style!.color!, color), greaterThanOrEqualTo(4.5));
    });
  }

  testWidgets('shows the progress, amounts and plan of a goal', (tester) async {
    await _pump(tester, GoalCard(goal: security, onTap: null));

    expect(find.text('Seguridad Financiera'), findsOneWidget);
    expect(find.text('FINANCIAL SECURITY'), findsOneWidget);
    expect(find.text(securityDescription), findsOneWidget);
    expect(find.text(PercentFormatter.format(69.9)), findsOneWidget);
    expect(find.text(_cop(605000000)), findsOneWidget);
    expect(find.text(_cop(423282773)), findsOneWidget);
    expect(find.text(_cop(181717227)), findsOneWidget);
    expect(find.text('December 2029'), findsOneWidget);
    expect(find.text(_cop(1470000)), findsOneWidget);
    expect(find.text(PercentFormatter.format(11)), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('describes the level in the interface language, not the API',
      (tester) async {
    await tester.pumpWidget(
      localizedApp(
        locale: AppLocales.spanish,
        home: Scaffold(
          body: SingleChildScrollView(
            child: GoalCard(
              goal: security.copyWith(levelDescription: 'Sent by the API'),
              onTap: null,
            ),
          ),
        ),
      ),
    );

    expect(
      find.text(l10nEs.goalLevelFinancialSecurityDescription),
      findsOneWidget,
    );
    expect(find.text('Sent by the API'), findsNothing);
  });

  testWidgets('says when a goal is not reachable within 50 years',
      (tester) async {
    await _pump(tester, GoalCard(goal: absolute, onTap: null));

    expect(find.text('Not reachable within 50 years'), findsOneWidget);
    expect(find.text(PercentFormatter.format(11.5)), findsOneWidget);
  });

  testWidgets('says when a goal is already reached', (tester) async {
    final reached = security.copyWith(
      projection: security.projection!.copyWith(
        progressPercentage: 100,
        projectedMonthsToGoal: 0,
      ),
    );

    await _pump(tester, GoalCard(goal: reached, onTap: null));

    expect(find.text(l10n.goalsReached), findsOneWidget);
    expect(find.text(PercentFormatter.format(100)), findsOneWidget);
  });

  testWidgets('shows dashes while the projection is missing', (tester) async {
    await _pump(
      tester,
      GoalCard(goal: security.copyWith(projection: null), onTap: null),
    );

    expect(_ringColor(tester), AppColors.neutral);
    expect(find.text('—'), findsNWidgets(4));
  });

  testWidgets('edits the goal when tapped', (tester) async {
    var taps = 0;
    await _pump(tester, GoalCard(goal: security, onTap: () => taps++));

    await tester.tap(find.text('Seguridad Financiera'));

    expect(taps, 1);
  });

  testWidgets('celebrates once and then reports it finished', (tester) async {
    var finished = 0;
    await _pump(
      tester,
      GoalCard(
        goal: security,
        onTap: null,
        celebrate: true,
        onCelebrated: () => finished++,
      ),
    );
    await tester.pump(HalfwayCelebration.duration ~/ 2);

    expect(find.text(l10n.goalsHalfwayThere), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text(l10n.goalsHalfwayThere), findsNothing);
    expect(finished, 1);
  });

  testWidgets('starts the celebration when asked after being shown',
      (tester) async {
    await _pump(tester, GoalCard(goal: security, onTap: null));
    expect(find.byKey(HalfwayCelebration.messageKey), findsNothing);

    await _pump(tester, GoalCard(goal: security, onTap: null, celebrate: true));
    await tester.pump(HalfwayCelebration.duration ~/ 2);

    expect(find.byKey(HalfwayCelebration.messageKey), findsOneWidget);
    await tester.pumpAndSettle();
  });

  group('income modes', () {
    testWidgets(
        'shows the income, required investment and 10 % return of a '
        'goal based on the current income', (tester) async {
      await _pump(tester, GoalCard(goal: incomeIndependence, onTap: null));

      expect(find.text(l10n.goalsDesiredIncome.toUpperCase()), findsOneWidget);
      expect(find.text(_cop(10000000)), findsOneWidget);
      expect(find.text('Based on your income (×1)'), findsOneWidget);
      expect(find.text(_copCents(125405366123)), findsOneWidget);
      expect(
        find.text(l10n.goalsRequiredInvestmentShort.toUpperCase()),
        findsOne,
      );
      expect(
        find.text(l10n.goalsMonthlyInvestment.toUpperCase()),
        findsNothing,
      );
      expect(find.text(_copCents(176243439)), findsOneWidget);
      expect(find.text('16 years'), findsOneWidget);
      expect(
        _referenceText(tester),
        'At 10% a year it would yield ${_cop(10000000)} a month '
        '(${_copCents(12540536612)} a year)',
      );
      expect(find.byKey(GoalCard.baseOnIncomeKey), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('labels a typed income as the income the user wants',
        (tester) async {
      await _pump(tester, GoalCard(goal: desiredFreedom, onTap: null));

      expect(find.text(_cop(6000000)), findsWidgets);
      expect(find.text(l10n.goalsModeDesiredIncomeLabel), findsOneWidget);
      expect(find.textContaining('×'), findsNothing);
      expect(find.text('10 years'), findsOneWidget);
      expect(find.text(_copCents(269066677)), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows no income on a manual goal but its 10 % return',
        (tester) async {
      await _pump(tester, GoalCard(goal: security, onTap: null));

      expect(find.text(l10n.goalsDesiredIncome.toUpperCase()), findsNothing);
      expect(find.byKey(GoalIncomeSection.sourceKey), findsNothing);
      expect(find.text(l10n.goalsMonthlyInvestment.toUpperCase()), findsOne);
      expect(
        find.text(l10n.goalsRequiredInvestment.toUpperCase()),
        findsNothing,
      );
      expect(
        _referenceText(tester),
        'At 10% a year it would yield ${_copCents(482435496)} a month '
        '(${_cop(60500000)} a year)',
      );
    });

    testWidgets('shows what the term of a manual goal requires',
        (tester) async {
      await _pump(
        tester,
        GoalCard(
          goal: absolute.copyWith(
            targetYears: 16,
            requiredMonthlyInvestment: const Money.fromUnits(9000000),
          ),
          onTap: null,
        ),
      );

      expect(find.text(_cop(15850000)), findsOneWidget);
      expect(find.text(l10n.goalsRequiredInvestment.toUpperCase()), findsOne);
      expect(find.text(_cop(9000000)), findsOneWidget);
    });

    testWidgets('says when a goal has no term', (tester) async {
      await _pump(tester, GoalCard(goal: absolute, onTap: null));

      expect(find.text(l10n.goalsNoTerm), findsOneWidget);
    });

    testWidgets('prefers the 10 % return the backend sent', (tester) async {
      await _pump(
        tester,
        GoalCard(
          goal: security.copyWith(
            referenceReturn: const ReferenceReturn(
              annualRate: 0.10,
              annualAmount: Money.fromUnits(1),
              monthlyAmount: Money.fromUnits(2),
            ),
          ),
          onTap: null,
        ),
      );

      expect(
        _referenceText(tester),
        'At 10% a year it would yield ${_cop(2)} a month (${_cop(1)} a year)',
      );
    });

    testWidgets('offers to base a manual goal on the income', (tester) async {
      var taps = 0;
      await _pump(
        tester,
        GoalCard(goal: security, onTap: null, onBaseOnIncome: () => taps++),
      );

      await tester.tap(find.byKey(GoalCard.baseOnIncomeKey));

      expect(find.text(l10n.goalsBaseOnIncome), findsOneWidget);
      expect(taps, 1);
    });

    testWidgets('does not offer it on a goal already based on an income',
        (tester) async {
      await _pump(
        tester,
        GoalCard(goal: desiredFreedom, onTap: null, onBaseOnIncome: () {}),
      );

      expect(find.byKey(GoalCard.baseOnIncomeKey), findsNothing);
    });

    testWidgets('writes the income texts in Spanish', (tester) async {
      await tester.pumpWidget(
        localizedApp(
          locale: AppLocales.spanish,
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  GoalCard(
                    goal: incomeIndependence.copyWith(
                      level: GoalLevel.financialSecurity,
                      incomeFactor: 0.6,
                    ),
                    onTap: null,
                  ),
                  GoalCard(goal: desiredFreedom, onTap: null),
                  GoalCard(goal: security, onTap: null, onBaseOnIncome: () {}),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Según tu ingreso (×0,6)'), findsOneWidget);
      expect(find.text('Ingreso que quieres'), findsOneWidget);
      expect(find.text('INGRESO MENSUAL DESEADO'), findsNWidgets(2));
      expect(find.text('INVERSIÓN REQUERIDA'), findsNWidgets(2));
      expect(find.text('Basar en mi ingreso'), findsOneWidget);
      final spanishMoney = MoneyFormatter.of(AppCurrency.fallback, 'es');
      expect(
        find.text(
          'Con 10% EA rentaría '
          '${spanishMoney.format(const Money.fromUnits(10000000))} al mes '
          '(${spanishMoney.format(const Money.fromCents(12540536612))} al año)',
        ),
        findsOneWidget,
      );
    });

    for (final width in [320.0, 390.0]) {
      testWidgets('fits a goal based on the income in $width px',
          (tester) async {
        await _pump(
          tester,
          GoalCard(
            goal: incomeIndependence,
            onTap: null,
            onSeeProjection: () {},
          ),
          width: width,
        );
        await _pump(
          tester,
          GoalCard(goal: security, onTap: null, onBaseOnIncome: () {}),
          width: width,
        );

        expect(tester.takeException(), isNull);
      });
    }
  });
}
