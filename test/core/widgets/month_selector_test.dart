import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/theme/app_theme.dart';
import 'package:pennypincher_pro/core/widgets/month_selector.dart';

void main() {
  late List<DateTime> changes;

  setUp(() => changes = []);

  Future<void> pump(
    WidgetTester tester,
    DateTime month, {
    DateTime? first,
    DateTime? last,
    bool enabled = true,
  }) =>
      tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: Scaffold(
            body: Center(
              child: MonthSelector(
                month: month,
                first: first,
                last: last,
                enabled: enabled,
                onChanged: changes.add,
              ),
            ),
          ),
        ),
      );

  IconButton button(WidgetTester tester, Key key) =>
      tester.widget<IconButton>(find.byKey(key));

  testWidgets('shows the month and year', (tester) async {
    await pump(tester, DateTime(2026, 10, 22));

    expect(find.text('October 2026'), findsOneWidget);
    expect(find.byTooltip(MonthSelector.previousTooltip), findsOneWidget);
    expect(find.byTooltip(MonthSelector.nextTooltip), findsOneWidget);
  });

  testWidgets('moves one month back and forward across years', (tester) async {
    await pump(tester, DateTime(2026, 12));
    await tester.tap(find.byKey(MonthSelector.nextKey));
    await pump(tester, DateTime(2026));
    await tester.tap(find.byKey(MonthSelector.previousKey));

    expect(changes, [DateTime(2027), DateTime(2025, 12)]);
  });

  testWidgets('stops at the first and last months', (tester) async {
    await pump(
      tester,
      DateTime(2000),
      first: DateTime(2000),
      last: DateTime(2000, 2),
    );
    expect(button(tester, MonthSelector.previousKey).onPressed, isNull);
    expect(button(tester, MonthSelector.nextKey).onPressed, isNotNull);

    await pump(
      tester,
      DateTime(2000, 2, 15),
      first: DateTime(2000),
      last: DateTime(2000, 2),
    );
    expect(button(tester, MonthSelector.previousKey).onPressed, isNotNull);
    expect(button(tester, MonthSelector.nextKey).onPressed, isNull);
  });

  testWidgets('disables both arrows while disabled', (tester) async {
    await pump(tester, DateTime(2026, 10), enabled: false);

    expect(button(tester, MonthSelector.previousKey).onPressed, isNull);
    expect(button(tester, MonthSelector.nextKey).onPressed, isNull);
  });

  testWidgets('keeps the arrows in place for every month name', (tester) async {
    await pump(tester, DateTime(2026, 5));
    final mayNext = tester.getCenter(find.byKey(MonthSelector.nextKey));
    await pump(tester, DateTime(2026, 9));

    expect(tester.getCenter(find.byKey(MonthSelector.nextKey)), mayNext);
    expect(tester.takeException(), isNull);
  });
}
