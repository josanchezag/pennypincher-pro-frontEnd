import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';
import 'package:pennypincher_pro/core/utils/api_enum.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

/// Keys shared by every categorized item of the API.
abstract final class ItemJsonKeys {
  static const String id = 'id';
  static const String name = 'name';
  static const String category = 'category';
}

/// JSON shape of a categorized item: `{id, name, <amountKey>, category}`.
/// Only the name of the amount field and the categories change between
/// resources, so one codec serves all of them.
class ItemJsonCodec<T extends CategorizedItem<C>, C extends Enum> {
  const ItemJsonCodec({
    required this.amountKey,
    required this.categories,
    required this.fallbackCategory,
    required this.build,
  });

  final String amountKey;
  final List<C> categories;

  /// Category given to a value this client does not know yet.
  final C fallbackCategory;

  /// Creates the entity with [id] from the parsed fields.
  final T Function(String id, ItemDraft<C> fields) build;

  /// Throws [TypeError] or [FormatException] on an unexpected shape.
  T fromJson(JsonMap json) => build(
        json[ItemJsonKeys.id] as String,
        ItemDraft(
          name: json[ItemJsonKeys.name] as String,
          amount: Money.fromJson(json[amountKey]),
          category: ApiEnum.parse(
            categories,
            json[ItemJsonKeys.category],
            fallback: fallbackCategory,
          ),
        ),
      );

  JsonMap toJson(ItemDraft<C> draft) => {
        ItemJsonKeys.name: draft.name,
        amountKey: draft.amount.toJson(),
        ItemJsonKeys.category: ApiEnum.nameOf(draft.category),
      };
}
