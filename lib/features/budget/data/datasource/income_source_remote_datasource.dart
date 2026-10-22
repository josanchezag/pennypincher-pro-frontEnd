import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/crud/data/crud_remote_data_source.dart';
import 'package:pennypincher_pro/core/crud/data/item_json_codec.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';

/// Keys of the income source JSON that are specific to income sources.
abstract final class IncomeSourceJsonKeys {
  static const String amount = 'amount';
}

/// JSON shape of an income source: `{id, name, amount, category}`. The
/// optional `currency` is left to the backend default (COP).
const ItemJsonCodec<IncomeSource, IncomeCategory> incomeSourceJsonCodec =
    ItemJsonCodec(
  amountKey: IncomeSourceJsonKeys.amount,
  categories: IncomeCategory.values,
  fallbackCategory: IncomeCategory.other,
  build: _incomeSource,
);

IncomeSource _incomeSource(String id, ItemDraft<IncomeCategory> fields) =>
    IncomeSource(
      id: id,
      name: fields.name,
      amount: fields.amount,
      category: fields.category,
    );

/// `/income-sources` endpoints, called with the authenticated client.
@lazySingleton
class IncomeSourceRemoteDataSource
    extends CrudRemoteDataSource<IncomeSource, IncomeCategory> {
  IncomeSourceRemoteDataSource(super.dio)
      : super(path: ApiPaths.incomeSources, codec: incomeSourceJsonCodec);
}
