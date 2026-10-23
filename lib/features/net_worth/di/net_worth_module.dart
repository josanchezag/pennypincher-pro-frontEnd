import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/liability_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/repository/asset_repository.dart';
import 'package:pennypincher_pro/features/net_worth/domain/repository/liability_repository.dart';
import 'package:pennypincher_pro/features/net_worth/domain/repository/net_worth_repository.dart';
import 'package:pennypincher_pro/features/net_worth/domain/usecase/net_worth_use_cases.dart';

/// Registers the net worth use cases, keeping the domain layer free of
/// dependency injection annotations.
@module
abstract class NetWorthModule {
  @injectable
  GetItems<Asset, CategorizedDraft<AssetCategory>> getAssets(
    AssetRepository repository,
  ) =>
      GetItems(repository);

  @injectable
  SaveItem<Asset, CategorizedDraft<AssetCategory>> saveAsset(
    AssetRepository repository,
  ) =>
      SaveItem(repository);

  @injectable
  DeleteItem<Asset, CategorizedDraft<AssetCategory>> deleteAsset(
    AssetRepository repository,
  ) =>
      DeleteItem(repository);

  @injectable
  GetItems<Liability, CategorizedDraft<LiabilityCategory>> getLiabilities(
    LiabilityRepository repository,
  ) =>
      GetItems(repository);

  @injectable
  SaveItem<Liability, CategorizedDraft<LiabilityCategory>> saveLiability(
    LiabilityRepository repository,
  ) =>
      SaveItem(repository);

  @injectable
  DeleteItem<Liability, CategorizedDraft<LiabilityCategory>> deleteLiability(
    LiabilityRepository repository,
  ) =>
      DeleteItem(repository);

  @injectable
  GetNetWorthSnapshots getNetWorthSnapshots(NetWorthRepository repository) =>
      GetNetWorthSnapshots(repository);

  @injectable
  GetCurrentNetWorth getCurrentNetWorth(NetWorthRepository repository) =>
      GetCurrentNetWorth(repository);

  @injectable
  CreateSnapshot createSnapshot(NetWorthRepository repository) =>
      CreateSnapshot(repository);

  @injectable
  GetNetWorthTrend getNetWorthTrend(NetWorthRepository repository) =>
      GetNetWorthTrend(repository);
}
