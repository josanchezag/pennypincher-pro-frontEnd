import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/item_group.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_tile.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';

/// Builds the tile of one item.
typedef ItemTileBuilder<T> = Widget Function(BuildContext context, T item);

/// Slivers of the items grouped by category: a subheader with the category
/// subtotal, then a list (one column) or a grid of [columns] tiles.
abstract final class ItemSections {
  static List<Widget> build<T extends CategorizedItem<C>, C extends Enum>({
    required List<ItemGroup<T, C>> groups,
    required String Function(C category) labelOf,
    required int columns,
    required ItemTileBuilder<T> tileBuilder,
  }) =>
      [
        for (final group in groups) ...[
          SliverToBoxAdapter(
            child: _GroupHeader(
              label: labelOf(group.category),
              subtotal: CurrencyFormatter.format(group.subtotal),
            ),
          ),
          _tiles(group.items, columns, tileBuilder),
        ],
      ];

  static Widget _tiles<T>(
    List<T> items,
    int columns,
    ItemTileBuilder<T> tileBuilder,
  ) {
    if (columns == 1) {
      return SliverList.separated(
        itemCount: items.length,
        itemBuilder: (context, index) => tileBuilder(context, items[index]),
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
      );
    }
    return SliverGrid.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisExtent: ItemTile.height,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.xs,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => tileBuilder(context, items[index]),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.label, required this.subtotal});

  final String label;
  final String subtotal;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      label: '$label, $subtotal',
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.lg,
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
