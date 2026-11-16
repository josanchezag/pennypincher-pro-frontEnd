import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_sheet.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/budget/presentation/screen/income_sources_screen.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_income_mode.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_plan_basis.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/bloc/goal_plan_basis_cubit.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/screen/goals_screen.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_card.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_mode_fields.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_plan_preview.dart';

import '../../../../helpers/budget_mocks.dart';
import '../../../../helpers/crud_screen_helpers.dart';
import '../../../../helpers/goal_fixtures.dart';
import '../../../../helpers/goal_mocks.dart';
import '../../../../helpers/l10n.dart';
import '../../../../helpers/load_fonts.dart';
import '../../../../helpers/pump_app.dart';

/// Tall enough for the whole sheet, so no field needs scrolling.
const Size _tall = Size(1000, 2000);

const GoalPlanBasis _basis = GoalPlanBasis(
  monthlyIncome: monthlyIncome,
  currentNetWorth: Money.fromUnits(100000000),
);

String _cop(Money amount) => testMoney.format(amount);

Finder _mode(GoalIncomeMode mode) => find.byKey(GoalModeFields.modeKey(mode));

bool _selected(WidgetTester tester, GoalIncomeMode mode) =>
    tester.widget<ChoiceChip>(_mode(mode)).selected;

/// The text of the preview figure with [key].
Finder _preview(Key key, String text) =>
    find.descendant(of: find.byKey(key), matching: find.text(text));

