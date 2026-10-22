import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/repository/asset_repository.dart';

/// Registers the net worth use cases, keeping the domain layer free of
/// dependency injection annotations.
@module
abstract class NetWorthModule {
  @injectable
  GetItems<Asset, AssetCategory> getAssets(AssetRepository repository) =>
      GetItems(repository);

  @injectable
  SaveItem<Asset, AssetCategory> saveAsset(AssetRepository repository) =>
      SaveItem(repository);

  @injectable
  DeleteItem<Asset, AssetCategory> deleteAsset(AssetRepository repository) =>
      DeleteItem(repository);
}
