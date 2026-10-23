import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/widgets/status_message.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goals_texts.dart';

/// Shown while the user has no goals: an illustration, a button that adds
/// the first goal and another that starts from the four standard goals.
/// Both are disabled while [busy].
class GoalsEmptyState extends StatelessWidget {
  const GoalsEmptyState({
    required this.busy,
    required this.onAddGoal,
    required this.onUseStandardGoals,
    super.key,
  });

  static const Key addGoalKey = Key('goals-empty-add');
  static const Key standardGoalsKey = Key('goals-empty-standard');

  final bool busy;
  final VoidCallback onAddGoal;
  final VoidCallback onUseStandardGoals;

  @override
  Widget build(BuildContext context) {
    return StatusMessage(
      icon: Icons.flag_outlined,
      illustration: const _Illustration(),
      title: GoalsTexts.emptyTitle,
      message: GoalsTexts.emptyMessage,
      action: Wrap(
        alignment: WrapAlignment.center,
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          FilledButton.icon(
            key: addGoalKey,
            onPressed: busy ? null : onAddGoal,
            icon: const Icon(Icons.add),
            label: const Text(GoalsTexts.firstGoal),
          ),
          OutlinedButton.icon(
            key: standardGoalsKey,
            onPressed: busy ? null : onUseStandardGoals,
            icon: const Icon(Icons.auto_awesome_outlined),
            label: const Text(GoalsTexts.startWithStandard),
          ),
        ],
      ),
    );
  }
}

/// A gold flag on a summit, in a blue disc.
class _Illustration extends StatelessWidget {
  const _Illustration();

  static const double size = AppSpacing.xxxl * 2;
  static const double mountainSize = AppSpacing.xxxl + AppSpacing.md;
  static const double flagSize = AppSpacing.xl + AppSpacing.xs;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.brandPrimary, AppColors.backgroundTertiary],
          ),
        ),
        child: const Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: AppSpacing.md,
              child: Icon(
                Icons.landscape_rounded,
                size: mountainSize,
                color: AppColors.textPrimary,
              ),
            ),
            Positioned(
              top: AppSpacing.md,
              child: Icon(
                Icons.flag_rounded,
                size: flagSize,
                color: AppColors.accentGold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
