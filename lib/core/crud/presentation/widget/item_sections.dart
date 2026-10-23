import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/item_group.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/item_layout.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_tile.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';

/// Slivers of list items: a list (one column) or a grid of tiles, and the
/// same grouped by category under subheaders with their subtotals.
abstract final class ItemSections {
  static List<Widget> grouped<T extends CategorizedItem<C>, C extends Enum>({
    required List<ItemGroup<T, C>> groups,
    required String Function(C category) labelOf,
    required int columns,
    required double tileHeight,
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
          tiles(group.items, columns, tileHeight, tileBuilder),
        ],
      ];

  static Widget tiles<T>(
    List<T> items,
    int columns,
    double tileHeight,
    ItemTileBuilder<T> tileBuilder,
  ) {
    if (columns == 1) {
      return SliverList.separated(
        itemCount: items.length,
        itemBuilder: (context, index) => tileBuilder(context, items[index]),
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
      );
    }
    return _grid(items, columns, tileHeight, tileBuilder);
  }

  /// Tiles in [columns]; every row gets the height a tile of that width
  /// needs.
  static Widget _grid<T>(
    List<T> items,
    int columns,
    double tileHeight,
    ItemTileBuilder<T> tileBuilder,
  ) =>
      SliverLayoutBuilder(
        builder: (context, constraints) {
          const spacing = AppSpacing.sm;
          final tileWidth =
              (constraints.crossAxisExtent - spacing * (columns - 1)) / columns;
          return SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisExtent:
                  ItemTile.gridExtent(context, tileHeight, tileWidth),
              crossAxisSpacing: spacing,
              mainAxisSpacing: AppSpacing.xs,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) => tileBuilder(context, items[index]),
          );
        },
      );
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
