import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/categorized_layout.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/variable_expense_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/variable_expense_bloc.dart';

/// `/expenses/variable`: the monthly total, category chips that filter the
/// list, and the estimated variable expenses grouped by category with
/// subtotals. Expects a [VariableExpenseBloc] above it.
class VariableExpensesScreen extends StatelessWidget {
  const VariableExpensesScreen({super.key});

  static final CrudScreenConfig<VariableExpense,
      CategorizedDraft<VariableExpenseCategory>> config = CrudScreenConfig(
    route: AppRoute.expensesVariable,
    parent: AppRoute.expenses,
    itemNoun: (l10n) => l10n.variableExpenseNoun,
    emptyIcon: Icons.shopping_bag_outlined,
    emptyMessage: (l10n) => l10n.variableExpensesEmptyMessage,
    layout: CategorizedLayout(
      amountLabel: (l10n) => l10n.monthlyAmount,
      totalLabel: (l10n) => l10n.totalMonthlyAmount,
      totalIcon: Icons.receipt_long_outlined,
      totalColor: AppColors.warning,
      filterable: true,
      categoryLabels: {
        VariableExpenseCategory.leisure: (l10n) => l10n.variableCategoryLeisure,
        VariableExpenseCategory.streaming: (l10n) =>
            l10n.variableCategoryStreaming,
        VariableExpenseCategory.householdStaff: (l10n) =>
            l10n.variableCategoryHouseholdStaff,
        VariableExpenseCategory.dining: (l10n) => l10n.variableCategoryDining,
        VariableExpenseCategory.clothing: (l10n) =>
            l10n.variableCategoryClothing,
        VariableExpenseCategory.gifts: (l10n) => l10n.variableCategoryGifts,
        VariableExpenseCategory.other: (l10n) => l10n.categoryOther,
      },
    ),
  );

  @override
  Widget build(BuildContext context) => CrudScreen<VariableExpense,
          CategorizedDraft<VariableExpenseCategory>, VariableExpenseBloc>(
        config: config,
      );
}
