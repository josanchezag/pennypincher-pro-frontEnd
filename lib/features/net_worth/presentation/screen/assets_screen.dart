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

  static final CrudScreenConfig<Asset, CategorizedDraft<AssetCategory>> config =
      CrudScreenConfig(
    route: AppRoute.netWorthAssets,
    parent: AppRoute.netWorth,
    itemNoun: (l10n) => l10n.assetNoun,
    emptyIcon: Icons.account_balance_wallet_outlined,
    emptyMessage: (l10n) => l10n.assetsEmptyMessage,
    layout: CategorizedLayout(
      amountLabel: (l10n) => l10n.assetValue,
      totalLabel: (l10n) => l10n.totalAssets,
      totalIcon: Icons.trending_up,
      totalColor: AppColors.success,
      categoryLabels: {
        AssetCategory.realEstate: (l10n) => l10n.assetCategoryRealEstate,
        AssetCategory.vehicle: (l10n) => l10n.assetCategoryVehicle,
        AssetCategory.business: (l10n) => l10n.assetCategoryBusiness,
        AssetCategory.cash: (l10n) => l10n.assetCategoryCash,
        AssetCategory.savings: (l10n) => l10n.assetCategorySavings,
        AssetCategory.equipment: (l10n) => l10n.assetCategoryEquipment,
        AssetCategory.other: (l10n) => l10n.categoryOther,
      },
    ),
  );

  @override
  Widget build(BuildContext context) =>
      CrudScreen<Asset, CategorizedDraft<AssetCategory>, AssetBloc>(
        config: config,
      );
}
