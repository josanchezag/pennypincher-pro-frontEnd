import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/data/crud_repository_impl.dart';
import 'package:pennypincher_pro/features/net_worth/data/datasource/liability_remote_datasource.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/liability_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/repository/liability_repository.dart';

@LazySingleton(as: LiabilityRepository)
class LiabilityRepositoryImpl
    extends CrudRepositoryImpl<Liability, LiabilityCategory>
    implements LiabilityRepository {
  LiabilityRepositoryImpl(LiabilityRemoteDataSource super.remote);
}
