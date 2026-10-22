import 'package:equatable/equatable.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

/// The items of one category, sorted by name, with their subtotal.
final class ItemGroup<T extends CategorizedItem<C>, C extends Enum>
    extends Equatable {
  const ItemGroup({required this.category, required this.items});

  final C category;
  final List<T> items;

  Money get subtotal => sumMoney(items, (item) => item.amount);

  @override
  List<Object?> get props => [category, items];

  /// Groups [items] in the order of [categories], skipping empty ones.
  static List<ItemGroup<T, C>>
      byCategory<T extends CategorizedItem<C>, C extends Enum>(
    Iterable<T> items,
    List<C> categories,
  ) =>
          [
            for (final category in categories)
              if (items.any((item) => item.category == category))
                ItemGroup<T, C>(
                  category: category,
                  items: _sortedByName(
                    items.where((item) => item.category == category),
                  ),
                ),
          ];

  static List<T> _sortedByName<T extends CategorizedItem<Enum>>(
    Iterable<T> items,
  ) =>
      items.toList()
        ..sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
}

/// Sum of the amounts of every item.
Money totalOf<T extends CategorizedItem<Enum>>(Iterable<T> items) =>
    sumMoney(items, (item) => item.amount);
