import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';

/// Everything that changes between two list screens of categorized items:
/// texts, colors, categories and the parent screen.
class CrudScreenConfig<C extends Enum> {
  const CrudScreenConfig({
    required this.route,
    required this.parent,
    required this.itemNoun,
    required this.amountLabel,
    required this.totalLabel,
    required this.totalIcon,
    required this.totalColor,
    required this.emptyIcon,
    required this.emptyMessage,
    required this.categoryLabels,
  });

  /// Screen being configured; its title heads the screen.
  final AppRoute route;

  /// Screen the back button returns to.
  final AppRoute parent;

  /// Lower-case singular name of an item, such as `asset`.
  final String itemNoun;

  /// Label of the amount field, such as `Value` or `Current balance`.
  final String amountLabel;

  final String totalLabel;
  final IconData totalIcon;
  final Color totalColor;
  final IconData emptyIcon;
  final String emptyMessage;

  /// Display name of every category, in display order.
  final Map<C, String> categoryLabels;

  List<C> get categories => categoryLabels.keys.toList();

  String labelOf(C category) => categoryLabels[category] ?? category.name;

  String get title => route.title;

  String get backTooltip => '${CrudTexts.backPrefix} ${parent.title}';

  String get addLabel => '${CrudTexts.add} $itemNoun';

  String get editTitle => '${CrudTexts.edit} $itemNoun';

  String get deleteTitle => '${CrudTexts.delete} $itemNoun?';

  String get emptyTitle => '${CrudTexts.emptyPrefix} ${title.toLowerCase()}';

  String deleteTooltip(String name) => '${CrudTexts.delete} $name';

  String deleteMessage(String name) =>
      '"$name" ${CrudTexts.deleteMessageSuffix}';
}

/// Fixed texts of the list screens of categorized items.
abstract final class CrudTexts {
  static const String add = 'Add';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String save = 'Save';
  static const String retry = 'Retry';
  static const String backPrefix = 'Back to';
  static const String emptyPrefix = 'No';
  static const String loadErrorTitle = 'Could not load the list';
  static const String loadingLabel = 'Loading list';
  static const String deleteMessageSuffix =
      'will be removed from your list and no longer counted in your totals.';
  static const String nameLabel = 'Name';
  static const String categoryLabel = 'Category';
  static const String nameRequired = 'Enter a name.';
  static const String nameTooLong =
      'Use at most ${ItemDraft.nameMaxLength} characters.';
  static const String amountRequired = 'Enter an amount.';
  static const String amountInvalid =
      'Enter an amount like 1.500.000 or 1.500.000,50, up to 13 digits.';
  static const String amountHelper = 'Example: 1.500.000 or 1.500.000,50';
  static const String saving = 'Saving';
  static const String categoryRequired = 'Choose a category.';
  static const String amountPrefix = r'$ ';
}
