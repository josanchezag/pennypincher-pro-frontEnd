import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';

/// The open ant expenses of the current period, reloaded after every
/// change so they keep the backend's order (newest purchase first). A new
/// instance is created per screen.
@injectable
class AntExpenseBloc extends CrudBloc<AntExpense, AntExpenseDraft> {
  AntExpenseBloc(super.getItems, super.saveItem, super.deleteItem)
      : super(reloadAfterChange: true);
}
