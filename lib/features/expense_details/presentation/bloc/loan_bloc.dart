import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/loan_entity.dart';

/// State of the loans screen. A new instance is created per screen.
@injectable
class LoanBloc extends CrudBloc<Loan, BalanceDraft> {
  LoanBloc(super.getItems, super.saveItem, super.deleteItem);
}
