import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/categorized_layout.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/liability_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/liability_bloc.dart';

/// `/net-worth/liabilities`: every debt of the user, grouped by category.
/// Expects a [LiabilityBloc] above it.
class LiabilitiesScreen extends StatelessWidget {
  const LiabilitiesScreen({super.key});

  static const CrudScreenConfig<Liability, CategorizedDraft<LiabilityCategory>>
      config = CrudScreenConfig(
    route: AppRoute.netWorthLiabilities,
    parent: AppRoute.netWorth,
    itemNoun: 'liability',
    emptyIcon: Icons.credit_card_off_outlined,
    emptyMessage: 'Add what you owe, such as credit cards or loans, '
        'to see the full picture of your net worth.',
    layout: CategorizedLayout(
      amountLabel: 'Current balance',
      totalLabel: 'Total liabilities',
      totalIcon: Icons.trending_down,
      totalColor: AppColors.error,
      categoryLabels: {
        LiabilityCategory.creditCard: 'Credit card',
        LiabilityCategory.personalLoan: 'Personal loan',
        LiabilityCategory.bankLoan: 'Bank loan',
        LiabilityCategory.familyDebt: 'Family debt',
        LiabilityCategory.other: 'Other',
      },
    ),
  );

  @override
  Widget build(BuildContext context) => const CrudScreen<Liability,
          CategorizedDraft<LiabilityCategory>, LiabilityBloc>(
        config: config,
      );
}
