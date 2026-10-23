import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/liability_entity.dart';

/// State of the liabilities screen. A new instance is created per screen.
@injectable
class LiabilityBloc
    extends CrudBloc<Liability, CategorizedDraft<LiabilityCategory>> {
  LiabilityBloc(super.getItems, super.saveItem, super.deleteItem);
}
