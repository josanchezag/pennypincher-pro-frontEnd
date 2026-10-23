import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_breakpoints.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goals_texts.dart';

/// Builds the card of one goal.
typedef GoalCardBuilder = Widget Function(FinancialGoal goal);

/// Loaded content of the goals screen: title, a progress bar while
/// [busy], and the goal cards in API order, one column on mobile and two
/// (a 2x2 grid for the four levels) from tablet up, or the [empty] view.
/// An optional [notice] goes above the cards.
class GoalList extends StatelessWidget {
  const GoalList({
    required this.goals,
    required this.busy,
    required this.card,
    required this.empty,
    this.notice,
    super.key,
  });

  static const int wideColumns = 2;

  /// Room under the last card so the add button never covers it.
  static const double bottomInset = AppSpacing.xxxl + AppSpacing.xl;

  final List<FinancialGoal> goals;
  final bool busy;
  final GoalCardBuilder card;
  final Widget empty;
  final Widget? notice;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          bottomInset,
        ),
        children: [
          _Header(busy: busy),
          if (notice case final notice?) notice,
          if (goals.isEmpty)
            empty
          else
            ..._rows(columnsFor(constraints.maxWidth)),
        ],
      ),
    );
  }

  static int columnsFor(double width) =>
      ScreenSize.fromWidth(width) == ScreenSize.mobile ? 1 : wideColumns;

  /// Rows of [columns] cards with the height of the tallest one.
  List<Widget> _rows(int columns) => [
        for (var start = 0; start < goals.length; start += columns)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var column = 0; column < columns; column++) ...[
                    if (column > 0) const SizedBox(width: AppSpacing.md),
                    Expanded(child: _cell(start + column)),
                  ],
                ],
              ),
            ),
          ),
      ];

  Widget _cell(int index) =>
      index < goals.length ? card(goals[index]) : const SizedBox.shrink();
}

class _Header extends StatelessWidget {
  const _Header({required this.busy});

  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(AppRoute.goals.title, style: AppTypography.heading1),
        ),
        const SizedBox(height: AppSpacing.xxs),
        const Text(GoalsTexts.subtitle, style: AppTypography.bodyMedium),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: AppSpacing.xxs,
          child: busy ? const LinearProgressIndicator() : null,
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}
