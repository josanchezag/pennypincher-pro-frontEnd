import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/budget_comparison_bloc.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/monthly_budget_bloc.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/dashboard_summary_entity.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/part_of_day.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/dashboard_texts.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/budget_summary_card.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/dashboard_content.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/dashboard_header.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/dashboard_skeleton.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/goal_progress_chip.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/goals_section.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/mini_sparkline.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/net_worth_summary_card.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/quick_actions_row.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/expenses_hub_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/net_worth_report_bloc.dart';

import '../../../../helpers/budget_mocks.dart';
import '../../../../helpers/dashboard_fixtures.dart';
import '../../../../helpers/dashboard_mocks.dart';
import '../../../../helpers/expense_mocks.dart';
import '../../../../helpers/goal_mocks.dart';
import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/net_worth_mocks.dart';
import '../../../../helpers/pump_app.dart';

const Size _phone = Size(390, 844);

String _location(WidgetTester tester) => GoRouter.of(
      tester.element(find.byType(Scaffold).first),
    ).routeInformationProvider.value.uri.path;

void main() {
  setUpAll(loadAppFonts);

  Future<MockDashboardBloc> pumpDashboard(
    WidgetTester tester,
    DashboardState state, {
    Size size = _phone,
    Stream<DashboardState> stream = const Stream.empty(),
    bool settle = true,
  }) async {
    if (getIt.isRegistered<DashboardBloc>()) {
      await getIt.unregister<DashboardBloc>();
    }
    final bloc = registerDashboardBloc(state, stream: stream);
    await tester.pumpApp(
      location: AppRoute.dashboard.path,
      size: size,
      settle: settle,
    );
    await tester.pump();
    return bloc;
  }

  Future<void> reveal(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      AppSpacing.xxl,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(finder);
    await tester.pump();
  }

  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await reveal(tester, finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('starts loading with skeletons when it opens', (tester) async {
    final bloc = await pumpDashboard(
      tester,
      const DashboardState(period: PartOfDay.morning),
    );

    expect(find.byType(DashboardSkeleton), findsOneWidget);
    verify(() => bloc.add(const DashboardLoadRequested())).called(1);
  });

  testWidgets('offers a retry when loading fails', (tester) async {
    final bloc = await pumpDashboard(
      tester,
      const DashboardState(
        period: PartOfDay.morning,
        status: DashboardStatus.failure,
        loadError: 'Offline',
      ),
    );
    clearInteractions(bloc);

    expect(find.text(DashboardTexts.loadErrorTitle), findsOneWidget);
    await tester.tap(find.text(DashboardTexts.retry));

    verify(() => bloc.add(const DashboardLoadRequested())).called(1);
  });

  for (final size in TestViewports.expenseWidths) {
    testWidgets('fits every section at ${size.width.toInt()} px',
        (tester) async {
      await pumpDashboard(
        tester,
        loadedDashboard(dashboardSummary.copyWith(goals: fourGoals)),
        size: size,
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(NetWorthSummaryCard), findsOneWidget);
      expect(find.byType(BudgetSummaryCard), findsOneWidget);
      expect(find.byType(GoalsSection), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byType(QuickActionsRow),
        AppSpacing.xxl,
        scrollable: find.byType(Scrollable).first,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('fits the skeleton and onboarding at ${size.width.toInt()} px',
        (tester) async {
      await pumpDashboard(
        tester,
        const DashboardState(period: PartOfDay.evening),
        size: size,
      );
      expect(tester.takeException(), isNull);

      await pumpDashboard(tester, loadedDashboard(newUserSummary), size: size);
      expect(find.byKey(DashboardContent.onboardingKey), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('puts net worth next to the budget on desktop only',
      (tester) async {
    await pumpDashboard(
      tester,
      loadedDashboard(dashboardSummary),
      size: TestViewports.desktop,
    );
    final netWorth = tester.getTopLeft(find.byType(NetWorthSummaryCard));
    final budget = tester.getTopLeft(find.byType(BudgetSummaryCard));
    expect(budget.dy, netWorth.dy);
    expect(budget.dx, greaterThan(netWorth.dx));

    await pumpDashboard(tester, loadedDashboard(dashboardSummary));
    expect(
      tester.getTopLeft(find.byType(BudgetSummaryCard)).dy,
      greaterThan(tester.getTopLeft(find.byType(NetWorthSummaryCard)).dy),
    );
  });

  group('header', () {
    final greetings = {
      PartOfDay.morning: 'Good morning, Josimar',
      PartOfDay.afternoon: 'Good afternoon, Josimar',
      PartOfDay.evening: 'Good evening, Josimar',
    };
    for (final MapEntry(key: period, value: text) in greetings.entries) {
      testWidgets('greets "$text"', (tester) async {
        await pumpDashboard(
          tester,
          loadedDashboard(dashboardSummary, period: period),
        );

        expect(find.text(text), findsOneWidget);
        expect(
          find.text('${DashboardTexts.overviewPrefix} October 2026'),
          findsOneWidget,
        );
      });
    }

    testWidgets('greets without a name when the profile has none',
        (tester) async {
      await pumpDashboard(
        tester,
        loadedDashboard(
          dashboardSummary.copyWith(user: const UserProfile(name: ' ')),
        ),
      );

      expect(find.text('Good morning'), findsOneWidget);
    });

    testWidgets('shows the initials when there is no picture or it fails',
        (tester) async {
      await pumpDashboard(tester, loadedDashboard(dashboardSummary));
      expect(find.text('JS'), findsOneWidget);
      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.foregroundImage, isA<NetworkImage>());
      expect(avatar.onForegroundImageError, isNotNull);

      await pumpDashboard(tester, loadedDashboard(newUserSummary));
      expect(find.text('A'), findsOneWidget);
      expect(
        tester.widget<CircleAvatar>(find.byType(CircleAvatar)).foregroundImage,
        isNull,
      );
    });

    testWidgets('refreshes from the button and disables it while busy',
        (tester) async {
      final bloc =
          await pumpDashboard(tester, loadedDashboard(dashboardSummary));

      await tester.tap(find.byKey(DashboardHeader.refreshKey));
      verify(() => bloc.add(const DashboardRefreshRequested())).called(1);

      await pumpDashboard(
        tester,
        loadedDashboard(dashboardSummary, refreshing: true),
        settle: false,
      );
      expect(
        tester
            .widget<IconButton>(find.byKey(DashboardHeader.refreshKey))
            .onPressed,
        isNull,
      );
    });

    testWidgets('refreshes when pulled down until the reload ends',
        (tester) async {
      final states = StreamController<DashboardState>();
      addTearDown(states.close);
      final bloc = await pumpDashboard(
        tester,
        loadedDashboard(dashboardSummary),
        stream: states.stream,
      );

      await tester.fling(
        find.byType(DashboardHeader),
        const Offset(0, AppSpacing.xxxl * 4),
        AppSpacing.xxxl * 16,
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      verify(() => bloc.add(const DashboardRefreshRequested())).called(1);
      expect(find.byType(RefreshProgressIndicator), findsOneWidget);

      states
        ..add(loadedDashboard(dashboardSummary, refreshing: true))
        ..add(loadedDashboard(dashboardSummary));
      await tester.pumpAndSettle();
      expect(find.byType(RefreshProgressIndicator), findsNothing);
    });
  });

  group('net worth', () {
    testWidgets('shows the change since the previous snapshot in green',
        (tester) async {
      await pumpDashboard(tester, loadedDashboard(dashboardSummary));

      final line = tester.widget<StatDeltaLine>(find.byType(StatDeltaLine));
      expect(line.delta.isPositive, isTrue);
      expect(
        line.delta.text,
        endsWith('5.282.773 (+${PercentFormatter.format(1.26)}) vs Sep 2026'),
      );
      expect(line.delta.text, startsWith(r'+$'));
      expect(find.byType(MiniSparkline), findsOneWidget);
      expect(find.textContaining('707.363.354'), findsOneWidget);
      expect(find.textContaining('284.080.581'), findsOneWidget);
    });

    testWidgets('shows a loss in red, without a percentage after zero',
        (tester) async {
      final change = NetWorthChange(
        previous: Money.zero,
        previousDate: DateTime(2026, 9),
        delta: const Money.fromPesos(-300000),
      );
      await pumpDashboard(
        tester,
        loadedDashboard(
          dashboardSummary.copyWith(
            netWorth: dashboardSummary.netWorth.copyWith(change: change),
          ),
        ),
      );

      final line = tester.widget<StatDeltaLine>(find.byType(StatDeltaLine));
      expect(line.delta.isPositive, isFalse);
      expect(
        line.delta.text,
        '${CurrencyFormatter.formatSigned(const Money.fromPesos(-300000))} '
        'vs Sep 2026',
      );
    });

    testWidgets('explains a missing previous snapshot and a short history',
        (tester) async {
      await pumpDashboard(
        tester,
        loadedDashboard(
          dashboardSummary.copyWith(
            netWorth: dashboardSummary.netWorth.copyWith(change: null),
            recentSnapshots: dashboardSummary.recentSnapshots.sublist(1),
          ),
        ),
      );

      expect(find.text(DashboardTexts.noPreviousSnapshot), findsOneWidget);
      expect(find.text(DashboardTexts.sparklineHint), findsOneWidget);
      expect(find.byType(MiniSparkline), findsNothing);
    });

    testWidgets('draws the sparkline red when the trend goes down',
        (tester) async {
      await pumpDashboard(
        tester,
        loadedDashboard(
          dashboardSummary.copyWith(
            recentSnapshots: [
              NetWorthPoint(
                date: DateTime(2026, 8),
                netWorth: const Money.fromPesos(418000000),
              ),
              NetWorthPoint(
                date: DateTime(2026, 9),
                netWorth: const Money.fromPesos(410000000),
              ),
            ],
          ),
        ),
      );

      final chart = tester.widget<LineChart>(find.byType(LineChart));
      expect(chart.data.lineBarsData.single.color, AppColors.chartLineNegative);
      expect(chart.data.lineTouchData.enabled, isFalse);
    });
  });

  group('budget', () {
    testWidgets('shows income, expenses and the cash flow share',
        (tester) async {
      await pumpDashboard(tester, loadedDashboard(dashboardSummary));

      expect(find.textContaining('37.152.922'), findsOneWidget);
      expect(find.textContaining('19.135.201'), findsOneWidget);
      final cashFlow = tester.widget<Text>(find.textContaining('18.017.721'));
      expect(cashFlow.style?.color, AppColors.success);
      expect(
        find.text(
          '${PercentFormatter.format(dashboardSummary.budget.figures!.cashFlowPercentage)} ${DashboardTexts.ofIncome}',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows a negative cash flow in red', (tester) async {
      await pumpDashboard(
        tester,
        loadedDashboard(
          dashboardSummary.copyWith(
            budget: MonthBudgetOverview(
              month: DateTime(2026, 10),
              figures: const BudgetFigures(
                totalIncome: Money.fromPesos(1000000),
                totalExpenses: Money.fromPesos(1500000),
                monthlyCashFlow: Money.fromPesos(-500000),
                cashFlowPercentage: -50,
              ),
            ),
          ),
        ),
      );

      final cashFlow = tester.widget<Text>(
        find.text(CurrencyFormatter.format(const Money.fromPesos(-500000))),
      );
      expect(cashFlow.style?.color, AppColors.error);
    });

    testWidgets('leads to the budget overview when there is no budget',
        (tester) async {
      await pumpDashboard(
        tester,
        loadedDashboard(
          dashboardSummary.copyWith(
            budget: MonthBudgetOverview(month: DateTime(2026, 10)),
          ),
        ),
      );

      registerMonthlyBudgetBloc(MonthlyBudgetState(month: DateTime(2026, 10)));
      await tapAndSettle(tester, find.text(DashboardTexts.createBudgetTitle));

      expect(_location(tester), AppRoute.budgetOverview.path);
    });
  });

  group('goals', () {
    testWidgets('scrolls the chips horizontally on mobile', (tester) async {
      await pumpDashboard(
        tester,
        loadedDashboard(dashboardSummary.copyWith(goals: fourGoals)),
      );

      final list = tester.widget<ListView>(find.byKey(GoalsSection.listKey));
      expect(list.scrollDirection, Axis.horizontal);
      expect(find.text(PercentFormatter.format(69.9)), findsOneWidget);
    });

    testWidgets('lines up four chips per row on desktop', (tester) async {
      await pumpDashboard(
        tester,
        loadedDashboard(dashboardSummary.copyWith(goals: fourGoals)),
        size: TestViewports.desktop,
      );

      final chips = find.byType(GoalProgressChip);
      expect(chips, findsNWidgets(fourGoals.length));
      final first = tester.getTopLeft(chips.first);
      expect(tester.getTopLeft(chips.last).dy, first.dy);
      expect(find.byKey(GoalsSection.listKey), findsNothing);
    });

    for (final size in [TestViewports.tablet, TestViewports.desktop]) {
      testWidgets('gives every chip the same height at ${size.width} px',
          (tester) async {
        await pumpDashboard(
          tester,
          loadedDashboard(dashboardSummary.copyWith(goals: fourGoals)),
          size: size,
        );

        final heights = tester
            .widgetList<GoalProgressChip>(find.byType(GoalProgressChip))
            .map((chip) => tester.getSize(find.byWidget(chip)).height)
            .toSet();
        expect(heights, hasLength(1));
      });
    }

    testWidgets('opens the goals from a chip', (tester) async {
      await pumpDashboard(tester, loadedDashboard(dashboardSummary));

      registerGoalsBloc(const CrudLoaded([]));
      await tapAndSettle(tester, find.byType(GoalProgressChip));

      expect(_location(tester), AppRoute.goals.path);
    });

    testWidgets('suggests the first goal when there are none', (tester) async {
      await pumpDashboard(
        tester,
        loadedDashboard(dashboardSummary.copyWith(goals: const [])),
      );

      registerGoalsBloc(const CrudLoaded([]));
      await tapAndSettle(tester, find.text(DashboardTexts.firstGoalTitle));

      expect(_location(tester), AppRoute.goals.path);
    });
  });

  group('quick actions', () {
    testWidgets('records the snapshot of the month', (tester) async {
      final bloc =
          await pumpDashboard(tester, loadedDashboard(dashboardSummary));

      await tapAndSettle(tester, find.byKey(QuickActionsRow.recordSnapshotKey));

      verify(() => bloc.add(const DashboardSnapshotRequested())).called(1);
    });

    testWidgets('disables the snapshot while one is being saved',
        (tester) async {
      final bloc = await pumpDashboard(
        tester,
        loadedDashboard(dashboardSummary, recordingSnapshot: true),
        settle: false,
      );

      await reveal(tester, find.byKey(QuickActionsRow.recordSnapshotKey));
      await tester.tap(find.byKey(QuickActionsRow.recordSnapshotKey));
      await tester.pump();

      verifyNever(() => bloc.add(const DashboardSnapshotRequested()));
    });

    final links = {
      DashboardTexts.addExpense: AppRoute.expenses,
      DashboardTexts.netWorthReport: AppRoute.netWorthReport,
      DashboardTexts.budgetComparison: AppRoute.budgetComparison,
    };
    for (final MapEntry(key: label, value: route) in links.entries) {
      testWidgets('"$label" opens ${route.path}', (tester) async {
        registerExpensesHubBloc(const ExpensesHubState());
        registerNetWorthReportBloc(const NetWorthReportState());
        registerBudgetComparisonBloc(const BudgetComparisonState());
        await pumpDashboard(tester, loadedDashboard(dashboardSummary));

        await tapAndSettle(tester, find.text(label));

        expect(_location(tester), route.path);
      });
    }
  });

  group('onboarding', () {
    testWidgets('replaces the cards and goals for a user without data',
        (tester) async {
      await pumpDashboard(tester, loadedDashboard(newUserSummary));

      expect(find.byType(NetWorthSummaryCard), findsNothing);
      expect(find.byType(BudgetSummaryCard), findsNothing);
      expect(find.byType(GoalsSection), findsNothing);
      expect(find.byType(QuickActionsRow), findsOneWidget);

      registerAssetBloc(const CrudLoaded([]));
      await tapAndSettle(tester, find.text(DashboardTexts.onboardingTitle));
      expect(_location(tester), AppRoute.netWorthAssets.path);
    });
  });

  group('notices', () {
    Future<void> notify(WidgetTester tester, DashboardState notice) async {
      final states = StreamController<DashboardState>();
      addTearDown(states.close);
      await pumpDashboard(
        tester,
        loadedDashboard(dashboardSummary, recordingSnapshot: true),
        stream: states.stream,
        settle: false,
      );
      states.add(notice);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    }

    testWidgets('confirms a saved snapshot', (tester) async {
      await notify(
        tester,
        loadedDashboard(
          dashboardSummary,
          notice: DashboardNotice.snapshotSaved,
        ),
      );

      expect(
        find.text('${DashboardTexts.snapshotSavedPrefix} October 2026'),
        findsOneWidget,
      );
    });

    testWidgets('reports a failed snapshot or refresh', (tester) async {
      await notify(
        tester,
        loadedDashboard(
          dashboardSummary,
          notice: DashboardNotice.snapshotFailed,
          noticeMessage: 'Offline',
        ),
      );
      expect(find.text('Offline'), findsOneWidget);

      await notify(
        tester,
        loadedDashboard(
          dashboardSummary,
          notice: DashboardNotice.refreshFailed,
          noticeMessage: 'Offline',
        ),
      );
      expect(
        find.text('${DashboardTexts.refreshFailedPrefix} Offline'),
        findsOneWidget,
      );
    });
  });
}
