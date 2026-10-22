import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';

/// Card of one list item: name, category chip and amount. Tapping it edits
/// the item; the trailing button deletes it.
class ItemTile extends StatelessWidget {
  const ItemTile({
    required this.name,
    required this.categoryLabel,
    required this.amount,
    required this.amountColor,
    required this.deleteTooltip,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  /// Fixed height so tiles line up in the tablet and desktop grid.
  static const double height = 76;

  final String name;
  final String categoryLabel;
  final String amount;
  final Color amountColor;
  final String deleteTooltip;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Expanded(child: MergeSemantics(child: _editArea())),
            _deleteButton(),
          ],
        ),
      ),
    );
  }

  /// Name, category and amount, read as one button by screen readers.
  Widget _editArea() => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: _Description(name: name, category: categoryLabel),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                amount,
                style: AppTypography.monoMedium.copyWith(color: amountColor),
              ),
            ],
          ),
        ),
      );

  Widget _deleteButton() => IconButton(
        tooltip: deleteTooltip,
        icon: const Icon(Icons.delete_outline),
        color: AppColors.textSecondary,
        onPressed: onDelete,
      );
}

class _Description extends StatelessWidget {
  const _Description({required this.name, required this.category});

  final String name;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: AppTypography.bodyLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xxs),
        _CategoryChip(label: category),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.borderWidth,
      ),
      decoration: const BoxDecoration(
        color: AppColors.backgroundTertiary,
        borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusCard)),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
