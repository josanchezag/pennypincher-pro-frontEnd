import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/widgets/app_snackbar.dart';
import 'package:pennypincher_pro/core/widgets/confirmation_dialog.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/core/widgets/status_message.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/halfway_milestone.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/bloc/goals_bloc.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goals_texts.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_card.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_form_sheet.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_list.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goals_empty_state.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/projections_notice.dart';

typedef _State = CrudState<FinancialGoal>;

/// `/goals`: a card per goal with its progress and projected date, an add
/// button, an edit sheet with delete, and an empty state that offers the
/// standard goals. A goal that a reload shows past half of its target is
/// celebrated once. Expects a [GoalsBloc] above it.
class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  static const Key addButtonKey = Key('goals-add-button');
  static const List<double> skeletonHeights = [
    AppSpacing.xxl,
    AppSpacing.xxxl * 4,
    AppSpacing.xxxl * 4,
  ];

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  /// Goals of the last loaded state, to compare a reload with.
  List<FinancialGoal> _previous = const [];
  Set<String> _celebrating = const {};

  @override
  void initState() {
    super.initState();
    _previous = _goalsOf(context.read<GoalsBloc>().state) ?? const [];
  }

  static List<FinancialGoal>? _goalsOf(_State state) =>
      state is CrudLoaded<FinancialGoal> && !state.busy ? state.items : null;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: BlocConsumer<GoalsBloc, _State>(
        listenWhen: (_, state) => _goalsOf(state) != null,
        listener: _onLoaded,
        builder: (context, state) => Scaffold(
          floatingActionButton: state is CrudLoaded<FinancialGoal>
              ? FloatingActionButton(
                  key: GoalsScreen.addButtonKey,
                  tooltip: GoalsTexts.addGoal,
                  onPressed: state.busy ? null : () => _edit(context, null),
                  child: const Icon(Icons.add),
                )
              : null,
          body: _body(context, state),
        ),
      ),
    );
  }

  /// Reports a failed delete or standard goals request, and starts the
  /// celebration of the goals that just passed half of their target.
  void _onLoaded(BuildContext context, _State state) {
    final loaded = state as CrudLoaded<FinancialGoal>;
    final crossed = HalfwayMilestone.crossedBetween(_previous, loaded.items);
    _previous = loaded.items;
    if (crossed.isNotEmpty) {
      setState(() => _celebrating = {..._celebrating, ...crossed});
    }
    final message = loaded.errorMessage;
    if (message != null && loaded.failedAction != CrudAction.save) {
      AppSnackbar.showError(context, message);
    }
  }

  Widget _body(BuildContext context, _State state) => switch (state) {
        CrudLoading<FinancialGoal>() => const LoadingSkeleton(
            heights: GoalsScreen.skeletonHeights,
            label: GoalsTexts.loadingLabel,
          ),
        CrudLoadFailure<FinancialGoal>(:final message) => StatusMessage(
            icon: Icons.cloud_off_outlined,
            title: GoalsTexts.loadErrorTitle,
            message: message,
            action: FilledButton.icon(
              onPressed: () => _reload(context),
              icon: const Icon(Icons.refresh),
              label: const Text(GoalsTexts.retry),
            ),
          ),
        CrudLoaded<FinancialGoal>(:final items, :final busy) =>
          _list(context, items, busy),
      };

  Widget _list(BuildContext context, List<FinancialGoal> goals, bool busy) =>
      GoalList(
        goals: goals,
        busy: busy,
        card: (goal) => _card(context, goal, busy),
        notice: goals.any((goal) => goal.projection == null)
            ? ProjectionsNotice(onRetry: busy ? null : () => _reload(context))
            : null,
        empty: GoalsEmptyState(
          busy: busy,
          onAddGoal: () => _edit(context, null),
          onUseStandardGoals: () => context
              .read<GoalsBloc>()
              .add(const CrudDefaultsRequested<GoalDraft>()),
        ),
      );

  static void _reload(BuildContext context) =>
      context.read<GoalsBloc>().add(const CrudLoadRequested<GoalDraft>());

  Widget _card(BuildContext context, FinancialGoal goal, bool busy) => GoalCard(
        key: ValueKey(goal.id),
        goal: goal,
        onTap: busy ? null : () => _edit(context, goal),
        celebrate: _celebrating.contains(goal.id),
        onCelebrated: () => setState(
          () => _celebrating = {..._celebrating}..remove(goal.id),
        ),
      );

  Future<void> _edit(BuildContext context, FinancialGoal? goal) async {
    final bloc = context.read<GoalsBloc>();
    final deleteRequested =
        await GoalFormSheet.show(context, bloc: bloc, goal: goal);
    if (deleteRequested && goal != null && context.mounted) {
      await _delete(context, bloc, goal);
    }
  }

  static Future<void> _delete(
    BuildContext context,
    GoalsBloc bloc,
    FinancialGoal goal,
  ) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: GoalsTexts.deleteTitle,
      message: '"${goal.name}" ${GoalsTexts.deleteMessageSuffix}',
      confirmLabel: GoalsTexts.delete,
    );
    if (confirmed) {
      bloc.add(CrudDeleteRequested<GoalDraft>(goal.id));
    }
  }
}
