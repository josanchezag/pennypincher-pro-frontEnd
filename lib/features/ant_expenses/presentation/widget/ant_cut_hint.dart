import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';

/// How a cut works: each budget calculation takes the period's total as
/// one expense and starts a new period. Links to the budget overview.
class AntCutHint extends StatelessWidget {
  const AntCutHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.antCutHint, style: AppTypography.bodyMedium),
              TextButton(
                onPressed: () => context.goNamed(AppRoute.budgetOverview.name),
                child: Text(context.l10n.expenseOpenBudgetOverview),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
