import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_theme.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/widget/expense_percentage_row.dart';

import '../../../../helpers/load_fonts.dart';

void main() {
  setUpAll(loadAppFonts);

  group('PercentageStatus.of', () {
    test('is neutral without an ideal', () {
      expect(PercentageStatus.of(0, null), PercentageStatus.neutral);
      expect(PercentageStatus.of(250, null), PercentageStatus.neutral);
    });

    test('is on target at or below the ideal', () {
      expect(PercentageStatus.of(0, 20), PercentageStatus.onTarget);
      expect(PercentageStatus.of(19.99, 20), PercentageStatus.onTarget);
      expect(PercentageStatus.of(20, 20), PercentageStatus.onTarget);
    });

    test('is slightly over up to 10 % above the ideal', () {
      expect(PercentageStatus.of(20.01, 20), PercentageStatus.slightlyOver);
      expect(PercentageStatus.of(22, 20), PercentageStatus.slightlyOver);
      expect(PercentageStatus.of(11, 10), PercentageStatus.slightlyOver);
    });

    test('is over beyond 10 % above the ideal', () {
      expect(PercentageStatus.of(22.01, 20), PercentageStatus.over);
      expect(PercentageStatus.of(11.01, 10), PercentageStatus.over);
      expect(PercentageStatus.of(150, 10), PercentageStatus.over);
    });

    PercentageStatus atLeast(double actual, double? ideal) =>
        PercentageStatus.of(
          actual,
          ideal,
          direction: TargetDirection.atLeast,
        );

    test('treats a floor ideal as reached at or above it', () {
      expect(atLeast(10, 10), PercentageStatus.onTarget);
      expect(atLeast(35.5, 10), PercentageStatus.onTarget);
      expect(atLeast(0, null), PercentageStatus.neutral);
    });

    test('is slightly under down to 10 % below a floor ideal', () {
      expect(atLeast(9.99, 10), PercentageStatus.slightlyUnder);
      expect(atLeast(9, 10), PercentageStatus.slightlyUnder);
      expect(atLeast(18, 20), PercentageStatus.slightlyUnder);
    });

    test('is under beyond 10 % below a floor ideal', () {
      expect(atLeast(8.99, 10), PercentageStatus.under);
      expect(atLeast(17.99, 20), PercentageStatus.under);
      expect(atLeast(0, 10), PercentageStatus.under);
    });

    test('uses a floor for savings and charity only', () {
      expect(
        BudgetComponentType.values.where(
          (type) => type.direction == TargetDirection.atLeast,
        ),
        [BudgetComponentType.savings, BudgetComponentType.charity],
      );
    });

    test('maps every status to its color', () {
      expect(PercentageStatus.neutral.color, AppColors.neutral);
      expect(PercentageStatus.onTarget.color, AppColors.success);
      expect(PercentageStatus.slightlyOver.color, AppColors.warning);
      expect(PercentageStatus.over.color, AppColors.error);
      expect(PercentageStatus.slightlyUnder.color, AppColors.warning);
      expect(PercentageStatus.under.color, AppColors.error);
    });
  });

  Future<void> pump(
    WidgetTester tester,
    double percentage,
    double? ideal, {
    double width = 600,
    TargetDirection direction = TargetDirection.atMost,
  }) =>
      tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: Scaffold(
            body: SizedBox(
              width: width,
              child: ExpensePercentageRow(
                label: 'Credit cards',
                amount: r'$ 8.000.000',
                percentage: percentage,
                idealPercentage: ideal,
                direction: direction,
              ),
            ),
          ),
        ),
      );

  Color? barColor(WidgetTester tester) => tester
      .widget<LinearProgressIndicator>(
        find.descendant(
          of: find.byKey(ExpensePercentageRow.barKey),
          matching: find.byType(LinearProgressIndicator),
        ),
      )
      .color;

  Color? textColor(WidgetTester tester, String text) =>
      tester.widget<Text>(find.text(text)).style?.color;

  testWidgets('colors the share and the bar by the rule', (tester) async {
    final cases = {
      (12.5, 20.0): AppColors.success,
      (21.53, 20.0): AppColors.warning,
      (35.0, 20.0): AppColors.error,
      (42.67, null): AppColors.neutral,
    };
    for (final MapEntry(key: (actual, ideal), value: color) in cases.entries) {
      await pump(tester, actual, ideal);

      expect(barColor(tester), color, reason: '$actual vs $ideal');
    }
    expect(textColor(tester, '42,7 %'), AppColors.neutral);
  });

  testWidgets('shows the actual and ideal shares with one decimal',
      (tester) async {
    await pump(tester, 21.53, 20);

    expect(find.text('21,5 %'), findsOneWidget);
    expect(find.text('20,0 %'), findsOneWidget);
    expect(find.text('Credit cards'), findsOneWidget);
    expect(find.text(r'$ 8.000.000'), findsOneWidget);
  });

  testWidgets('colors a savings share below its floor ideal', (tester) async {
    await pump(tester, 9.5, 10, direction: TargetDirection.atLeast);
    expect(barColor(tester), AppColors.warning);

    await pump(tester, 0, 10, direction: TargetDirection.atLeast);
    expect(barColor(tester), AppColors.error);

    await pump(tester, 12, 10, direction: TargetDirection.atLeast);
    expect(barColor(tester), AppColors.success);
  });

  testWidgets('keeps shares of 1.000 % or more on one line', (tester) async {
    for (final width in [600.0, 311.0]) {
      await pump(tester, 25971.8, 20, width: width);

      final text = find.text('25.971,8\u00A0%');
      expect(text, findsOneWidget);
      final line = tester.getSize(find.text('20,0\u00A0%')).height;
      expect(tester.getSize(text).height, lessThanOrEqualTo(line));
      expect(
        tester.getRect(text).width,
        lessThanOrEqualTo(ExpensePercentageRow.percentWidth),
      );
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('shows a dash without an ideal', (tester) async {
    await pump(tester, 8.83, null);

    expect(find.text('—'), findsOneWidget);
  });

  testWidgets('fills the bar up to the share, capped at 100 %', (tester) async {
    await pump(tester, 42.67, null);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      closeTo(0.4267, 0.0001),
    );

    await pump(tester, 180, 10);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      1,
    );
  });

  testWidgets(
      'puts the bar between the shares when wide and below them '
      'when narrow', (tester) async {
    await pump(tester, 12.5, 20);
    final bar = tester.getRect(find.byKey(ExpensePercentageRow.barKey));
    final actual = tester.getRect(find.text('12,5 %'));
    final ideal = tester.getRect(find.text('20,0 %'));
    expect(bar.left, greaterThan(actual.right));
    expect(bar.right, lessThan(ideal.left));

    await pump(tester, 12.5, 20, width: 311);
    final narrowBar = tester.getRect(find.byKey(ExpensePercentageRow.barKey));
    expect(
      narrowBar.top,
      greaterThan(tester.getRect(find.text('12,5 %')).bottom),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('reads as one sentence to screen readers', (tester) async {
    final semantics = tester.ensureSemantics();
    await pump(tester, 21.53, 20);

    expect(
      find.bySemanticsLabel(
        'Credit cards, \$ 8.000.000, 21,5 % of income, '
        'ideal 20,0 %, slightly over target',
      ),
      findsOneWidget,
    );
    semantics.dispose();
  });
}
