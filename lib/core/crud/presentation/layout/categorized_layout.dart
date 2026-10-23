import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/item_group.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/item_layout.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_fields.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_sections.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_tile.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Layout of items with one amount and a category: a total card on top
/// and the items grouped by category with their subtotals.
class CategorizedLayout<T extends CategorizedItem<C>, C extends Enum>
    extends ItemLayout<T, CategorizedDraft<C>> {
  const CategorizedLayout({
    required this.amountLabel,
    required this.totalLabel,
    required this.totalIcon,
    required this.totalColor,
    required this.categoryLabels,
  });

  static const String amount = 'amount';
  static const String category = 'category';

  /// Label of the amount field, such as `Value` or `Monthly amount`.
  final String amountLabel;
  final String totalLabel;
  final IconData totalIcon;
  final Color totalColor;

  /// Display name of every category, in display order.
  final Map<C, String> categoryLabels;

  List<C> get categories => categoryLabels.keys.toList();

  String labelOf(C category) => categoryLabels[category] ?? category.name;

  @override
  FormGroup formGroup(T? initial) => FormGroup({
        ItemFormFields.name: ItemFormFields.nameControl(initial?.name),
        amount: ItemFormFields.amountControl(initial?.amount),
        category: ItemFormFields.categoryControl<C>(initial?.category),
      });

  @override
  List<Widget> formFields() => [
        ItemFormFields.nameField(),
        ItemFormFields.amountField(amount, amountLabel),
        ItemFormFields.categoryField<C>(category, categoryLabels),
      ];

  @override
  CategorizedDraft<C> draftOf(FormGroup form) => CategorizedDraft(
        name: ItemFormFields.nameOf(form),
        amount: ItemFormFields.amountOf(form, amount),
        category: form.control(category).value as C,
      );

  @override
  Widget summary(List<T> items) => StatCard(
        label: totalLabel,
        value: CurrencyFormatter.format(totalOf(items)),
        icon: totalIcon,
        valueColor: totalColor,
      );

  @override
  double get tileHeight => ItemTile.compactHeight;

  @override
  ItemTileContent tileContent(T item) => ItemTileContent(
        details: CategoryLabel(label: labelOf(item.category)),
        amount: CurrencyFormatter.format(item.amount),
        amountColor: totalColor,
      );

  @override
  List<Widget> itemSlivers({
    required List<T> items,
    required int columns,
    required ItemTileBuilder<T> tile,
  }) =>
      ItemSections.grouped<T, C>(
        groups: ItemGroup.byCategory<T, C>(items, categories),
        labelOf: labelOf,
        columns: columns,
        tileHeight: tileHeight,
        tileBuilder: tile,
      );
}
