import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/item_layout.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';

/// Card of one list item: its name, the [content] given by the item
/// layout, and a delete button. Tapping it edits the item; swiping it to
/// the left or pressing the button deletes it.
class ItemTile extends StatelessWidget {
  const ItemTile({
    required this.dismissKey,
    required this.name,
    required this.content,
    required this.height,
    required this.deleteTooltip,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  /// Minimum height of a tile with a one-line name and one line of
  /// details. Tiles grow when the name wraps or the text is scaled.
  static const double compactHeight = 76;

  /// Minimum height of a tile that also has a footer.
  static const double footerHeight = 100;

  /// Room for the second line of a wrapped name, and for the amount when
  /// it moves under the name.
  static const double lineHeight = 24;

  /// Narrower tiles show the amount under the name, so the name keeps
  /// enough room to tell similar items apart.
  static const double stackBelowWidth = 420;

  static bool stacksAt(double width) => width < stackBelowWidth;

  /// Height of every tile of [width] in a grid row, where tiles cannot
  /// grow: [height] plus a wrapped name and a stacked amount, scaled with
  /// the text.
  static double gridExtent(BuildContext context, double height, double width) {
    final lines = stacksAt(width) ? 2 : 1;
    return MediaQuery.textScalerOf(context).scale(height + lines * lineHeight);
  }

  /// Identifies the item for the swipe gesture.
  final Key dismissKey;
  final String name;
  final ItemTileContent content;

  /// Minimum height; the grid gives its tiles [gridExtent] instead.
  final double height;
  final String deleteTooltip;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => _tile(stacksAt(constraints.maxWidth)),
    );
  }

  Widget _tile(bool stacked) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: IntrinsicHeight(
        child: Dismissible(
          key: dismissKey,
          direction: onDelete == null
              ? DismissDirection.none
              : DismissDirection.endToStart,
          background: const _SwipeBackground(),
          confirmDismiss: _confirmDismiss,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: MergeSemantics(child: _editArea(stacked))),
                Center(child: _deleteButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Asks for confirmation through [onDelete]; the item leaves the list
  /// once the deletion succeeds, so the tile itself always slides back.
  Future<bool> _confirmDismiss(DismissDirection _) async {
    onDelete?.call();
    return false;
  }

  /// Name and amount on top and the details under them, read as one
  /// button by screen readers.
  Widget _editArea(bool stacked) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.md,
            top: AppSpacing.xs,
            bottom: AppSpacing.xs,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NameAndAmount(name: name, content: content, stacked: stacked),
              const SizedBox(height: AppSpacing.xxs),
              content.details,
              if (content.footer != null) ...[
                const SizedBox(height: AppSpacing.xs),
                content.footer!,
              ],
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

/// The name, on up to two lines so similar names stay distinguishable,
/// next to the main amount or, when [stacked], above it.
class _NameAndAmount extends StatelessWidget {
  const _NameAndAmount({
    required this.name,
    required this.content,
    required this.stacked,
  });

  static const int nameMaxLines = 2;

  final String name;
  final ItemTileContent content;
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final nameText = Text(
      name,
      style: AppTypography.bodyLarge,
      maxLines: nameMaxLines,
      overflow: TextOverflow.ellipsis,
    );
    final amount = Text(
      content.amount,
      style: AppTypography.monoMedium.copyWith(color: content.amountColor),
    );
    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [nameText, amount],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: nameText),
        const SizedBox(width: AppSpacing.xs),
        amount,
      ],
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.errorMuted,
        borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusCard)),
      ),
      child: const Icon(Icons.delete_outline, color: AppColors.textPrimary),
    );
  }
}

/// Category of an item, as a small upper-case chip.
class CategoryLabel extends StatelessWidget {
  const CategoryLabel({required this.label, super.key});

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

/// A secondary amount of an item with its label, such as
/// `Monthly payment $ 1.200.000`.
class LabeledAmount extends StatelessWidget {
  const LabeledAmount({required this.label, required this.amount, super.key});

  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '$label ', style: AppTypography.bodySmall),
          TextSpan(text: amount, style: AppTypography.monoSmall),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Progress bar of the share of something already done, such as a debt
/// paid off, followed by [label] (`45,0 % paid`). Screen readers only read
/// the label, since the bar repeats it.
class ShareProgress extends StatelessWidget {
  const ShareProgress({required this.share, required this.label, super.key});

  static const double barHeight = 6;

  /// From 0 to 1.
  final double share;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ExcludeSemantics(
            child: LinearProgressIndicator(
              value: share,
              minHeight: barHeight,
              color: AppColors.success,
              backgroundColor: AppColors.backgroundTertiary,
              borderRadius: const BorderRadius.all(Radius.circular(barHeight)),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: AppTypography.monoSmall),
      ],
    );
  }
}
