import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/fixed_expense_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/variable_expense_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/fixed_expense_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/variable_expense_bloc.dart';

import '../../../../helpers/crud_bloc_suite.dart';
import '../../../../helpers/expense_fixtures.dart';

void main() {
  group('FixedExpenseBloc', () {
    crudBlocSuite<FixedExpense, CategorizedDraft<FixedExpenseCategory>,
        FixedExpenseBloc>(
      build: FixedExpenseBloc.new,
      first: schoolAna,
      second: rent,
      created: tithe,
      updated: rent.copyWith(monthlyAmount: const Money.fromPesos(3300000)),
      draft: const CategorizedDraft(
        name: 'Arriendo',
        amount: Money.fromPesos(3300000),
        category: FixedExpenseCategory.housing,
      ),
    );
  });

  group('VariableExpenseBloc', () {
    crudBlocSuite<VariableExpense, CategorizedDraft<VariableExpenseCategory>,
        VariableExpenseBloc>(
      build: VariableExpenseBloc.new,
      first: netflix,
      second: nanny,
      created: restaurants,
      updated: nanny.copyWith(monthlyAmount: const Money.fromPesos(1900000)),
      draft: const CategorizedDraft(
        name: 'Empleada',
        amount: Money.fromPesos(1900000),
        category: VariableExpenseCategory.householdStaff,
      ),
    );
  });
}
