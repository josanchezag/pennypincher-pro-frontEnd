import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/item_layout.dart';
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
  final String itemNoun;

  final IconData emptyIcon;
  final String emptyMessage;

  /// Form fields, summary and list of the items.
  final ItemLayout<T, D> layout;

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

/// Fixed texts of the list screens.
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
      'Use at most ${CrudItem.nameMaxLength} characters.';
  static const String amountRequired = 'Enter an amount.';
  static const String amountInvalid =
      'Enter an amount like 1.500.000 or 1.500.000,50, up to 13 digits.';
  static const String amountHelper = 'Example: 1.500.000 or 1.500.000,50';
  static const String saving = 'Saving';
  static const String categoryRequired = 'Choose a category.';
  static const String amountPrefix = r'$ ';
}
