import 'package:equatable/equatable.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

/// An entry of a user-managed list that has a name, a category and an
/// amount, such as an asset or a liability.
abstract interface class CategorizedItem<C extends Enum> {
  String get id;
  String get name;
  Money get amount;
  C get category;
}

/// The editable fields of a [CategorizedItem], sent to create or update it.
final class ItemDraft<C extends Enum> extends Equatable {
  const ItemDraft({
    required this.name,
    required this.amount,
    required this.category,
  });

  /// Same limit as the `name` column of the backend.
  static const int nameMaxLength = 150;

  final String name;
  final Money amount;
  final C category;

  @override
  List<Object?> get props => [name, amount, category];
}
