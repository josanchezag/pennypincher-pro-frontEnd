import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/crud/data/crud_remote_data_source.dart';
import 'package:pennypincher_pro/core/crud/data/item_json_codec.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';

/// Keys of the asset JSON that are specific to assets.
abstract final class AssetJsonKeys {
  static const String value = 'value';
}

/// JSON shape of an asset: `{id, name, value, category}`.
const CategorizedJsonCodec<Asset, AssetCategory> assetJsonCodec =
    CategorizedJsonCodec(
  amountKey: AssetJsonKeys.value,
  categories: AssetCategory.values,
  fallbackCategory: AssetCategory.other,
  build: _asset,
);

Asset _asset(String id, CategorizedDraft<AssetCategory> fields) => Asset(
      id: id,
      name: fields.name,
      value: fields.amount,
      category: fields.category,
    );

/// `/assets` endpoints, called with the authenticated client.
@lazySingleton
class AssetRemoteDataSource
    extends CrudRemoteDataSource<Asset, CategorizedDraft<AssetCategory>> {
  AssetRemoteDataSource(super.dio)
      : super(path: ApiPaths.assets, codec: assetJsonCodec);
}
