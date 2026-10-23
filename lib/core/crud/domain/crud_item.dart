/// An entry of a user-managed list, such as an asset or a credit card.
abstract interface class CrudItem {
  /// Same limit as the `name` column of the backend.
  static const int nameMaxLength = 150;

  String get id;
  String get name;
}

/// [items] sorted by name without regard to case, as the backend lists
/// them.
List<T> sortedByName<T extends CrudItem>(Iterable<T> items) => items.toList()
  ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
