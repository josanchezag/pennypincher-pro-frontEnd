import 'package:flutter/painting.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/goal_level.dart';

/// Display name, description and badge color of every goal level.
extension GoalLevelStyle on GoalLevel {
  String label(AppLocalizations l10n) => switch (this) {
        GoalLevel.financialSecurity => l10n.goalLevelFinancialSecurity,
        GoalLevel.financialIndependence => l10n.goalLevelFinancialIndependence,
        GoalLevel.financialFreedom => l10n.goalLevelFinancialFreedom,
        GoalLevel.absoluteFreedom => l10n.goalLevelAbsoluteFreedom,
      };

  /// What the level means, in the interface language. The backend sends an
  /// English description too, which is not shown.
  String description(AppLocalizations l10n) => switch (this) {
        GoalLevel.financialSecurity =>
          l10n.goalLevelFinancialSecurityDescription,
        GoalLevel.financialIndependence =>
          l10n.goalLevelFinancialIndependenceDescription,
        GoalLevel.financialFreedom => l10n.goalLevelFinancialFreedomDescription,
        GoalLevel.absoluteFreedom => l10n.goalLevelAbsoluteFreedomDescription,
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
