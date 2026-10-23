import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/item_layout.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_form_fields.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_sections.dart';
import 'package:pennypincher_pro/core/crud/presentation/widget/item_tile.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
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

/// Label of the optional amount a balance started from, such as the
/// original amount of a loan, and how to [read] it from an item.
class OriginalAmountStyle<T> {
  const OriginalAmountStyle({required this.label, required this.read});

  final String label;
  final Money? Function(T item) read;
}

/// Layout of items with a monthly amount and a balance: a list sorted by
/// name whose tiles show the balance on the right and the monthly amount
/// under the name, and two summary cards with both totals. With an
/// [original] amount, the form asks for it and the tiles show how much of
/// it is already paid.
class BalanceLayout<T extends BalanceItem> extends ItemLayout<T, BalanceDraft> {
  const BalanceLayout({
    required this.monthly,
    required this.balance,
    this.original,
    this.balanceFirst = false,
    this.summaryAtBottom = false,
  });

  static const String monthlyAmount = 'monthlyAmount';
  static const String balanceAmount = 'balance';
  static const String originalAmount = 'originalAmount';
  static const int _percent = 100;

  final BalanceAmountStyle monthly;
  final BalanceAmountStyle balance;

  /// Optional amount the balance started from; null when not tracked.
  final OriginalAmountStyle<T>? original;

  /// Whether the balance comes before the monthly amount in the form and
  /// the summary, for lists where it matters most, such as savings.
  final bool balanceFirst;

  @override
  final bool summaryAtBottom;

  @override
  FormGroup formGroup(T? initial) => FormGroup({
        ItemFormFields.name: ItemFormFields.nameControl(initial?.name),
        monthlyAmount: ItemFormFields.amountControl(initial?.monthlyAmount),
        balanceAmount: ItemFormFields.amountControl(initial?.balance),
        if (original case final original?)
          originalAmount: ItemFormFields.optionalAmountControl(
            initial == null ? null : original.read(initial),
          ),
      });

  @override
  List<Widget> formFields() => [
        ItemFormFields.nameField(),
        ..._ordered(
          ItemFormFields.amountField(monthlyAmount, monthly.label),
          ItemFormFields.amountField(balanceAmount, balance.label),
        ),
        if (original case final original?)
          ItemFormFields.amountField(
            originalAmount,
            original.label,
            optional: true,
          ),
      ];

  @override
  BalanceDraft draftOf(FormGroup form) => BalanceDraft(
        name: ItemFormFields.nameOf(form),
        monthlyAmount: ItemFormFields.amountOf(form, monthlyAmount),
        balance: ItemFormFields.amountOf(form, balanceAmount),
        originalAmount: original == null
            ? null
            : ItemFormFields.optionalAmountOf(form, originalAmount),
      );

  @override
  Widget summary(List<T> items) => ResponsiveCardRow(
        children: _ordered(
          _totalCard(monthly, sumMoney(items, (item) => item.monthlyAmount)),
          _totalCard(balance, sumMoney(items, (item) => item.balance)),
        ),
      );

  @override
  double get tileHeight =>
      original == null ? ItemTile.compactHeight : ItemTile.footerHeight;

  @override
  ItemTileContent tileContent(T item) => ItemTileContent(
        details: LabeledAmount(
          label: monthly.label,
          amount: CurrencyFormatter.format(item.monthlyAmount),
        ),
        amount: CurrencyFormatter.format(item.balance),
        amountColor: balance.color,
        footer: _progress(item),
      );

  /// How much of the original amount is paid, when it is tracked.
  Widget? _progress(T item) {
    final share = paidShare(
      balance: item.balance,
      originalAmount: original?.read(item),
    );
    return share == null
        ? null
        : ShareProgress(
            share: share,
            label: '${PercentFormatter.format(share * _percent)} '
                '${CrudTexts.paidSuffix}',
          );
  }

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

  List<Widget> _ordered(Widget monthlyWidget, Widget balanceWidget) =>
      balanceFirst
          ? [balanceWidget, monthlyWidget]
          : [monthlyWidget, balanceWidget];

  static Widget _totalCard(BalanceAmountStyle style, Money total) => StatCard(
        label: style.totalLabel,
        value: CurrencyFormatter.format(total),
        icon: style.icon,
        valueColor: style.color,
      );
}
