import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/categorized_layout.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/fixed_expense_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/fixed_expense_bloc.dart';

/// `/expenses/fixed`: the monthly total, category chips that filter the
/// list, and the fixed expenses grouped by category with subtotals.
/// Expects a [FixedExpenseBloc] above it.
class FixedExpensesScreen extends StatelessWidget {
  const FixedExpensesScreen({super.key});

  static final CrudScreenConfig<FixedExpense,
      CategorizedDraft<FixedExpenseCategory>> config = CrudScreenConfig(
    route: AppRoute.expensesFixed,
    parent: AppRoute.expenses,
    itemNoun: (l10n) => l10n.fixedExpenseNoun,
    emptyIcon: Icons.event_repeat_outlined,
    emptyMessage: (l10n) => l10n.fixedExpensesEmptyMessage,
    layout: CategorizedLayout(
      amountLabel: (l10n) => l10n.monthlyAmount,
      totalLabel: (l10n) => l10n.totalMonthlyAmount,
      totalIcon: Icons.receipt_long_outlined,
      totalColor: AppColors.warning,
      filterable: true,
      categoryLabels: {
        FixedExpenseCategory.food: (l10n) => l10n.fixedCategoryFood,
        FixedExpenseCategory.education: (l10n) => l10n.fixedCategoryEducation,
        FixedExpenseCategory.transport: (l10n) => l10n.fixedCategoryTransport,
        FixedExpenseCategory.utilities: (l10n) => l10n.fixedCategoryUtilities,
        FixedExpenseCategory.insurance: (l10n) => l10n.fixedCategoryInsurance,
        FixedExpenseCategory.housing: (l10n) => l10n.fixedCategoryHousing,
        FixedExpenseCategory.health: (l10n) => l10n.fixedCategoryHealth,
        FixedExpenseCategory.charity: (l10n) => l10n.fixedCategoryCharity,
        FixedExpenseCategory.communication: (l10n) =>
            l10n.fixedCategoryCommunication,
        FixedExpenseCategory.taxes: (l10n) => l10n.fixedCategoryTaxes,
        FixedExpenseCategory.other: (l10n) => l10n.categoryOther,
      },
    ),
  );

  @override
  Widget build(BuildContext context) => CrudScreen<FixedExpense,
      CategorizedDraft<FixedExpenseCategory>, FixedExpenseBloc>(config: config);
}
