import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goal_styles.dart';

/// Upper-case name of a goal level on the level's own color.
class GoalLevelBadge extends StatelessWidget {
  const GoalLevelBadge({required this.level, super.key});

  final GoalLevel level;

  Color get color => level.color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSpacing.radiusCard),
        ),
      ),
      child: Text(
        level.label.toUpperCase(),
        style: AppTypography.label.copyWith(color: level.onColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
