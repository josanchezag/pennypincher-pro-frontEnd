import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_breakpoints.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/widgets/labeled_figure.dart';
import 'package:pennypincher_pro/core/widgets/loading_skeleton.dart';
import 'package:pennypincher_pro/core/widgets/responsive_card_row.dart';
import 'package:pennypincher_pro/core/widgets/screen_title_row.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/core/widgets/status_message.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_projection_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/bloc/goal_projection_bloc.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goals_texts.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_figures.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/goal_level_badge.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/projection_chart.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/widget/projection_summary.dart';

/// `/goals/:goalId/projection`: the target, current net worth and projected
/// date of a goal, the chart of its projected net worth and a summary.
/// Expects a [GoalProjectionBloc] above it.
class GoalProjectionScreen extends StatelessWidget {
  const GoalProjectionScreen({required this.goalId, super.key});

  /// The single card of figures shown on mobile.
  static const Key compactFiguresKey = Key('projection-compact-figures');

  static const List<double> skeletonHeights = [
    AppSpacing.xxl,
    AppSpacing.xxxl + AppSpacing.lg,
    ProjectionChart.height,
  ];

  final String goalId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalProjectionBloc, GoalProjectionState>(
      builder: (context, state) => switch (state) {
        GoalProjectionLoading() => const LoadingSkeleton(
            heights: skeletonHeights,
            label: GoalsTexts.projectionLoading,
          ),
        final GoalProjectionFailure failure =>
          _FailureMessage(failure: failure, goalId: goalId),
        GoalProjectionLoaded(:final projection) =>
          _ProjectionContent(projection: projection),
      },
    );
  }
}

/// A goal that no longer exists leads back to the goals; any other
/// failure can be retried.
class _FailureMessage extends StatelessWidget {
  const _FailureMessage({required this.failure, required this.goalId});

  final GoalProjectionFailure failure;
  final String goalId;

  @override
  Widget build(BuildContext context) {
    if (failure.notFound) {
      return StatusMessage(
        icon: Icons.search_off_outlined,
        title: GoalsTexts.goalNotFoundTitle,
        message: GoalsTexts.goalNotFoundMessage,
        action: FilledButton.icon(
          onPressed: () => context.goNamed(AppRoute.goals.name),
          icon: const Icon(Icons.arrow_back),
          label: const Text(GoalsTexts.backToGoals),
        ),
      );
    }
    return StatusMessage(
      icon: Icons.cloud_off_outlined,
      title: GoalsTexts.projectionErrorTitle,
      message: failure.message,
      action: FilledButton.icon(
        onPressed: () => context
            .read<GoalProjectionBloc>()
            .add(GoalProjectionRequested(goalId)),
        icon: const Icon(Icons.refresh),
        label: const Text(GoalsTexts.retry),
      ),
    );
  }
}

class _ProjectionContent extends StatelessWidget {
  const _ProjectionContent({required this.projection});

  final GoalProjection projection;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        ScreenTitleRow(
          title: projection.name,
          backTooltip: GoalsTexts.backToGoals,
          parent: AppRoute.goals.name,
        ),
        const SizedBox(height: AppSpacing.xs),
        Align(
          alignment: Alignment.centerLeft,
          child: GoalLevelBadge(level: projection.level),
        ),
        const SizedBox(height: AppSpacing.md),
        _Figures(projection: projection),
        const SizedBox(height: AppSpacing.md),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ProjectionChart(projection: projection),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ProjectionSummary(projection: projection),
      ],
    );
  }
}

/// Target, current net worth and projected date: three cards from tablet
/// up, and on mobile one compact card, so the chart stays near the top.
class _Figures extends StatelessWidget {
  const _Figures({required this.projection});

  final GoalProjection projection;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          ScreenSize.fromWidth(constraints.maxWidth) == ScreenSize.mobile
              ? _compact()
              : _cards(),
    );
  }

  Widget _compact() => Card(
        key: GoalProjectionScreen.compactFiguresKey,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: LabeledFigure(
                      label: GoalsTexts.target,
                      value: GoalFormat.amount(projection.targetAmount),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: LabeledFigure(
                      label: GoalsTexts.currentNetWorth,
                      value: GoalFormat.amount(projection.currentNetWorth),
                    ),
                  ),
                ],
              ),
              LabeledFigure(
                label: GoalsTexts.projectedDate,
                value: GoalFormat.achievement(projection),
              ),
            ],
          ),
        ),
      );

  Widget _cards() => ResponsiveCardRow(
        children: [
          StatCard(
            label: GoalsTexts.target,
            value: GoalFormat.amount(projection.targetAmount),
            icon: Icons.flag_outlined,
          ),
          StatCard(
            label: GoalsTexts.currentNetWorth,
            value: GoalFormat.amount(projection.currentNetWorth),
            icon: Icons.account_balance_outlined,
          ),
          StatCard(
            label: GoalsTexts.projectedDate,
            value: GoalFormat.achievement(projection),
            icon: Icons.event_outlined,
          ),
        ],
      );
}
