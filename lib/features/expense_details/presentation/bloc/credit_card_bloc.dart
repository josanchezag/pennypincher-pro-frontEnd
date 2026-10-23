import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/credit_card_entity.dart';

/// State of the credit cards screen. A new instance is created per screen.
@injectable
class CreditCardBloc extends CrudBloc<CreditCard, BalanceDraft> {
  CreditCardBloc(super.getItems, super.saveItem, super.deleteItem);
}
