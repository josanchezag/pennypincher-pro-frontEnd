import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/loan_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/loan_bloc.dart';

import '../../../../helpers/crud_bloc_suite.dart';
import '../../../../helpers/expense_fixtures.dart';

void main() {
  crudBlocSuite<Loan, BalanceDraft, LoanBloc>(
    build: LoanBloc.new,
    first: carLoan,
    second: davivienda,
    created: familyLoan,
    updated:
        davivienda.copyWith(originalAmount: const Money.fromPesos(90000000)),
    draft: const BalanceDraft(
      name: 'Davivienda 7141',
      monthlyAmount: Money.fromPesos(2080231),
      balance: Money.fromCents(4550000025),
      originalAmount: Money.fromPesos(90000000),
    ),
  );
}
