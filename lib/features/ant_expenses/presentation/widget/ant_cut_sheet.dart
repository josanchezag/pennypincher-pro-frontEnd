import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_report_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_cut_items_cubit.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_section.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_cuts_card.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_expense_list.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_section_states.dart';

/// Bottom sheet with the expenses one past cut took, read only, and why
/// they can no longer change: they are already in that month's budget.
class AntCutSheet extends StatelessWidget {
  const AntCutSheet({required this.cut, required this.today, super.key});

  static const Key lockedKey = Key('ant-cut-locked');

  /// Share of the screen height the sheet may take.
  static const double maxHeightShare = 0.85;

  final AntCut cut;
  final DateTime today;

  /// Opens the sheet of [cut], loading its expenses with a fresh cubit.
  static Future<void> show(
    BuildContext context, {
    required AntCut cut,
    required DateTime today,
  }) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => BlocProvider<AntCutItemsCubit>(
          create: (_) => getIt<AntCutItemsCubit>()..load(cut.budgetId),
          child: AntCutSheet(cut: cut, today: today),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final month = MonthFormat.long.format(cut.month);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * maxHeightShare,
      ),
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  namesRoute: true,
                  child: Text(
                    l10n.antCutTitle(month),
                    style: AppTypography.heading3,
                  ),
                ),
              ),
              IconButton(
                tooltip: l10n.antClose,
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.money.format(cut.total),
            style: AppTypography.monoLarge.copyWith(color: AppColors.warning),
          ),
          Text(
            '${l10n.expenseItemCount(cut.count)} · ${AntCutTexts.period(l10n, cut)}',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          _LockedNotice(month: month),
          BlocBuilder<AntCutItemsCubit, AntSection<List<AntExpense>>>(
            builder: (context, state) => switch (state) {
              AntSectionLoading() => const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.md),
                  child: AntSectionSkeleton(
                    heights: [AppSpacing.xxxl, AppSpacing.xxxl],
                  ),
                ),
              AntSectionFailure(:final message) => Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: AntSectionError(
                    title: l10n.antCutItemsLoadError,
                    message: message,
                    onRetry: () =>
                        context.read<AntCutItemsCubit>().load(cut.budgetId),
                  ),
                ),
              AntSectionLoaded(:final value) when value.isEmpty => Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: Text(
                    l10n.antCutItemsEmpty,
                    style: AppTypography.bodyMedium,
                  ),
                ),
              AntSectionLoaded(:final value) =>
                AntExpenseList(items: value, today: today),
            },
          ),
        ],
      ),
    );
  }
}

class _LockedNotice extends StatelessWidget {
  const _LockedNotice({required this.month});

  final String month;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: AntCutSheet.lockedKey,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: const BoxDecoration(
        color: AppColors.backgroundTertiary,
        borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusCard)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lock_outline, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              context.l10n.antCutLocked(month),
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
