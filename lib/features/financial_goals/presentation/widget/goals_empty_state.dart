import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/widgets/status_message.dart';

/// Shown while the user has no goals: an illustration, a button that adds
/// the first goal and another that starts from the four standard goals.
/// Both are disabled while [busy]. When the standard goals were refused
/// because the user has no income yet ([incomeRequired]), it explains it
/// and leads to the income sources with [onGoToIncome] instead, keeping
/// the button that adds a goal by hand.
class GoalsEmptyState extends StatelessWidget {
  const GoalsEmptyState({
    required this.busy,
    required this.onAddGoal,
    required this.onUseStandardGoals,
    required this.onGoToIncome,
    this.incomeRequired = false,
    super.key,
  });

  static const Key addGoalKey = Key('goals-empty-add');
  static const Key standardGoalsKey = Key('goals-empty-standard');
  static const Key goToIncomeKey = Key('goals-empty-go-to-income');

  final bool busy;
  final bool incomeRequired;
  final VoidCallback onAddGoal;
  final VoidCallback onUseStandardGoals;
  final VoidCallback onGoToIncome;

  @override
  Widget build(BuildContext context) {
    return incomeRequired ? _incomeRequired(context) : _empty(context);
  }

  Widget _incomeRequired(BuildContext context) {
    final l10n = context.l10n;
    return StatusMessage(
      icon: Icons.payments_outlined,
      title: l10n.goalsIncomeRequiredTitle,
      message: l10n.goalsIncomeRequiredMessage,
      action: Wrap(
        alignment: WrapAlignment.center,
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          FilledButton.icon(
            key: goToIncomeKey,
            onPressed: onGoToIncome,
            icon: const Icon(Icons.payments_outlined),
            label: Text(l10n.goalsGoToIncome),
          ),
          OutlinedButton.icon(
            key: addGoalKey,
            onPressed: busy ? null : onAddGoal,
            icon: const Icon(Icons.add),
            label: Text(l10n.firstGoalTitle),
          ),
        ],
      ),
    );
  }

  Widget _empty(BuildContext context) {
    return StatusMessage(
      icon: Icons.flag_outlined,
      illustration: const _Illustration(),
      title: context.l10n.goalsEmptyTitle,
      message: context.l10n.goalsEmptyMessage,
      action: Wrap(
        alignment: WrapAlignment.center,
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          FilledButton.icon(
            key: addGoalKey,
            onPressed: busy ? null : onAddGoal,
            icon: const Icon(Icons.add),
            label: Text(context.l10n.firstGoalTitle),
          ),
          OutlinedButton.icon(
            key: standardGoalsKey,
            onPressed: busy ? null : onUseStandardGoals,
            icon: const Icon(Icons.auto_awesome_outlined),
            label: Text(context.l10n.goalsUseStandard),
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
