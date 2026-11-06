import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/item_group.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/item_layout.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/category_filter_slivers.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_fields.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_sections.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_tile.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Layout of items with one amount and a category: a total card on top
/// and the items grouped by category with their subtotals, optionally
/// [filterable] by category with chips.
class CategorizedLayout<T extends CategorizedItem<C>, C extends Enum>
    extends ItemLayout<T, CategorizedDraft<C>> {
  const CategorizedLayout({
    required this.amountLabel,
    required this.totalLabel,
    required this.totalIcon,
    required this.totalColor,
    required this.categoryLabels,
    this.filterable = false,
  });

  static const String amount = 'amount';
  static const String category = 'category';

  /// Label of the amount field, such as `Value` or `Monthly amount`.
  final LocalizedText amountLabel;
  final LocalizedText totalLabel;
  final IconData totalIcon;
  final Color totalColor;

  /// Display name of every category, in display order.
  final Map<C, LocalizedText> categoryLabels;

  /// Whether chips above the list show the items of one category only.
  final bool filterable;

  List<C> get categories => categoryLabels.keys.toList();

  String labelOf(AppLocalizations l10n, C category) =>
      categoryLabels[category]?.call(l10n) ?? category.name;

  /// Display name of every category in the language of [l10n].
  Map<C, String> labels(AppLocalizations l10n) => {
        for (final MapEntry(key: category, value: label)
            in categoryLabels.entries)
          category: label(l10n),
      };

  @override
  FormGroup formGroup(T? initial) => FormGroup({
        ItemFormFields.name: ItemFormFields.nameControl(initial?.name),
        amount: ItemFormFields.amountControl(initial?.amount),
        category: ItemFormFields.categoryControl<C>(initial?.category),
      });

  @override
  List<Widget> formFields(AppLocalizations l10n) => [
        ItemFormFields.nameField(),
        ItemFormFields.amountField(amount, amountLabel(l10n)),
        ItemFormFields.categoryField<C>(category, labels(l10n)),
      ];

  @override
  CategorizedDraft<C> draftOf(FormGroup form) => CategorizedDraft(
        name: ItemFormFields.nameOf(form),
        amount: ItemFormFields.amountOf(form, amount),
        category: form.control(category).value as C,
      );

  @override
  Widget summary(
    AppLocalizations l10n,
    MoneyFormatter money,
    List<T> items,
  ) =>
      StatCard(
        label: totalLabel(l10n),
        value: money.format(totalOf(items)),
        icon: totalIcon,
        valueColor: totalColor,
      );

  @override
  double get tileHeight => ItemTile.compactHeight;

  @override
  ItemTileContent tileContent(
    AppLocalizations l10n,
    MoneyFormatter money,
    T item,
  ) =>
      ItemTileContent(
        details: CategoryLabel(label: labelOf(l10n, item.category)),
        amount: money.format(item.amount),
        amountColor: totalColor,
      );

  @override
  List<Widget> itemSlivers({
    required AppLocalizations l10n,
    required List<T> items,
    required int columns,
    required ItemTileBuilder<T> tile,
  }) =>
      filterable
          ? [
              CategoryFilterSlivers<T, C>(
                items: items,
                categoryLabels: labels(l10n),
                sliversOf: (visible) => _groups(l10n, visible, columns, tile),
              ),
            ]
          : _groups(l10n, items, columns, tile);

  List<Widget> _groups(
    AppLocalizations l10n,
    List<T> items,
    int columns,
    ItemTileBuilder<T> tile,
  ) =>
      ItemSections.grouped<T, C>(
        groups: ItemGroup.byCategory<T, C>(items, categories),
        labelOf: (category) => labelOf(l10n, category),
        columns: columns,
        tileHeight: tileHeight,
        tileBuilder: tile,
      );
}
