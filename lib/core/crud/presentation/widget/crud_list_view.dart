import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/item_layout.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_tile.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_breakpoints.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/widgets/screen_title_row.dart';
import 'package:pennypincher_pro/core/widgets/status_message.dart';

/// Loaded content of a list screen: header, summary and the items as the
/// config's layout arranges them, or an empty state. One column on
/// mobile, two from tablet up.
class CrudListView<T extends CrudItem, D> extends StatelessWidget {
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

  final CrudScreenConfig<T, D> config;
  final List<T> items;
  final bool busy;
  final ValueChanged<T> onEdit;
  final ValueChanged<T> onDelete;

  ItemLayout<T, D> get _layout => config.layout;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                SliverToBoxAdapter(child: _header(l10n)),
                ..._content(l10n, _columnsFor(constraints.maxWidth)),
                if (_layout.summaryAtBottom)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.lg),
                      child: _layout.summary(l10n, items),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static int _columnsFor(double width) =>
      ScreenSize.fromWidth(width) == ScreenSize.mobile ? 1 : wideColumns;

  Widget _header(AppLocalizations l10n) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ScreenTitleRow(
            title: config.title(l10n),
            backTooltip: config.backTooltip(l10n),
            parent: config.parent.name,
          ),
          if (!_layout.summaryAtBottom) ...[
            const SizedBox(height: AppSpacing.md),
            _layout.summary(l10n, items),
          ],
          SizedBox(
            height: AppSpacing.xxs,
            child: busy ? const LinearProgressIndicator() : null,
          ),
        ],
      );

  List<Widget> _content(AppLocalizations l10n, int columns) {
    if (items.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: StatusMessage(
            icon: config.emptyIcon,
            title: config.emptyTitle(l10n),
            message: config.emptyMessage(l10n),
          ),
        ),
      ];
    }
    return _layout.itemSlivers(
      l10n: l10n,
      items: items,
      columns: columns,
      tile: _tile,
    );
  }

  Widget _tile(BuildContext context, T item) => ItemTile(
        dismissKey: ValueKey(item.id),
        name: item.name,
        content: _layout.tileContent(context.l10n, item),
        height: _layout.tileHeight,
        deleteTooltip: config.deleteTooltip(context.l10n, item.name),
        onTap: busy ? null : () => onEdit(item),
        onDelete: busy ? null : () => onDelete(item),
      );
}
