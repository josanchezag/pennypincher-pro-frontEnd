import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/categorized_layout.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/variable_expense_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/variable_expense_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/expense_texts.dart';

/// `/expenses/variable`: the monthly total, category chips that filter the
/// list, and the estimated variable expenses grouped by category with
/// subtotals. Expects a [VariableExpenseBloc] above it.
class VariableExpensesScreen extends StatelessWidget {
  const VariableExpensesScreen({super.key});

  static const CrudScreenConfig<VariableExpense,
      CategorizedDraft<VariableExpenseCategory>> config = CrudScreenConfig(
    route: AppRoute.expensesVariable,
    parent: AppRoute.expenses,
    itemNoun: 'variable expense',
    emptyIcon: Icons.shopping_bag_outlined,
    emptyMessage: 'Add your estimated monthly spending, such as dining out, '
        'streaming or clothing, to budget for it.',
    layout: CategorizedLayout(
      amountLabel: ExpenseTexts.monthlyAmount,
      totalLabel: ExpenseTexts.totalMonthlyAmount,
      totalIcon: Icons.receipt_long_outlined,
      totalColor: AppColors.warning,
      filterable: true,
      categoryLabels: {
        VariableExpenseCategory.leisure: 'Leisure',
        VariableExpenseCategory.streaming: 'Streaming',
        VariableExpenseCategory.householdStaff: 'Household staff',
        VariableExpenseCategory.dining: 'Dining',
        VariableExpenseCategory.clothing: 'Clothing',
        VariableExpenseCategory.gifts: 'Gifts',
        VariableExpenseCategory.other: 'Other',
      },
    ),
  );

  @override
  Widget build(BuildContext context) => const CrudScreen<VariableExpense,
          CategorizedDraft<VariableExpenseCategory>, VariableExpenseBloc>(
        config: config,
      );
}
