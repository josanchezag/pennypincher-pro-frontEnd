import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';

part 'income_source_entity.freezed.dart';

/// Kinds of recurring income, in the order the backend lists them.
enum IncomeCategory {
  employment,
  rental,
  business,
  investment,
  freelance,
  other
}

/// A recurring income stream with its monthly amount in pesos.
@freezed
class IncomeSource
    with _$IncomeSource
    implements CategorizedItem<IncomeCategory> {
  const factory IncomeSource({
    required String id,
    required String name,
    required Money amount,
    required IncomeCategory category,
  }) = _IncomeSource;
}
