import 'package:flutter/widgets.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Builds the tile of one item.
typedef ItemTileBuilder<T> = Widget Function(BuildContext context, T item);

/// What a tile shows under the name of its item, and on its right.
class ItemTileContent {
  const ItemTileContent({
    required this.details,
    required this.amount,
    required this.amountColor,
    this.footer,
  });

  /// Line under the name, such as the category or a monthly amount.
  final Widget details;

  /// Formatted main amount of the item.
  final String amount;
  final Color amountColor;

  /// Optional row under the tile content, such as a progress bar.
  final Widget? footer;
}

/// What changes between list screens for one shape of item [T], edited
/// through drafts of type [D]: the form, the summary cards and how the
/// items are laid out. The generic screen, list, tile and form sheet of
/// `core/crud` take everything else from it.
abstract class ItemLayout<T extends CrudItem, D> {
  const ItemLayout();

  /// Controls of the form, filled with [initial] when it is being edited.
  FormGroup formGroup(T? initial);

  /// Fields of the form, top to bottom.
  List<Widget> formFields();

  /// Draft read from a valid [form].
  D draftOf(FormGroup form);

  /// Cards with the totals of [items].
  Widget summary(List<T> items);

  /// Whether the [summary] goes under the items instead of above them.
  bool get summaryAtBottom => false;

  /// Fixed height of every tile, so tiles line up in a grid.
  double get tileHeight;

  ItemTileContent tileContent(T item);

  /// Slivers that show the non-empty [items] in [columns], each with
  /// [tile].
  List<Widget> itemSlivers({
    required List<T> items,
    required int columns,
    required ItemTileBuilder<T> tile,
  });
}
