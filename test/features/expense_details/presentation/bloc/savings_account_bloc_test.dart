import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/savings_account_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/savings_account_bloc.dart';

import '../../../../helpers/crud_bloc_suite.dart';
import '../../../../helpers/expense_fixtures.dart';

void main() {
  crudBlocSuite<SavingsAccount, BalanceDraft, SavingsAccountBloc>(
    build: SavingsAccountBloc.new,
    first: emergencyFund,
    second: cdt,
    created: vacations,
    updated: cdt.copyWith(currentBalance: const Money.fromPesos(21000000)),
    draft: const BalanceDraft(
      name: 'CDT Bancolombia',
      monthlyAmount: Money.zero,
      balance: Money.fromPesos(21000000),
    ),
  );
}
