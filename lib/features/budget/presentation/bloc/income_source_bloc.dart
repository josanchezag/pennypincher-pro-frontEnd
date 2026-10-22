import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';

/// State of the income sources screen. A new instance is created per
/// screen.
@injectable
class IncomeSourceBloc extends CrudBloc<IncomeSource, IncomeCategory> {
  IncomeSourceBloc(super.getItems, super.saveItem, super.deleteItem);
}
