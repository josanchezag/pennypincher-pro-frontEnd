import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_theme.dart';
import 'package:pennypincher_pro/core/theme/progress_band.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goal_styles.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goals_texts.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/circular_progress_indicator_widget.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_card.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_level_badge.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/halfway_celebration.dart';

import '../../../../helpers/goal_fixtures.dart';
import '../../../../helpers/load_fonts.dart';

Future<void> _pump(WidgetTester tester, Widget child, {double width = 360}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(width: width, child: child),
          ),
        ),
      ),
    );

String _cop(int pesos) => CurrencyFormatter.format(Money.fromPesos(pesos));

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
      final text = tester.widget<Text>(find.text(level.label.toUpperCase()));
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

    expect(find.text(GoalsTexts.goalReached), findsOneWidget);
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

    expect(find.text(GoalsTexts.halfwayThere), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text(GoalsTexts.halfwayThere), findsNothing);
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
}
