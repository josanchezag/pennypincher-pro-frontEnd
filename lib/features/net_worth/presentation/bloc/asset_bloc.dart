import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';

/// State of the assets screen. A new instance is created per screen.
@injectable
class AssetBloc extends CrudBloc<Asset, CategorizedDraft<AssetCategory>> {
  AssetBloc(super.getItems, super.saveItem, super.deleteItem);
}
