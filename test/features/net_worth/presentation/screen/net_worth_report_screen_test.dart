import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/time/time_range.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_trend_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/net_worth_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/net_worth_report_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/net_worth_texts.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/screen/net_worth_report_screen.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/widget/full_history_chart.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/widget/net_worth_report_table.dart';

import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/net_worth_fixtures.dart';
import '../../../../helpers/net_worth_mocks.dart';
import '../../../../helpers/pump_app.dart';

NetWorthReportState _loaded(
  NetWorthTrend trend, {
  TimeRange range = TimeRange.oneYear,
}) =>
    NetWorthReportState(
      range: range,
      status: ReportStatus.loaded,
      trend: trend,
    );

StatCard _card(WidgetTester tester, String labelStart) => tester
    .widgetList<StatCard>(find.byType(StatCard))
    .firstWhere((card) => card.label.startsWith(labelStart));

String _location(WidgetTester tester) => GoRouter.of(
      tester.element(find.byType(Scaffold).first),
    ).routeInformationProvider.value.uri.path;

void main() {
  setUpAll(loadAppFonts);

  Future<MockNetWorthReportBloc> pumpReport(
    WidgetTester tester,
    NetWorthReportState state, {
    Size size = TestViewports.mobile,
  }) async {
    final bloc = registerNetWorthReportBloc(state);
    await tester.pumpApp(
      location: AppRoute.netWorthReport.path,
      size: size,
      settle: false,
    );
    await tester.pump(const Duration(seconds: 1));
    return bloc;
  }

  Future<void> reveal(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find
          .descendant(
            of: find.byType(NetWorthReportScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pump();
  }

  testWidgets('starts loading the last year when it opens', (tester) async {
    final bloc = await pumpReport(tester, const NetWorthReportState());

    expect(find.byType(LoadingSkeleton), findsOneWidget);
    verify(() => bloc.add(const NetWorthReportLoadRequested())).called(1);
  });

  testWidgets('switches to the range picked in the selector', (tester) async {
    final bloc = await pumpReport(tester, _loaded(threeMonthTrend));

    await tester.tap(find.text(TimeRange.sixMonths.label));
    await tester.pump();

    verify(
      () => bloc.add(const NetWorthReportRangeChanged(TimeRange.sixMonths)),
    ).called(1);
  });

  testWidgets('offers a retry when loading fails', (tester) async {
    final bloc = await pumpReport(
      tester,
      const NetWorthReportState(status: ReportStatus.failure, error: 'Offline'),
    );
    clearInteractions(bloc);

    expect(find.text('Offline'), findsOneWidget);
    await tester.tap(find.byKey(NetWorthReportScreen.retryKey));

    verify(() => bloc.add(const NetWorthReportLoadRequested())).called(1);
  });

  testWidgets('links an empty range to the net worth screen', (tester) async {
    await pumpReport(tester, _loaded(const NetWorthTrend([])));
    registerNetWorthBloc(const NetWorthLoading());

    expect(find.text(NetWorthTexts.reportEmptyTitle), findsOneWidget);
    await tester.tap(find.byKey(NetWorthReportScreen.recordSnapshotKey));
    await tester.pump(const Duration(seconds: 1));

    expect(_location(tester), AppRoute.netWorth.path);
  });

  testWidgets('goes back to the net worth screen', (tester) async {
    await pumpReport(tester, _loaded(threeMonthTrend));
    registerNetWorthBloc(const NetWorthLoading());

    await tester.tap(find.byTooltip(NetWorthTexts.backToNetWorth));
    await tester.pump(const Duration(seconds: 1));

    expect(_location(tester), AppRoute.netWorth.path);
  });

  group('summary', () {
    testWidgets('shows the latest month and its change', (tester) async {
      await pumpReport(tester, _loaded(threeMonthTrend));

      final latest = _card(tester, NetWorthTexts.latestNetWorth);
      expect(
        latest.value,
        CurrencyFormatter.format(const Money.fromPesos(130000000)),
      );
      expect(latest.delta?.isPositive, isFalse);
      expect(latest.delta?.text, endsWith('vs Sep 2026'));
    });

    testWidgets('names the best month in gold', (tester) async {
      await pumpReport(tester, _loaded(threeMonthTrend));

      final best = _card(tester, NetWorthTexts.bestMonth);
      expect(best.label, endsWith('Sep 2026'));
      expect(
        best.value,
        CurrencyFormatter.format(const Money.fromPesos(160000000)),
      );
      expect(best.valueColor, AppColors.accentGold);
    });

    testWidgets('shows the change over the range with its percentage',
        (tester) async {
      await pumpReport(tester, _loaded(threeMonthTrend));

      final change = _card(tester, NetWorthTexts.changeSinceStart);
      expect(
        change.value,
        CurrencyFormatter.formatSigned(const Money.fromPesos(30000000)),
      );
      expect(change.valueColor, AppColors.success);
      expect(
        change.delta?.text,
        '+${PercentFormatter.format(30)} '
        '${NetWorthTexts.sinceStartPrefix} Aug 2026',
      );
    });

    testWidgets('leaves out the percentage of a range that started at zero',
        (tester) async {
      final trend = NetWorthTrend([
        trendPointOf(9, assets: 0, liabilities: 0),
        trendPointOf(10, assets: 0, liabilities: 500, delta: -500),
      ]);
      await pumpReport(tester, _loaded(trend));

      final change = _card(tester, NetWorthTexts.changeSinceStart);
      expect(change.valueColor, AppColors.error);
      expect(change.delta?.text, '${NetWorthTexts.sinceStartPrefix} Sep 2026');
    });

    testWidgets('has no month-over-month change for a single month',
        (tester) async {
      final trend = NetWorthTrend([
        trendPointOf(10, assets: 100, liabilities: 0),
      ]);
      await pumpReport(tester, _loaded(trend));

      expect(_card(tester, NetWorthTexts.latestNetWorth).delta, isNull);
    });
  });

  group('chart', () {
    testWidgets('draws the assets and liabilities areas under the net worth',
        (tester) async {
      await pumpReport(tester, _loaded(threeMonthTrend));

      final chart = tester.widget<LineChart>(
        find.descendant(
          of: find.byType(FullHistoryChart),
          matching: find.byType(LineChart),
        ),
      );
      final [assets, liabilities, netWorth] = chart.data.lineBarsData;
      expect(assets.color, FullHistoryChart.assetsColor);
      expect(assets.belowBarData.show, isTrue);
      expect(liabilities.color, FullHistoryChart.liabilitiesColor);
      expect(netWorth.color, FullHistoryChart.netWorthColor);
      expect(netWorth.spots.map((spot) => spot.y), [100e6, 160e6, 130e6]);
      final showDot = netWorth.dotData.checkToShowDot;
      expect(showDot(netWorth.spots[1], netWorth), isTrue);
      expect(showDot(netWorth.spots[2], netWorth), isFalse);
    });

    testWidgets('describes the chart to screen readers', (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpReport(tester, _loaded(threeMonthTrend));

      expect(
        find.bySemanticsLabel(
          RegExp(
            '^${NetWorthTexts.reportChartLabel}, 3 months from August 2026 '
            'to October 2026',
          ),
        ),
        findsOneWidget,
      );
      semantics.dispose();
    });

    testWidgets('keeps the last month label inside the chart', (tester) async {
      await pumpReport(
        tester,
        _loaded(threeMonthTrend),
        size: const Size(390, 844),
      );

      final chart = tester.getRect(find.byType(FullHistoryChart));
      final last = tester.getRect(find.text("Oct '26"));
      expect(last.right, lessThanOrEqualTo(chart.right));
    });

    test('thins out the month labels of a long range', () {
      final points = [
        for (var month = 0; month < 36; month++)
          trendPointOf(month + 1, assets: month, liabilities: 0),
      ];
      final scale = FullHistoryChart(trend: NetWorthTrend(points)).scale;

      expect(FullHistoryChart.labelStep(scale, 390), greaterThan(1));
      expect(FullHistoryChart.labelStep(scale, 4000), 1);
    });
  });

  group('table', () {
    test('colors the change, with a dash for the first month', () {
      expect(NetWorthReportTable.deltaCell(null).text, NetWorthTexts.noDelta);
      expect(
        NetWorthReportTable.deltaCell(const Money.fromPesos(5)).color,
        AppColors.success,
      );
      expect(
        NetWorthReportTable.deltaCell(const Money.fromPesos(-5)).color,
        AppColors.error,
      );
      expect(NetWorthReportTable.deltaCell(Money.zero).color, isNull);
    });

    testWidgets('lists the months newest first with the best one marked',
        (tester) async {
      await pumpReport(
        tester,
        _loaded(threeMonthTrend),
        size: TestViewports.desktop,
      );
      await reveal(tester, find.byType(DataTable));

      final table = tester.widget<DataTable>(find.byType(DataTable));
      expect(table.columns, hasLength(NetWorthReportTable.columns.length));
      expect(table.rows, hasLength(3));
      expect(table.rows.map((row) => row.color), [
        null,
        isNotNull,
        null,
      ]);
      expect(find.text(NetWorthTexts.best.toUpperCase()), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Oct 2026')).dy,
        lessThan(tester.getTopLeft(find.text('Aug 2026')).dy),
      );
    });

    testWidgets('shows one card per month on mobile', (tester) async {
      await pumpReport(tester, _loaded(threeMonthTrend));
      await reveal(tester, find.text('Aug 2026'));

      expect(find.byType(DataTable), findsNothing);
      expect(find.text(NetWorthTexts.noDelta), findsOneWidget);
      expect(find.text(NetWorthTexts.best.toUpperCase()), findsOneWidget);
    });
  });

  for (final size in TestViewports.expenseWidths) {
    testWidgets('fits a long report at ${size.width.toInt()} px',
        (tester) async {
      final points = [
        for (var month = 1; month <= 12; month++)
          trendPointOf(
            month,
            assets: 1850000000 + month * 1000000,
            liabilities: 120000000,
            delta: month == 1 ? null : -1000000,
          ),
      ];
      await pumpReport(tester, _loaded(NetWorthTrend(points)), size: size);
      expect(tester.takeException(), isNull);

      await reveal(tester, find.text('Jan 2026'));

      expect(tester.takeException(), isNull);
      final delta = find.text(
        CurrencyFormatter.formatSigned(const Money.fromPesos(-1000000)),
      );
      expect(tester.getRect(delta.first).right, lessThanOrEqualTo(size.width));
    });
  }
}