void main() {
  setUpAll(() {
    registerFallbackValue(const CrudLoadRequested<GoalDraft>());
    return loadAppFonts();
  });

  Future<MockGoalsBloc> pumpGoals(
    WidgetTester tester, {
    List<FinancialGoal> goals = const [],
    GoalPlanBasis basis = _basis,
    Locale locale = testLocale,
  }) async {
    final bloc = registerGoalsBloc(CrudLoaded(goals), basis: basis);
    await tester.pumpApp(
      location: AppRoute.goals.path,
      size: _tall,
      locale: locale,
    );
    return bloc;
  }

  Future<void> openAddSheet(WidgetTester tester) async {
    await tester.tap(find.byKey(GoalsScreen.addButtonKey));
    await tester.pumpAndSettle();
  }

  Future<void> chooseLevel(WidgetTester tester, String label) async {
    await tester.tap(find.text(l10n.goalsLevel));
    await tester.pumpAndSettle();
    await tester.tap(find.text(label).last);
    await tester.pumpAndSettle();
  }

  Future<void> chooseMode(WidgetTester tester, GoalIncomeMode mode) async {
    await tester.tap(_mode(mode));
    await tester.pumpAndSettle();
  }

  testWidgets('loads the income and net worth when the screen opens',
      (tester) async {
    registerGoalsBloc(const CrudLoaded([]));
    final cubit = getIt<GoalPlanBasisCubit>();
    await tester.pumpApp(location: AppRoute.goals.path);

    verify(cubit.load).called(1);
  });

  testWidgets('starts a new goal from the current income and previews it',
      (tester) async {
    final bloc = await pumpGoals(tester);
    await openAddSheet(tester);

    expect(_selected(tester, GoalIncomeMode.currentIncome), isTrue);
    expect(find.text(l10n.goalsIncomeBasis.toUpperCase()), findsOneWidget);
    expect(find.text(_cop(monthlyIncome)), findsOneWidget);
    expect(fieldLabeled(l10n.goalsTarget), findsNothing);
    expect(fieldLabeled(l10n.goalsMonthlyInvestment), findsNothing);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('16'), findsOneWidget);
    expect(find.text(l10n.goalsTargetYearsRequiredHelper), findsOneWidget);

    await chooseLevel(tester, 'Financial independence');
    expect(find.text('×1'), findsOneWidget);
    expect(
      _preview(GoalPlanPreview.desiredKey, _cop(monthlyIncome)),
      findsOneWidget,
    );
    expect(
      _preview(
        GoalPlanPreview.targetKey,
        _cop(const Money.fromCents(125405366123)),
      ),
      findsOneWidget,
    );
    expect(
      _preview(
        GoalPlanPreview.requiredKey,
        _cop(const Money.fromCents(176243439)),
      ),
      findsOneWidget,
    );
    expect(find.text(l10n.goalsPreviewNote), findsOneWidget);

    await fillAndSave(tester, {l10n.crudNameLabel: 'Independencia'});

    verify(
      () => bloc.add(
        const CrudSaveRequested(
          GoalDraft(
            name: 'Independencia',
            level: GoalLevel.financialIndependence,
            expectedAnnualReturn: 0.10,
            targetYears: 16,
            incomeMode: GoalIncomeMode.currentIncome,
          ),
        ),
      ),
    ).called(1);
  });

  testWidgets('asks for the income the user wants and previews its plan',
      (tester) async {
    final bloc = await pumpGoals(
      tester,
      basis: const GoalPlanBasis(
        monthlyIncome: monthlyIncome,
        currentNetWorth: Money.fromUnits(50000000),
      ),
    );
    await openAddSheet(tester);
    await chooseLevel(tester, 'Financial freedom');

    await chooseMode(tester, GoalIncomeMode.desiredIncome);
    expect(find.text('20,000,000'), findsOneWidget);
    expect(find.text(l10n.goalsIncomeBasis.toUpperCase()), findsNothing);

    await tester.enterText(fieldLabeled(l10n.goalsDesiredIncome), '6000000');
    await tester.enterText(fieldLabeled(l10n.goalsExpectedAnnualReturn), '12');
    await tester.enterText(fieldLabeled(l10n.goalsTargetYears), '10');
    await tester.pumpAndSettle();
    expect(
      _preview(
        GoalPlanPreview.targetKey,
        _cop(const Money.fromCents(75243219674)),
      ),
      findsOneWidget,
    );
    expect(
      _preview(
        GoalPlanPreview.requiredKey,
        _cop(const Money.fromCents(269066677)),
      ),
      findsOneWidget,
    );

    await fillAndSave(tester, {l10n.crudNameLabel: 'Libertad'});

    verify(
      () => bloc.add(
        const CrudSaveRequested(
          GoalDraft(
            name: 'Libertad',
            level: GoalLevel.financialFreedom,
            expectedAnnualReturn: 0.12,
            targetYears: 10,
            incomeMode: GoalIncomeMode.desiredIncome,
            desiredMonthlyIncome: Money.fromUnits(6000000),
          ),
        ),
      ),
    ).called(1);
  });

  testWidgets('requires the income and the term in the income modes',
      (tester) async {
    final bloc = await pumpGoals(tester);
    await openAddSheet(tester);
    await chooseMode(tester, GoalIncomeMode.desiredIncome);

    await fillAndSave(tester, {
      l10n.crudNameLabel: 'Meta',
      l10n.goalsTargetYears: '',
    });
    await tester.pumpAndSettle();

    expect(find.text(l10n.crudAmountRequired), findsOneWidget);
    expect(find.text(l10n.goalsTargetYearsRequired), findsOneWidget);

    await fillAndSave(tester, {l10n.goalsDesiredIncome: '0'});
    await tester.pumpAndSettle();
    expect(find.text(l10n.crudAmountNotPositive), findsOneWidget);
    verifyNever(
      () => bloc.add(any(that: isA<CrudSaveRequested<GoalDraft>>())),
    );
  });

  testWidgets('keeps the manual fields to the manual mode', (tester) async {
    await pumpGoals(tester, basis: GoalPlanBasis.unknown);
    await openAddSheet(tester);

    expect(_selected(tester, GoalIncomeMode.manual), isTrue);
    expect(fieldLabeled(l10n.goalsTarget), findsOneWidget);
    expect(fieldLabeled(l10n.goalsMonthlyInvestment), findsOneWidget);
    expect(fieldLabeled(l10n.goalsDesiredIncome), findsNothing);
    expect(find.text(l10n.goalsTargetYearsHelper), findsOneWidget);

    await chooseMode(tester, GoalIncomeMode.currentIncome);
    expect(fieldLabeled(l10n.goalsTarget), findsNothing);
    expect(find.text(l10n.goalsIncomeUnknown), findsOneWidget);
    expect(find.text(l10n.goalsModeCurrentIncomeHelp), findsOneWidget);

    await chooseMode(tester, GoalIncomeMode.manual);
    expect(fieldLabeled(l10n.goalsTarget), findsOneWidget);
    expect(find.text(l10n.goalsModeManualHelp), findsOneWidget);
  });

  testWidgets('previews the 10 % return of a manual target', (tester) async {
    await pumpGoals(tester, basis: GoalPlanBasis.unknown);
    await openAddSheet(tester);

    await tester.enterText(fieldLabeled(l10n.goalsTarget), '605000000');
    await tester.pumpAndSettle();

    expect(
      _preview(
        GoalPlanPreview.targetKey,
        _cop(const Money.fromUnits(605000000)),
      ),
      findsOneWidget,
    );
    expect(find.byKey(GoalPlanPreview.desiredKey), findsNothing);
    expect(
      find.textContaining(_cop(const Money.fromCents(482435496))),
      findsOneWidget,
    );
  });

  testWidgets('bases a manual goal on the income from its card',
      (tester) async {
    final bloc = await pumpGoals(tester, goals: excelGoals);

    await tester.tap(find.byKey(GoalCard.baseOnIncomeKey).first);
    await tester.pumpAndSettle();

    expect(find.text(l10n.goalsEditGoal), findsOneWidget);
    expect(_selected(tester, GoalIncomeMode.currentIncome), isTrue);
    expect(find.text('×0.6'), findsOneWidget);
    expect(
      _preview(
        GoalPlanPreview.desiredKey,
        _cop(const Money.fromUnits(6000000)),
      ),
      findsOneWidget,
    );
    expect(
      _preview(
        GoalPlanPreview.targetKey,
        _cop(const Money.fromCents(75243219674)),
      ),
      findsOneWidget,
    );
    await tester.tap(find.byKey(ItemFormSheet.saveKey));
    await tester.pump();

    verify(
      () => bloc.add(
        const CrudSaveRequested(
          GoalDraft(
            name: 'Seguridad Financiera',
            level: GoalLevel.financialSecurity,
            expectedAnnualReturn: 0.11,
            targetYears: 16,
            incomeMode: GoalIncomeMode.currentIncome,
          ),
          id: 'g1',
        ),
      ),
    ).called(1);
  });

  testWidgets('opens a goal on a typed income in its own mode', (tester) async {
    await pumpGoals(tester, goals: [incomeIndependence, desiredFreedom]);
    expect(find.byKey(GoalCard.baseOnIncomeKey), findsNothing);

    await tester.tap(find.text('Libertad que quiero'));
    await tester.pumpAndSettle();

    expect(_selected(tester, GoalIncomeMode.desiredIncome), isTrue);
    expect(find.text('6,000,000'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
  });

  testWidgets('sends a user without income to the income sources',
      (tester) async {
    registerIncomeSourceBloc(const CrudLoaded([]));
    await pumpGoals(
      tester,
      basis: const GoalPlanBasis(monthlyIncome: Money.zero),
    );
    await openAddSheet(tester);
    expect(_selected(tester, GoalIncomeMode.manual), isTrue);

    await chooseMode(tester, GoalIncomeMode.currentIncome);
    expect(find.text(l10n.goalsIncomeMissing), findsOneWidget);
    await tester.tap(find.text(l10n.goalsGoToIncome));
    await tester.pumpAndSettle();

    expect(find.byType(IncomeSourcesScreen), findsOneWidget);
    expect(find.byType(GoalModeFields), findsNothing);
  });

  testWidgets('writes the modes in Spanish', (tester) async {
    await pumpGoals(tester, locale: AppLocales.spanish);
    await openAddSheet(tester);

    for (final text in [
      '¿Cómo quieres definir esta meta?',
      'Mi ingreso actual',
      'Cuánto quiero ganar',
      'Manual',
      'Vista previa',
      'TU INGRESO ACTUAL',
      'FACTOR DEL NIVEL',
    ]) {
      expect(find.text(text), findsOneWidget, reason: text);
    }
    expect(tester.takeException(), isNull);
  });
}
