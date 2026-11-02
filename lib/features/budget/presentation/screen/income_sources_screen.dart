import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/categorized_layout.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/income_source_bloc.dart';

/// `/budget/income`: the user's recurring income, grouped by category.
/// Expects an [IncomeSourceBloc] above it.
class IncomeSourcesScreen extends StatelessWidget {
  const IncomeSourcesScreen({super.key});

  /// Categories and amounts of the income sources, also used by the budget
  /// overview.
  static final CategorizedLayout<IncomeSource, IncomeCategory> layout =
      CategorizedLayout(
    amountLabel: (l10n) => l10n.monthlyAmount,
    totalLabel: (l10n) => l10n.totalMonthlyIncome,
    totalIcon: Icons.payments_outlined,
    totalColor: AppColors.success,
    categoryLabels: {
      IncomeCategory.employment: (l10n) => l10n.incomeCategoryEmployment,
      IncomeCategory.rental: (l10n) => l10n.incomeCategoryRental,
      IncomeCategory.business: (l10n) => l10n.incomeCategoryBusiness,
      IncomeCategory.investment: (l10n) => l10n.incomeCategoryInvestment,
      IncomeCategory.freelance: (l10n) => l10n.incomeCategoryFreelance,
      IncomeCategory.other: (l10n) => l10n.categoryOther,
    },
  );

  static final CrudScreenConfig<IncomeSource, CategorizedDraft<IncomeCategory>>
      config = CrudScreenConfig(
    route: AppRoute.budgetIncome,
    parent: AppRoute.budgetOverview,
    itemNoun: (l10n) => l10n.incomeSourceNoun,
    emptyIcon: Icons.savings_outlined,
    emptyMessage: (l10n) => l10n.incomeEmptyMessage,
    layout: layout,
  );

  @override
  Widget build(BuildContext context) => CrudScreen<IncomeSource,
          CategorizedDraft<IncomeCategory>, IncomeSourceBloc>(
        config: config,
      );
}
