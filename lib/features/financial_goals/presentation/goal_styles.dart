import 'package:flutter/painting.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';

/// Display name and badge color of every goal level.
extension GoalLevelStyle on GoalLevel {
  String get label => switch (this) {
        GoalLevel.financialSecurity => 'Financial security',
        GoalLevel.financialIndependence => 'Financial independence',
        GoalLevel.financialFreedom => 'Financial freedom',
        GoalLevel.absoluteFreedom => 'Absolute freedom',
      };

  Color get color => switch (this) {
        GoalLevel.financialSecurity => AppColors.brandPrimary,
        GoalLevel.financialIndependence => AppColors.accentTeal,
        GoalLevel.financialFreedom => AppColors.accentPurple,
        GoalLevel.absoluteFreedom => AppColors.accentGold,
      };

  /// Text color on [color] with at least the 4.5:1 contrast of WCAG AA:
  /// dark on the light teal and gold, white on the deeper blue and purple.
  Color get onColor => switch (this) {
        GoalLevel.financialSecurity => AppColors.textOnBrand,
        GoalLevel.financialIndependence => AppColors.backgroundPrimary,
        GoalLevel.financialFreedom => AppColors.textOnBrand,
        GoalLevel.absoluteFreedom => AppColors.backgroundPrimary,
      };
}
