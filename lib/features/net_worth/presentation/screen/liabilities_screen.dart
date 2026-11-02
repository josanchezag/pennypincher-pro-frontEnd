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

  static final CrudScreenConfig<Liability, CategorizedDraft<LiabilityCategory>>
      config = CrudScreenConfig(
    route: AppRoute.netWorthLiabilities,
    parent: AppRoute.netWorth,
    itemNoun: (l10n) => l10n.liabilityNoun,
    emptyIcon: Icons.credit_card_off_outlined,
    emptyMessage: (l10n) => l10n.liabilitiesEmptyMessage,
    layout: CategorizedLayout(
      amountLabel: (l10n) => l10n.currentBalance,
      totalLabel: (l10n) => l10n.totalLiabilities,
      totalIcon: Icons.trending_down,
      totalColor: AppColors.error,
      categoryLabels: {
        LiabilityCategory.creditCard: (l10n) =>
            l10n.liabilityCategoryCreditCard,
        LiabilityCategory.personalLoan: (l10n) =>
            l10n.liabilityCategoryPersonalLoan,
        LiabilityCategory.bankLoan: (l10n) => l10n.liabilityCategoryBankLoan,
        LiabilityCategory.familyDebt: (l10n) =>
            l10n.liabilityCategoryFamilyDebt,
        LiabilityCategory.other: (l10n) => l10n.categoryOther,
      },
    ),
  );

  @override
  Widget build(BuildContext context) =>
      CrudScreen<Liability, CategorizedDraft<LiabilityCategory>, LiabilityBloc>(
        config: config,
      );
}
