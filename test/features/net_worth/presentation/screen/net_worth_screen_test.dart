import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_snapshot_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_summary_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/net_worth_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/net_worth_texts.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/screen/assets_screen.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/screen/net_worth_screen.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/widget/net_worth_chart.dart';

import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/net_worth_fixtures.dart';
import '../../../../helpers/net_worth_mocks.dart';
import '../../../../helpers/pump_app.dart';

NetWorthLoaded _loaded({
  NetWorthSummary current = currentSummary,
  List<NetWorthSnapshot>? history,
  bool creatingSnapshot = false,
}) =>
    NetWorthLoaded(
      current: current,
      history: history ?? [august, september],
      month: DateTime(2026, 10),
      creatingSnapshot: creatingSnapshot,
    );

StatCard _card(WidgetTester tester, String label) => tester
    .widgetList<StatCard>(find.byType(StatCard))
    .firstWhere((card) => card.label == label);

void main() {
  setUpAll(loadAppFonts);

  Future<MockNetWorthBloc> pumpOverview(
    WidgetTester tester,
    NetWorthState state, {
    Size size = TestViewports.mobile,
    Stream<NetWorthState> stream = const Stream.empty(),
    bool settle = true,
  }) async {
    final bloc = registerNetWorthBloc(state, stream: stream);
    await tester.pumpApp(
      location: AppRoute.netWorth.path,
      size: size,
      settle: settle,
    );
    await tester.pump();
    return bloc;
  }

  testWidgets('starts loading the overview when it opens', (tester) async {
    final bloc = await pumpOverview(tester, const NetWorthLoading());

    expect(find.byType(LoadingSkeleton), findsOneWidget);
    verify(() => bloc.add(const NetWorthLoadRequested())).called(1);
  });

  testWidgets('offers a retry when loading fails', (tester) async {
    final bloc = await pumpOverview(
      tester,
      const NetWorthLoadFailure('Offline'),
    );
    clearInteractions(bloc);

    await tester.tap(find.text(NetWorthTexts.retry));

    verify(() => bloc.add(const NetWorthLoadRequested())).called(1);
  });

  testWidgets('shows the totals and the change since last month',
      (tester) async {
    await pumpOverview(tester, _loaded());

    expect(_card(tester, NetWorthTexts.totalAssets).value, contains('185'));
    expect(
      _card(tester, NetWorthTexts.totalLiabilities).valueColor,
      AppColors.error,
    );
    final netWorth = _card(tester, NetWorthTexts.netWorth);
    expect(netWorth.valueColor, AppColors.success);
    expect(netWorth.delta?.isPositive, isTrue);
    expect(netWorth.delta?.text, startsWith(r'+$'));
    expect(netWorth.delta?.text, contains('2.450.000 vs Sep 2026'));
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows a negative net worth in red', (tester) async {
    await pumpOverview(
      tester,
      _loaded(
        current: const NetWorthSummary(
          totalAssets: Money.fromPesos(1000000),
          totalLiabilities: Money.fromPesos(4000000),
          netWorth: Money.fromPesos(-3000000),
        ),
      ),
    );

    final netWorth = _card(tester, NetWorthTexts.netWorth);
    expect(netWorth.valueColor, AppColors.error);
    expect(netWorth.delta?.isPositive, isFalse);
  });

  testWidgets('stacks the cards on mobile and lines them up on desktop',
      (tester) async {
    await pumpOverview(tester, _loaded());
    final mobile = tester.getTopLeft(find.byType(StatCard).at(1));
    final top = tester.getTopLeft(find.byType(StatCard).first);
    expect(mobile.dy, greaterThan(top.dy));

    await tester.binding.setSurfaceSize(TestViewports.desktop);
    tester.view.physicalSize = TestViewports.desktop;
    await tester.pumpAndSettle();

    final first = tester.getTopLeft(find.byType(StatCard).first);
    final second = tester.getTopLeft(find.byType(StatCard).at(1));
    expect(second.dy, first.dy);
    expect(second.dx, greaterThan(first.dx));
    expect(tester.takeException(), isNull);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('draws one point per snapshot with a gradient fill',
      (tester) async {
    await pumpOverview(tester, _loaded(), size: TestViewports.desktop);

    final chart = tester.widgetList<LineChart>(find.byType(LineChart)).last;
    final line = chart.data.lineBarsData.single;
    expect(line.spots, hasLength(2));
    expect(line.belowBarData.gradient, isA<LinearGradient>());
    expect(chart.data.lineTouchData.enabled, isTrue);
  });

  testWidgets('scrolls the chart horizontally for a long history',
      (tester) async {
    final history = [
      for (var month = 1; month <= 24; month++)
        snapshotOf(2025 + (month - 1) ~/ 12, (month - 1) % 12 + 1, month),
    ];
    await pumpOverview(tester, _loaded(history: history));

    final scrollable = find.descendant(
      of: find.byType(NetWorthChart),
      matching: find.byType(Scrollable),
    );
    final position = tester.state<ScrollableState>(scrollable).position;
    expect(position.maxScrollExtent, greaterThan(0));
    expect(position.pixels, 0);
  });

  testWidgets('fits six months on a narrow phone before scrolling',
      (tester) async {
    List<NetWorthSnapshot> months(int count) => [
          for (var month = 1; month <= count; month++)
            snapshotOf(2026, month, month * 1000000),
        ];
    ScrollPosition chartScroll() => tester
        .state<ScrollableState>(
          find.descendant(
            of: find.byType(NetWorthChart),
            matching: find.byType(Scrollable),
          ),
        )
        .position;

    await pumpOverview(
      tester,
      _loaded(history: months(6)),
      size: const Size(390, 844),
    );
    expect(chartScroll().maxScrollExtent, 0);
    expect(find.text("Jun '26"), findsOneWidget);
    expect(find.text("Apr '26"), findsOneWidget);
    expect(find.text("May '26"), findsNothing);
  });

  testWidgets('keeps the page heading and history heading for screen readers',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpOverview(tester, _loaded());

    expect(
      tester.getSemantics(
        find.descendant(
          of: find.byType(NetWorthScreen),
          matching: find.text(AppRoute.netWorth.title),
        ),
      ),
      matchesSemantics(label: AppRoute.netWorth.title, isHeader: true),
    );
    expect(
      tester.getSemantics(find.text(NetWorthTexts.history)),
      matchesSemantics(label: NetWorthTexts.history, isHeader: true),
    );
    semantics.dispose();
  });

  testWidgets('wraps the change so its month stays visible', (tester) async {
    await pumpOverview(tester, _loaded(), size: const Size(800, 900));

    final delta = find.textContaining('vs Sep 2026');
    expect(tester.widget<Text>(delta).maxLines, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('describes the chart to screen readers', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpOverview(tester, _loaded());

    expect(
      find.bySemanticsLabel(
        RegExp('^${NetWorthChart.semanticsPrefix}, 2 months from August 2026'),
      ),
      findsOneWidget,
    );
    semantics.dispose();
  });

  testWidgets('shows an empty history without snapshots', (tester) async {
    await pumpOverview(tester, _loaded(history: []));

    expect(find.text(NetWorthTexts.emptyHistoryTitle), findsOneWidget);
    expect(find.byType(LineChart), findsNothing);
    expect(_card(tester, NetWorthTexts.netWorth).delta, isNull);
  });

  testWidgets('creates a snapshot and confirms it', (tester) async {
    final states = StreamController<NetWorthState>();
    addTearDown(states.close);
    final bloc = await pumpOverview(tester, _loaded(), stream: states.stream);

    await tester.tap(find.byKey(NetWorthScreen.createSnapshotKey));
    verify(() => bloc.add(const NetWorthSnapshotRequested())).called(1);
    states
      ..add(_loaded(creatingSnapshot: true))
      ..add(_loaded());
    await tester.pumpAndSettle();

    expect(find.text('Snapshot saved for October 2026'), findsOneWidget);
  });

  testWidgets('reports a snapshot that could not be saved', (tester) async {
    final states = StreamController<NetWorthState>();
    addTearDown(states.close);
    await pumpOverview(tester, _loaded(), stream: states.stream);

    states
      ..add(_loaded(creatingSnapshot: true))
      ..add(_loaded().copyWith(errorMessage: 'Offline'));
    await tester.pumpAndSettle();

    expect(find.text('Offline'), findsOneWidget);
  });

  testWidgets('disables the snapshot button while saving', (tester) async {
    await pumpOverview(
      tester,
      _loaded(creatingSnapshot: true),
      settle: false,
    );

    final button = find.byKey(NetWorthScreen.createSnapshotKey);
    expect(tester.widget<ButtonStyleButton>(button).onPressed, isNull);
  });

  testWidgets('opens the assets screen', (tester) async {
    await pumpOverview(tester, _loaded());
    registerAssetBloc(const CrudLoaded([]));

    await tester.scrollUntilVisible(
      find.text(AppRoute.netWorthAssets.title),
      NetWorthChart.height,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text(AppRoute.netWorthAssets.title));
    await tester.pumpAndSettle();

    expect(find.byType(AssetsScreen), findsOneWidget);
  });
}
