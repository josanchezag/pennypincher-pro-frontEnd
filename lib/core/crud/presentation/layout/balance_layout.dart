import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/item_layout.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_fields.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_sections.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_tile.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/responsive_card_row.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Texts, icon and color of one of the two amounts of a [BalanceItem].
class BalanceAmountStyle {
  const BalanceAmountStyle({
    required this.label,
    required this.totalLabel,
    required this.icon,
    required this.color,
  });

  /// Label of the field and of the amount in a tile.
  final String label;

  /// Label of the summary card with the sum of the amounts.
  final String totalLabel;
  final IconData icon;
  final Color color;
}

/// Layout of items with a monthly amount and a balance: a list sorted by
/// name whose tiles show the balance on the right and the monthly amount
/// under the name, and two summary cards with both totals.
class BalanceLayout<T extends BalanceItem> extends ItemLayout<T, BalanceDraft> {
  const BalanceLayout({
    required this.monthly,
    required this.balance,
    this.summaryAtBottom = false,
  });

  static const String monthlyAmount = 'monthlyAmount';
  static const String balanceAmount = 'balance';

  final BalanceAmountStyle monthly;
  final BalanceAmountStyle balance;

  @override
  final bool summaryAtBottom;

  @override
  FormGroup formGroup(T? initial) => FormGroup({
        ItemFormFields.name: ItemFormFields.nameControl(initial?.name),
        monthlyAmount: ItemFormFields.amountControl(initial?.monthlyAmount),
        balanceAmount: ItemFormFields.amountControl(initial?.balance),
      });

  @override
  List<Widget> formFields() => [
        ItemFormFields.nameField(),
        ItemFormFields.amountField(monthlyAmount, monthly.label),
        ItemFormFields.amountField(balanceAmount, balance.label),
      ];

  @override
  BalanceDraft draftOf(FormGroup form) => BalanceDraft(
        name: ItemFormFields.nameOf(form),
        monthlyAmount: ItemFormFields.amountOf(form, monthlyAmount),
        balance: ItemFormFields.amountOf(form, balanceAmount),
      );

  @override
  Widget summary(List<T> items) => ResponsiveCardRow(
        children: [
          _totalCard(monthly, sumMoney(items, (item) => item.monthlyAmount)),
          _totalCard(balance, sumMoney(items, (item) => item.balance)),
        ],
      );

  @override
  double get tileHeight => ItemTile.compactHeight;

  @override
  ItemTileContent tileContent(T item) => ItemTileContent(
        details: LabeledAmount(
          label: monthly.label,
          amount: CurrencyFormatter.format(item.monthlyAmount),
        ),
        amount: CurrencyFormatter.format(item.balance),
        amountColor: balance.color,
      );

  @override
  List<Widget> itemSlivers({
    required List<T> items,
    required int columns,
    required ItemTileBuilder<T> tile,
  }) =>
      [
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
        ItemSections.tiles(sortedByName(items), columns, tileHeight, tile),
      ];

  static Widget _totalCard(BalanceAmountStyle style, Money total) => StatCard(
        label: style.totalLabel,
        value: CurrencyFormatter.format(total),
        icon: style.icon,
        valueColor: style.color,
      );
}
