import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/crud/data/crud_remote_data_source.dart';
import 'package:pennypincher_pro/core/crud/data/item_json_codec.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/liability_entity.dart';

/// Keys of the liability JSON that are specific to liabilities.
abstract final class LiabilityJsonKeys {
  static const String currentBalance = 'currentBalance';
}

/// JSON shape of a liability: `{id, name, currentBalance, category}`.
const CategorizedJsonCodec<Liability, LiabilityCategory> liabilityJsonCodec =
    CategorizedJsonCodec(
  amountKey: LiabilityJsonKeys.currentBalance,
  categories: LiabilityCategory.values,
  fallbackCategory: LiabilityCategory.other,
  build: _liability,
);

Liability _liability(String id, CategorizedDraft<LiabilityCategory> fields) =>
    Liability(
      id: id,
      name: fields.name,
      currentBalance: fields.amount,
      category: fields.category,
    );

/// `/liabilities` endpoints, called with the authenticated client.
@lazySingleton
class LiabilityRemoteDataSource extends CrudRemoteDataSource<Liability,
    CategorizedDraft<LiabilityCategory>> {
  LiabilityRemoteDataSource(super.dio)
      : super(path: ApiPaths.liabilities, codec: liabilityJsonCodec);
}
