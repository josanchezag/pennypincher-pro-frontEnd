import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/categorized_layout.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/asset_bloc.dart';

/// `/net-worth/assets`: everything the user owns, grouped by category.
/// Expects an [AssetBloc] above it.
class AssetsScreen extends StatelessWidget {
  const AssetsScreen({super.key});

  static const CrudScreenConfig<Asset, CategorizedDraft<AssetCategory>> config =
      CrudScreenConfig(
    route: AppRoute.netWorthAssets,
    parent: AppRoute.netWorth,
    itemNoun: 'asset',
    emptyIcon: Icons.account_balance_wallet_outlined,
    emptyMessage: 'Add what you own, such as your home, car or savings, '
        'to start tracking your net worth.',
    layout: CategorizedLayout(
      amountLabel: 'Value',
      totalLabel: 'Total assets',
      totalIcon: Icons.trending_up,
      totalColor: AppColors.success,
      categoryLabels: {
        AssetCategory.realEstate: 'Real estate',
        AssetCategory.vehicle: 'Vehicle',
        AssetCategory.business: 'Business',
        AssetCategory.cash: 'Cash',
        AssetCategory.savings: 'Savings',
        AssetCategory.equipment: 'Equipment',
        AssetCategory.other: 'Other',
      },
    ),
  );

  @override
  Widget build(BuildContext context) =>
      const CrudScreen<Asset, CategorizedDraft<AssetCategory>, AssetBloc>(
        config: config,
      );
}
