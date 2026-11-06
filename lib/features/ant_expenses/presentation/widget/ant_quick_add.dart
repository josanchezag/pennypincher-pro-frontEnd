import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_breakpoints.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/ant_expense_categories.dart';

/// One chip per category that opens the add sheet with that category
/// already chosen, so an expense takes the amount and a tap on Save. One
/// scrolling row on mobile screens; wrapped from tablet up, also in the
/// narrower column of desktop screens.
class AntQuickAdd extends StatelessWidget {
  const AntQuickAdd({required this.onAdd, super.key});

  static Key chipKey(AntExpenseCategory category) =>
      Key('ant-quick-add-${category.name}');

  /// Null while a change is running.
  final ValueChanged<AntExpenseCategory>? onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final chips = [
      for (final category in AntExpenseCategory.values)
        Tooltip(
          message: l10n.antQuickAddTooltip(category.label(l10n)),
          excludeFromSemantics: true,
          child: Semantics(
            button: true,
            label: l10n.antQuickAddTooltip(category.label(l10n)),
            excludeSemantics: true,
            child: ActionChip(
              key: chipKey(category),
              avatar: Icon(
                category.icon,
                size: AppSpacing.md,
                color: AppColors.accentGold,
              ),
              label: Text(category.label(l10n)),
              labelStyle: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textPrimary),
              onPressed: onAdd == null ? null : () => onAdd!(category),
            ),
          ),
        ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child:
              Text(l10n.antQuickAdd.toUpperCase(), style: AppTypography.label),
        ),
        const SizedBox(height: AppSpacing.xs),
        Builder(
          builder: (context) =>
              ScreenSize.fromWidth(MediaQuery.sizeOf(context).width) ==
                      ScreenSize.mobile
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (final chip in chips)
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: AppSpacing.xs),
                              child: chip,
                            ),
                        ],
                      ),
                    )
                  : Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: chips,
                    ),
        ),
      ],
    );
  }
}
