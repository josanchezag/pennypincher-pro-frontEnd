import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/item_group.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_sections.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_tile.dart';
import 'package:pennypincher_pro/core/theme/app_breakpoints.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/core/widgets/status_message.dart';

/// Loaded content of a list screen: header, total card and the items
/// grouped by category, or an empty state. One column on mobile, two from
/// tablet up.
class CrudListView<T extends CategorizedItem<C>, C extends Enum>
    extends StatelessWidget {
  const CrudListView({
    required this.config,
    required this.items,
    required this.busy,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  static const int wideColumns = 2;

  /// Room under the last tile so the add button never covers it.
  static const double bottomInset = AppSpacing.xxxl + AppSpacing.xl;

  final CrudScreenConfig<C> config;
  final List<T> items;
  final bool busy;
  final ValueChanged<T> onEdit;
  final ValueChanged<T> onDelete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              bottomInset,
            ),
            sliver: SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(child: _header()),
                ..._content(_columnsFor(constraints.maxWidth)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static int _columnsFor(double width) =>
      ScreenSize.fromWidth(width) == ScreenSize.mobile ? 1 : wideColumns;

  Widget _header() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TitleRow(config: config),
          const SizedBox(height: AppSpacing.md),
          StatCard(
            label: config.totalLabel,
            value: CurrencyFormatter.format(totalOf(items)),
            icon: config.totalIcon,
            valueColor: config.totalColor,
          ),
          SizedBox(
            height: AppSpacing.xxs,
            child: busy ? const LinearProgressIndicator() : null,
          ),
        ],
      );

  List<Widget> _content(int columns) {
    if (items.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: StatusMessage(
            icon: config.emptyIcon,
            title: config.emptyTitle,
            message: config.emptyMessage,
          ),
        ),
      ];
    }
    return ItemSections.build<T, C>(
      groups: ItemGroup.byCategory<T, C>(items, config.categories),
      labelOf: config.labelOf,
      columns: columns,
      tileBuilder: _tile,
    );
  }

  Widget _tile(BuildContext context, T item) => ItemTile(
        name: item.name,
        categoryLabel: config.labelOf(item.category),
        amount: CurrencyFormatter.format(item.amount),
        amountColor: config.totalColor,
        deleteTooltip: config.deleteTooltip(item.name),
        onTap: busy ? null : () => onEdit(item),
        onDelete: busy ? null : () => onDelete(item),
      );
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.config});

  final CrudScreenConfig<Enum> config;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: config.backTooltip,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(config.parent.name),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Semantics(
            header: true,
            child: Text(config.title, style: AppTypography.heading1),
          ),
        ),
      ],
    );
  }
}
