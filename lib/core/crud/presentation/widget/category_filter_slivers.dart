import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/theme/app_breakpoints.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/widgets/status_message.dart';

/// Category chips above the items: all of them, or only those of the
/// chosen category, built by [sliversOf]. A category without items shows
/// an empty state. The filter lives in the screen only.
class CategoryFilterSlivers<T extends CategorizedItem<C>, C extends Enum>
    extends StatefulWidget {
  const CategoryFilterSlivers({
    required this.items,
    required this.categoryLabels,
    required this.sliversOf,
    super.key,
  });

  final List<T> items;
  final Map<C, String> categoryLabels;
  final List<Widget> Function(List<T> visible) sliversOf;

  @override
  State<CategoryFilterSlivers<T, C>> createState() =>
      _CategoryFilterSliversState<T, C>();
}

class _CategoryFilterSliversState<T extends CategorizedItem<C>, C extends Enum>
    extends State<CategoryFilterSlivers<T, C>> {
  C? _selected;

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
    final visible = selected == null
        ? widget.items
        : widget.items.where((item) => item.category == selected).toList();
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(child: _chips()),
        if (visible.isEmpty)
          SliverToBoxAdapter(child: _emptyCategory(selected!))
        else
          ...widget.sliversOf(visible),
      ],
    );
  }

  /// One scrolling row on mobile; from tablet up the chips wrap so every
  /// one stays reachable without horizontal scrolling.
  Widget _chips() {
    final chips = [
      _chip(null, CrudTexts.allCategories),
      for (final MapEntry(key: category, value: label)
          in widget.categoryLabels.entries)
        _chip(category, label),
    ];
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Semantics(
        container: true,
        label: CrudTexts.categoryFilterLabel,
        child: LayoutBuilder(
          builder: (context, constraints) =>
              ScreenSize.fromWidth(constraints.maxWidth) == ScreenSize.mobile
                  ? _ChipRow(chips: chips)
                  : _ChipWrap(chips: chips),
        ),
      ),
    );
  }

  Widget _chip(C? category, String label) {
    final selected = _selected == category;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: AppColors.brandPrimary,
      checkmarkColor: AppColors.textOnBrand,
      labelStyle: AppTypography.bodyMedium.copyWith(
        color: selected ? AppColors.textOnBrand : AppColors.textPrimary,
      ),
      onSelected: (_) => setState(() => _selected = category),
    );
  }

  Widget _emptyCategory(C category) => StatusMessage(
        icon: Icons.filter_alt_off_outlined,
        title: '${CrudTexts.emptyCategoryPrefix} '
            '${widget.categoryLabels[category] ?? category.name}',
        message: CrudTexts.emptyCategoryMessage,
      );
}

/// Chips in one horizontally scrolling row.
class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.chips});

  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final chip in chips)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: chip,
            ),
        ],
      ),
    );
  }
}

/// Chips wrapped onto as many lines as they need.
class _ChipWrap extends StatelessWidget {
  const _ChipWrap({required this.chips});

  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: chips,
    );
  }
}
