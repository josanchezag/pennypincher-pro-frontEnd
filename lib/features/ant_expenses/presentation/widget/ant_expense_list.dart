import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/item_layout.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_tile.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/time/day_format.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/ant_expense_categories.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/widget/ant_expense_form.dart';

/// Expenses of one day, newest first, with their subtotal.
class AntDayGroup {
  const AntDayGroup({required this.day, required this.items});

  final DateTime day;
  final List<AntExpense> items;

  Money get subtotal => sumMoney(items, (item) => item.amount);

  /// [items] by day of purchase, newest day first; within a day the newest
  /// entry goes first.
  static List<AntDayGroup> byDay(Iterable<AntExpense> items) {
    final sorted = items.toList()..sort(_newestFirst);
    final groups = <AntDayGroup>[];
    for (final item in sorted) {
      final day = DayFormat.dayOf(item.spentOn);
      if (groups.isNotEmpty && DayFormat.sameDay(groups.last.day, day)) {
        groups.last.items.add(item);
      } else {
        groups.add(AntDayGroup(day: day, items: [item]));
      }
    }
    return groups;
  }

  static int _newestFirst(AntExpense a, AntExpense b) {
    final byDay = b.spentOn.compareTo(a.spentOn);
    if (byDay != 0) {
      return byDay;
    }
    final aCreated = a.createdAt;
    final bCreated = b.createdAt;
    return aCreated == null || bCreated == null
        ? 0
        : bCreated.compareTo(aCreated);
  }
}

/// The expenses grouped by day under headers with the day's subtotal. Open
/// expenses are edited by tapping them and deleted by swiping them or with
/// their delete button; without [onEdit] and [onDelete] the list is read
/// only.
class AntExpenseList extends StatelessWidget {
  const AntExpenseList({
    required this.items,
    required this.today,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  final List<AntExpense> items;
  final DateTime today;
  final ValueChanged<AntExpense>? onEdit;
  final ValueChanged<AntExpense>? onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final group in AntDayGroup.byDay(items)) ...[
          _DayHeader(
            label: AntDayLabel.of(context.l10n, group.day, today),
            subtotal: group.subtotal,
          ),
          for (final (index, item) in group.items.indexed) ...[
            if (index > 0) const SizedBox(height: AppSpacing.xs),
            _tile(context, item),
          ],
        ],
      ],
    );
  }

  Widget _tile(BuildContext context, AntExpense item) {
    final l10n = context.l10n;
    final title = item.title(l10n);
    if (onEdit == null && onDelete == null) {
      return _ReadOnlyTile(item: item, title: title);
    }
    return ItemTile(
      dismissKey: ValueKey(item.id),
      name: title,
      content: ItemTileContent(
        details: _CategoryLine(category: item.category),
        amount: context.money.format(item.amount),
        amountColor: AppColors.warning,
      ),
      height: ItemTile.compactHeight,
      deleteTooltip: l10n.crudDeleteTooltip(title),
      onTap: onEdit == null ? null : () => onEdit!(item),
      onDelete: onDelete == null ? null : () => onDelete!(item),
    );
  }
}

/// Card of an expense that can no longer change.
class _ReadOnlyTile extends StatelessWidget {
  const _ReadOnlyTile({required this.item, required this.title});

  final AntExpense item;
  final String title;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.bodyLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    _CategoryLine(category: item.category),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                context.money.format(item.amount),
                style:
                    AppTypography.monoMedium.copyWith(color: AppColors.warning),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryLine extends StatelessWidget {
  const _CategoryLine({required this.category});

  final AntExpenseCategory category;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          category.icon,
          size: AppSpacing.md,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.xxs),
        Flexible(child: CategoryLabel(label: category.label(context.l10n))),
      ],
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.label, required this.subtotal});

  final String label;
  final Money subtotal;

  @override
  Widget build(BuildContext context) {
    final subtotal = context.money.format(this.subtotal);
    return Semantics(
      header: true,
      label: '$label, $subtotal',
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.md,
            bottom: AppSpacing.xs,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(label.toUpperCase(), style: AppTypography.label),
              ),
              Text(subtotal, style: AppTypography.monoSmall),
            ],
          ),
        ),
      ),
    );
  }
}
