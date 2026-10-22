import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/income_source_bloc.dart';

/// `/budget/income`: the user's recurring income, grouped by category.
/// Expects an [IncomeSourceBloc] above it.
class IncomeSourcesScreen extends StatelessWidget {
  const IncomeSourcesScreen({super.key});

  static const CrudScreenConfig<IncomeCategory> config = CrudScreenConfig(
    route: AppRoute.budgetIncome,
    parent: AppRoute.budgetOverview,
    itemNoun: 'income source',
    amountLabel: 'Monthly amount',
    totalLabel: 'Total monthly income',
    totalIcon: Icons.payments_outlined,
    totalColor: AppColors.success,
    emptyIcon: Icons.savings_outlined,
    emptyMessage: 'Add your first income source, such as your salary or a '
        'rent you collect, to calculate your monthly income.',
    categoryLabels: {
      IncomeCategory.employment: 'Employment',
      IncomeCategory.rental: 'Rental',
      IncomeCategory.business: 'Business',
      IncomeCategory.investment: 'Investment',
      IncomeCategory.freelance: 'Freelance',
      IncomeCategory.other: 'Other',
    },
  );

  @override
  Widget build(BuildContext context) =>
      const CrudScreen<IncomeSource, IncomeCategory, IncomeSourceBloc>(
        config: config,
      );
}
