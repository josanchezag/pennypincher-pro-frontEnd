import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/item_layout.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';

/// Everything that changes between two list screens: texts, the parent
/// screen and the [layout] of the items of type [T], edited through drafts
/// of type [D].
class CrudScreenConfig<T extends CrudItem, D> {
  const CrudScreenConfig({
    required this.route,
    required this.parent,
    required this.itemNoun,
    required this.emptyIcon,
    required this.emptyMessage,
    required this.layout,
  });

  /// Screen being configured; its title heads the screen.
  final AppRoute route;

  /// Screen the back button returns to.
  final AppRoute parent;

  /// Lower-case singular name of an item, such as `asset`.
  final LocalizedText itemNoun;

  final IconData emptyIcon;
  final LocalizedText emptyMessage;

  /// Form fields, summary and list of the items.
  final ItemLayout<T, D> layout;

  String title(AppLocalizations l10n) => route.title(l10n);

  String backTooltip(AppLocalizations l10n) =>
      l10n.commonBackTo(parent.title(l10n));

  String addLabel(AppLocalizations l10n) => l10n.crudAdd(itemNoun(l10n));

  String editTitle(AppLocalizations l10n) => l10n.crudEdit(itemNoun(l10n));

  String deleteTitle(AppLocalizations l10n) =>
      l10n.crudDeleteTitle(itemNoun(l10n));

  String emptyTitle(AppLocalizations l10n) =>
      l10n.crudEmptyTitle(title(l10n).toLowerCase());

  String deleteTooltip(AppLocalizations l10n, String name) =>
      l10n.crudDeleteTooltip(name);

  String deleteMessage(AppLocalizations l10n, String name) =>
      l10n.crudDeleteMessage(name);
}
