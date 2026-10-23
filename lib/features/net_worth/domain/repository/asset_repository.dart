import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_repository.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';

/// The user's assets.
abstract interface class AssetRepository
    implements CrudRepository<Asset, CategorizedDraft<AssetCategory>> {}
