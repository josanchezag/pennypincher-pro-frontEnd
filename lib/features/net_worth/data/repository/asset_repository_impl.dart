import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/data/crud_repository_impl.dart';
import 'package:pennypincher_pro/features/net_worth/data/datasource/asset_remote_datasource.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/repository/asset_repository.dart';

@LazySingleton(as: AssetRepository)
class AssetRepositoryImpl extends CrudRepositoryImpl<Asset, AssetCategory>
    implements AssetRepository {
  AssetRepositoryImpl(AssetRemoteDataSource super.remote);
}
