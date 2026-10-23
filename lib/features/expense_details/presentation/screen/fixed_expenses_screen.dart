import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/categorized_layout.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/fixed_expense_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/fixed_expense_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/expense_texts.dart';

/// `/expenses/fixed`: the monthly total, category chips that filter the
/// list, and the fixed expenses grouped by category with subtotals.
/// Expects a [FixedExpenseBloc] above it.
class FixedExpensesScreen extends StatelessWidget {
  const FixedExpensesScreen({super.key});

  static const CrudScreenConfig<FixedExpense,
      CategorizedDraft<FixedExpenseCategory>> config = CrudScreenConfig(
    route: AppRoute.expensesFixed,
    parent: AppRoute.expenses,
    itemNoun: 'fixed expense',
    emptyIcon: Icons.event_repeat_outlined,
    emptyMessage: 'Add what you pay every month, such as rent, school or '
        'insurance, to know your fixed monthly costs.',
    layout: CategorizedLayout(
      amountLabel: ExpenseTexts.monthlyAmount,
      totalLabel: ExpenseTexts.totalMonthlyAmount,
      totalIcon: Icons.receipt_long_outlined,
      totalColor: AppColors.warning,
      filterable: true,
      categoryLabels: {
        FixedExpenseCategory.food: 'Food',
        FixedExpenseCategory.education: 'Education',
        FixedExpenseCategory.transport: 'Transport',
        FixedExpenseCategory.utilities: 'Utilities',
        FixedExpenseCategory.insurance: 'Insurance',
        FixedExpenseCategory.housing: 'Housing',
        FixedExpenseCategory.health: 'Health',
        FixedExpenseCategory.charity: 'Charity',
        FixedExpenseCategory.communication: 'Communication',
        FixedExpenseCategory.taxes: 'Taxes',
        FixedExpenseCategory.other: 'Other',
      },
    ),
  );

  @override
  Widget build(BuildContext context) => const CrudScreen<FixedExpense,
      CategorizedDraft<FixedExpenseCategory>, FixedExpenseBloc>(config: config);
}
