import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/widgets/month_selector.dart';

import '../../helpers/l10n.dart';

void main() {
  late List<DateTime> changes;

  setUp(() => changes = []);

  Future<void> pump(
    WidgetTester tester,
    DateTime month, {
    DateTime? first,
    DateTime? last,
    bool enabled = true,
    Locale locale = testLocale,
  }) =>
      tester.pumpWidget(
        localizedApp(
          locale: locale,
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
    expect(find.byTooltip(l10n.monthPrevious), findsOneWidget);
    expect(find.byTooltip(l10n.monthNext), findsOneWidget);
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

  group('in Spanish', () {
    setUp(() => Intl.defaultLocale = 'es');
    tearDown(() => Intl.defaultLocale = testLocale.languageCode);

    testWidgets('names the month in Spanish', (tester) async {
      await pump(tester, DateTime(2026, 10), locale: AppLocales.spanish);

      expect(find.text('Octubre 2026'), findsOneWidget);
      expect(find.byTooltip(l10nEs.monthPrevious), findsOneWidget);
      expect(find.byTooltip(l10nEs.monthNext), findsOneWidget);
    });

    testWidgets('keeps the arrows in place for every month name',
        (tester) async {
      await pump(tester, DateTime(2026, 5), locale: AppLocales.spanish);
      final mayNext = tester.getCenter(find.byKey(MonthSelector.nextKey));
      await pump(tester, DateTime(2026, 9), locale: AppLocales.spanish);

      expect(find.text('Septiembre 2026'), findsOneWidget);
      expect(tester.getCenter(find.byKey(MonthSelector.nextKey)), mayNext);
      expect(tester.takeException(), isNull);
    });
  });
}
