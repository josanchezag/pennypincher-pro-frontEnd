import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/savings_account_entity.dart';

/// State of the savings screen. A new instance is created per screen.
@injectable
class SavingsAccountBloc extends CrudBloc<SavingsAccount, BalanceDraft> {
  SavingsAccountBloc(super.getItems, super.saveItem, super.deleteItem);
}
