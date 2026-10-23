import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_sheet.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/confirmation_dialog.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goals_texts.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/screen/goals_screen.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_card.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goals_empty_state.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/halfway_celebration.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/projections_notice.dart';

import '../../../../helpers/crud_screen_helpers.dart';
import '../../../../helpers/goal_fixtures.dart';
import '../../../../helpers/goal_mocks.dart';
import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/pump_app.dart';

typedef _State = CrudState<FinancialGoal>;

final CrudLoaded<FinancialGoal> _loaded = CrudLoaded(excelGoals);

Finder _card(String name) =>
    find.ancestor(of: find.text(name), matching: find.byType(GoalCard));

void main() {
  setUpAll(() {
    registerFallbackValue(const CrudLoadRequested<GoalDraft>());
    return loadAppFonts();
  });

  Future<MockGoalsBloc> pumpGoals(
    WidgetTester tester,
    _State state, {
    Size size = TestViewports.desktop,
    Stream<_State> stream = const Stream.empty(),
    bool settle = true,
  }) async {
    final bloc = registerGoalsBloc(state, stream: stream);
    await tester.pumpApp(
      location: AppRoute.goals.path,
      size: size,
      settle: settle,
    );
    return bloc;
  }

  Future<void> openAddSheet(WidgetTester tester) async {
    await tester.tap(find.byKey(GoalsScreen.addButtonKey));
    await tester.pumpAndSettle();
  }

  Future<void> chooseLevel(WidgetTester tester, String label) async {
    await tester.tap(find.text(GoalsTexts.level));
    await tester.pumpAndSettle();
    await tester.tap(find.text(label).last);
    await tester.pumpAndSettle();
  }

  testWidgets('starts loading the goals when it opens', (tester) async {
    final bloc = await pumpGoals(tester, const CrudLoading());

    expect(find.byType(LoadingSkeleton), findsOneWidget);
    expect(find.byKey(GoalsScreen.addButtonKey), findsNothing);
    verify(() => bloc.add(const CrudLoadRequested<GoalDraft>())).called(1);
  });

  testWidgets('retries a load that failed', (tester) async {
    final bloc = await pumpGoals(tester, const CrudLoadFailure('Offline'));

    expect(find.text(GoalsTexts.loadErrorTitle), findsOneWidget);
    await tester.tap(find.text(GoalsTexts.retry));

    verify(() => bloc.add(const CrudLoadRequested<GoalDraft>())).called(2);
  });

  testWidgets('offers to reload progress that could not be loaded',
      (tester) async {
    final bloc = await pumpGoals(
      tester,
      CrudLoaded([security.copyWith(projection: null), independence]),
    );

    expect(find.text(GoalsTexts.projectionsUnavailable), findsOneWidget);
    await tester.tap(find.byKey(ProjectionsNotice.retryKey));

    verify(() => bloc.add(const CrudLoadRequested<GoalDraft>())).called(2);
  });

  testWidgets('has no notice when every progress is loaded', (tester) async {
    await pumpGoals(tester, _loaded);

    expect(find.byType(ProjectionsNotice), findsNothing);
  });

  group('empty state', () {
    testWidgets('offers the first goal and the standard goals', (tester) async {
      final bloc = await pumpGoals(tester, const CrudLoaded([]));

      expect(find.text(GoalsTexts.emptyTitle), findsOneWidget);
      expect(find.text(GoalsTexts.firstGoal), findsOneWidget);
      expect(find.text(GoalsTexts.startWithStandard), findsOneWidget);
      await tester.tap(find.byKey(GoalsEmptyState.standardGoalsKey));

      verify(() => bloc.add(const CrudDefaultsRequested<GoalDraft>()))
          .called(1);
    });

    testWidgets('opens the add sheet from its main button', (tester) async {
      await pumpGoals(tester, const CrudLoaded([]));

      await tester.tap(find.byKey(GoalsEmptyState.addGoalKey));
      await tester.pumpAndSettle();

      expect(find.text(GoalsTexts.addGoal), findsWidgets);
      expect(find.byKey(ItemFormSheet.deleteKey), findsNothing);
    });

    testWidgets('disables both buttons while the goals are added',
        (tester) async {
      await pumpGoals(tester, const CrudLoaded([], busy: true), settle: false);
      await tester.pump();

      for (final key in [
        GoalsEmptyState.addGoalKey,
        GoalsEmptyState.standardGoalsKey,
      ]) {
        final button = tester.widget<ButtonStyleButton>(find.byKey(key));
        expect(button.onPressed, isNull);
      }
    });

    testWidgets('reports standard goals that could not be added',
        (tester) async {
      final states = StreamController<_State>();
      addTearDown(states.close);
      await pumpGoals(tester, const CrudLoaded([]), stream: states.stream);

      states.add(
        const CrudLoaded(
          [],
          errorMessage: 'Server unavailable',
          failedAction: CrudAction.createDefaults,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Server unavailable'), findsOneWidget);
    });
  });

  group('layout', () {
    testWidgets('shows the goals in a 2x2 grid on desktop', (tester) async {
      await pumpGoals(tester, _loaded);

      final first = tester.getRect(_card('Seguridad Financiera'));
      final second = tester.getRect(_card('Independencia Financiera'));
      final third = tester.getRect(_card('Libertad Financiera'));
      expect(second.top, first.top);
      expect(second.left, greaterThan(first.right));
      expect(third.left, first.left);
      expect(third.top, greaterThan(first.bottom));
      expect(tester.takeException(), isNull);
    });

    testWidgets('stacks the goals in one column on mobile', (tester) async {
      await pumpGoals(tester, _loaded, size: TestViewports.mobile);

      final first = tester.getRect(_card('Seguridad Financiera'));
      final second = tester.getRect(_card('Independencia Financiera'));
      expect(second.left, first.left);
      expect(second.top, greaterThan(first.bottom));
      expect(tester.takeException(), isNull);
    });

    testWidgets('keeps the API order of the goals', (tester) async {
      await pumpGoals(tester, _loaded, size: TestViewports.mobile);

      final names = tester
          .widgetList<GoalCard>(find.byType(GoalCard, skipOffstage: false))
          .map((card) => card.goal.id);
      expect(names, ['g1', 'g2']);
    });
  });

  group('form', () {
    testWidgets('validates every field before saving', (tester) async {
      final bloc = await pumpGoals(tester, const CrudLoaded([]));
      await openAddSheet(tester);

      await fillAndSave(tester, {
        GoalsTexts.target: '0',
        GoalsTexts.monthlyInvestment: '',
        GoalsTexts.expectedAnnualReturn: '101',
        GoalsTexts.targetYears: '0',
      });
      await tester.pumpAndSettle();

      expect(find.text(CrudTexts.nameRequired), findsOneWidget);
      expect(find.text(GoalsTexts.levelRequired), findsOneWidget);
      expect(find.text(CrudTexts.amountNotPositive), findsOneWidget);
      expect(find.text(CrudTexts.amountRequired), findsOneWidget);
      expect(find.text(GoalsTexts.returnInvalid), findsOneWidget);
      expect(find.text(GoalsTexts.targetYearsInvalid), findsOneWidget);
      verifyNever(
        () => bloc.add(any(that: isA<CrudSaveRequested<GoalDraft>>())),
      );
    });

    testWidgets('rejects a zero return and a missing return', (tester) async {
      await pumpGoals(tester, const CrudLoaded([]));
      await openAddSheet(tester);

      await fillAndSave(tester, {GoalsTexts.expectedAnnualReturn: '0'});
      await tester.pumpAndSettle();
      expect(find.text(GoalsTexts.returnInvalid), findsOneWidget);

      await fillAndSave(tester, {GoalsTexts.expectedAnnualReturn: ''});
      await tester.pumpAndSettle();
      expect(find.text(GoalsTexts.returnRequired), findsOneWidget);
    });

    testWidgets('adds a goal with the return as a fraction', (tester) async {
      final bloc = await pumpGoals(tester, const CrudLoaded([]));
      await openAddSheet(tester);

      await chooseLevel(tester, 'Absolute freedom');
      await fillAndSave(tester, {
        CrudTexts.nameLabel: ' Libertad Absoluta ',
        GoalsTexts.target: '4.366.000.000',
        GoalsTexts.monthlyInvestment: '15.850.000',
        GoalsTexts.expectedAnnualReturn: '11,5',
      });

      verify(
        () => bloc.add(
          const CrudSaveRequested(
            GoalDraft(
              name: 'Libertad Absoluta',
              level: GoalLevel.absoluteFreedom,
              targetAmount: Money.fromPesos(4366000000),
              monthlyInvestment: Money.fromPesos(15850000),
              expectedAnnualReturn: 0.115,
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('edits a goal and keeps the sheet open when saving fails',
        (tester) async {
      final states = StreamController<_State>();
      addTearDown(states.close);
      final bloc = await pumpGoals(tester, _loaded, stream: states.stream);

      await tester.tap(find.text('Seguridad Financiera'));
      await tester.pumpAndSettle();
      expect(find.text(GoalsTexts.editGoal), findsOneWidget);
      expect(find.text('1470000'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);
      expect(find.text('16'), findsOneWidget);
      await fillAndSave(tester, {
        GoalsTexts.monthlyInvestment: '2.000.000',
        GoalsTexts.targetYears: '',
      });

      verify(
        () => bloc.add(
          const CrudSaveRequested(
            GoalDraft(
              name: 'Seguridad Financiera',
              level: GoalLevel.financialSecurity,
              targetAmount: Money.fromPesos(605000000),
              monthlyInvestment: Money.fromPesos(2000000),
              expectedAnnualReturn: 0.11,
            ),
            id: 'g1',
          ),
        ),
      ).called(1);
      await failSave(tester, states, _loaded.items);
    });

    testWidgets('shows the new projected date once the goals reload',
        (tester) async {
      final states = StreamController<_State>();
      addTearDown(states.close);
      await pumpGoals(tester, _loaded, stream: states.stream);
      expect(find.text('December 2029'), findsOneWidget);

      final faster = security.copyWith(
        projection: security.projection!.copyWith(
          projectedAchievementDate: DateTime(2029, 4),
        ),
      );
      states
        ..add(CrudLoaded(excelGoals, busy: true))
        ..add(CrudLoaded([faster, ...excelGoals.skip(1)]));
      await tester.pumpAndSettle();

      expect(find.text('April 2029'), findsOneWidget);
    });
  });

  group('delete', () {
    testWidgets('deletes from the edit sheet after confirming', (tester) async {
      final bloc = await pumpGoals(tester, _loaded);

      await tester.tap(find.text('Seguridad Financiera'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ItemFormSheet.deleteKey));
      await tester.pumpAndSettle();
      expect(find.text(GoalsTexts.deleteTitle), findsOneWidget);
      await tester.tap(find.text(ConfirmationDialog.cancelLabel));
      await tester.pumpAndSettle();
      verifyNever(() => bloc.add(const CrudDeleteRequested<GoalDraft>('g1')));

      await tester.tap(find.text('Seguridad Financiera'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ItemFormSheet.deleteKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(GoalsTexts.delete));
      await tester.pumpAndSettle();

      verify(() => bloc.add(const CrudDeleteRequested<GoalDraft>('g1')))
          .called(1);
    });

    testWidgets('reports a delete that failed', (tester) async {
      final states = StreamController<_State>();
      addTearDown(states.close);
      await pumpGoals(tester, _loaded, stream: states.stream);

      states.add(
        CrudLoaded(
          excelGoals,
          errorMessage: 'Not found',
          failedAction: CrudAction.delete,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Not found'), findsOneWidget);
    });
  });

  group('halfway celebration', () {
    testWidgets('celebrates a goal that a reload shows past half',
        (tester) async {
      final states = StreamController<_State>();
      addTearDown(states.close);
      final before = withProgress(security, 49.5);
      await pumpGoals(
        tester,
        CrudLoaded([before, independence]),
        stream: states.stream,
      );
      expect(find.byKey(HalfwayCelebration.messageKey), findsNothing);

      states
        ..add(CrudLoaded([before, independence], busy: true))
        ..add(CrudLoaded([withProgress(security, 50.2), independence]));
      await tester.pump();
      await tester.pump(HalfwayCelebration.duration ~/ 2);

      expect(
        find.descendant(
          of: _card('Seguridad Financiera'),
          matching: find.byKey(HalfwayCelebration.messageKey),
        ),
        findsOneWidget,
      );
      await tester.pumpAndSettle();
      expect(find.byKey(HalfwayCelebration.messageKey), findsNothing);
    });

    testWidgets('does not celebrate goals already past half when opened',
        (tester) async {
      await pumpGoals(tester, _loaded);
      await tester.pump(HalfwayCelebration.duration ~/ 2);

      expect(find.byKey(HalfwayCelebration.messageKey), findsNothing);
    });
  });
}
