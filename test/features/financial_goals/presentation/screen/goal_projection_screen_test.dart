import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/bloc/goal_projection_bloc.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goals_texts.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/screen/goal_projection_screen.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/screen/goals_screen.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_card.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_level_badge.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/projection_chart.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/projection_summary.dart';

import '../../../../helpers/goal_fixtures.dart';
import '../../../../helpers/goal_mocks.dart';
import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/net_worth_mocks.dart';
import '../../../../helpers/pump_app.dart';

class _MockProjectionBloc
    extends MockBloc<GoalProjectionEvent, GoalProjectionState>
    implements GoalProjectionBloc {}

final _projection = computedProjection(
  target: 605000000,
  current: netWorth,
  monthly: 1470000,
);

void main() {
  setUpAll(() {
    registerFallbackValue(const GoalProjectionRequested(''));
    return loadAppFonts();
  });

  Future<_MockProjectionBloc> pumpProjection(
    WidgetTester tester,
    GoalProjectionState state, {
    Size size = TestViewports.desktop,
  }) async {
    final bloc = registerBloc<GoalProjectionBloc, GoalProjectionState>(
      _MockProjectionBloc(),
      state,
    ) as _MockProjectionBloc;
    await tester.pumpApp(location: '/goals/g1/projection', size: size);
    return bloc;
  }

  testWidgets('loads the projection of the goal in the path', (tester) async {
    final bloc = await pumpProjection(tester, const GoalProjectionLoading());

    expect(find.byType(LoadingSkeleton), findsOneWidget);
    verify(() => bloc.add(const GoalProjectionRequested('g1'))).called(1);
  });

  for (final size in [TestViewports.mobile, TestViewports.desktop]) {
    testWidgets('shows the figures, chart and summary at ${size.width}',
        (tester) async {
      await pumpProjection(
        tester,
        GoalProjectionLoaded(_projection),
        size: size,
      );

      expect(find.text('Seguridad Financiera'), findsOneWidget);
      expect(find.byType(GoalLevelBadge), findsOneWidget);
      final mobile = size == TestViewports.mobile;
      expect(find.byType(StatCard), findsNWidgets(mobile ? 0 : 3));
      expect(
        find.byKey(GoalProjectionScreen.compactFiguresKey),
        mobile ? findsOneWidget : findsNothing,
      );
      expect(
        tester.getTopLeft(find.byType(ProjectionChart)).dy,
        lessThan(size.height / 2),
      );
      expect(find.text('May 2029'), findsOneWidget);
      expect(find.byType(ProjectionChart), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byType(ProjectionSummary),
        ProjectionChart.height,
        scrollable: find.byType(Scrollable).last,
      );
      expect(
        find.text(ProjectionSummary.textOf(_projection)),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('retries a projection that failed to load', (tester) async {
    final bloc =
        await pumpProjection(tester, const GoalProjectionFailure('Offline'));

    expect(find.text(GoalsTexts.projectionErrorTitle), findsOneWidget);
    await tester.tap(find.text(GoalsTexts.retry));

    verify(() => bloc.add(const GoalProjectionRequested('g1'))).called(2);
  });

  testWidgets('leads back to the goals when the goal does not exist',
      (tester) async {
    await pumpProjection(
      tester,
      const GoalProjectionFailure('Goal not found', notFound: true),
    );
    registerGoalsBloc(CrudLoaded(excelGoals));

    expect(find.text(GoalsTexts.goalNotFoundTitle), findsOneWidget);
    await tester.tap(find.text(GoalsTexts.backToGoals));
    await tester.pumpAndSettle();

    expect(find.byType(GoalsScreen), findsOneWidget);
  });

  testWidgets('goes back to the goals', (tester) async {
    await pumpProjection(tester, GoalProjectionLoaded(_projection));
    registerGoalsBloc(CrudLoaded(excelGoals));

    await tester.tap(find.byTooltip(GoalsTexts.backToGoals));
    await tester.pumpAndSettle();

    expect(find.byType(GoalsScreen), findsOneWidget);
  });

  testWidgets('opens from the See projection button of a goal card',
      (tester) async {
    registerGoalsBloc(CrudLoaded(excelGoals));
    final projections = _MockProjectionBloc();
    registerBloc<GoalProjectionBloc, GoalProjectionState>(
      projections,
      GoalProjectionLoaded(_projection),
    );
    await tester.pumpApp(location: '/goals');

    await tester.tap(
      find
          .descendant(
            of: find.byType(GoalCard).first,
            matching: find.byKey(GoalCard.seeProjectionKey),
          )
          .first,
    );
    await tester.pumpAndSettle();

    expect(find.byType(GoalProjectionScreen), findsOneWidget);
    verify(() => projections.add(const GoalProjectionRequested('g1')))
        .called(1);
  });
}
