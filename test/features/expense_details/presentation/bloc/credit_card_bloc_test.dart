import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/credit_card_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/credit_card_bloc.dart';

import '../../../../helpers/crud_bloc_suite.dart';
import '../../../../helpers/expense_fixtures.dart';

void main() {
  crudBlocSuite<CreditCard, BalanceDraft, CreditCardBloc>(
    build: CreditCardBloc.new,
    first: nuCard,
    second: visaCard,
    created: amexCard,
    updated: visaCard.copyWith(totalBalance: const Money.fromPesos(28000000)),
    draft: const BalanceDraft(
      name: 'Visa Bancolombia',
      monthlyAmount: Money.fromCents(125000050),
      balance: Money.fromPesos(28000000),
    ),
  );
}
