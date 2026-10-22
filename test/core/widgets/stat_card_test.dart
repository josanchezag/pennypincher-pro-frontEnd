import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_theme.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';

Future<void> _pump(WidgetTester tester, StatCard card) => tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(body: SizedBox(width: 320, child: card)),
      ),
    );

void main() {
  testWidgets('shows the label, value and a positive delta', (tester) async {
    final semantics = tester.ensureSemantics();
    await _pump(
      tester,
      const StatCard(
        label: 'Net worth',
        value: r'$ 173.000.000',
        icon: Icons.savings_outlined,
        delta: StatDelta(text: r'+$ 2.450.000 vs Sep 2026', isPositive: true),
      ),
    );

    expect(find.text('NET WORTH'), findsOneWidget);
    expect(find.text(r'$ 173.000.000'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        r'Net worth, $ 173.000.000, +$ 2.450.000 vs Sep 2026',
      ),
      findsOneWidget,
    );
    semantics.dispose();
  });

  testWidgets('colors the value and a negative delta', (tester) async {
    await _pump(
      tester,
      const StatCard(
        label: 'Total liabilities',
        value: r'$ 9.000.000',
        valueColor: AppColors.error,
        delta: StatDelta(text: r'-$ 1', isPositive: false),
      ),
    );

    final value = tester.widget<Text>(find.text(r'$ 9.000.000'));
    expect(value.style?.color, AppColors.error);
    expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
  });
}
