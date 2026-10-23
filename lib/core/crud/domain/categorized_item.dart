import 'package:equatable/equatable.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

/// A [CrudItem] with one amount and a category, such as an asset, an
/// income source or a fixed expense.
abstract interface class CategorizedItem<C extends Enum> implements CrudItem {
  Money get amount;
  C get category;
}

/// The editable fields of a [CategorizedItem], sent to create or update it.
final class CategorizedDraft<C extends Enum> extends Equatable {
  const CategorizedDraft({
    required this.name,
    required this.amount,
    required this.category,
  });

  final String name;
  final Money amount;
  final C category;

  @override
  List<Object?> get props => [name, amount, category];
}
