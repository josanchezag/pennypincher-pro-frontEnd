import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_breakpoints.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/widgets/responsive_card_row.dart';

/// Links to the assets, liabilities and report screens: all three side
/// by side on desktop screens, assets and liabilities side by side above
/// the report on tablets, and stacked on mobile. Each card grows with its
/// text, so subtitles are never clipped.
class NetWorthLinks extends StatelessWidget {
  const NetWorthLinks({super.key});

  static const Widget assets = _Link(
    route: AppRoute.netWorthAssets,
    icon: Icons.account_balance_wallet_outlined,
  );
  static const Widget liabilities = _Link(
    route: AppRoute.netWorthLiabilities,
    icon: Icons.credit_card_outlined,
  );
  static const Widget report = _Link(
    route: AppRoute.netWorthReport,
    icon: Icons.insights_outlined,
  );

  @override
  Widget build(BuildContext context) {
    return switch (ScreenSize.fromWidth(MediaQuery.sizeOf(context).width)) {
      ScreenSize.desktop =>
        const ResponsiveCardRow(children: [assets, liabilities, report]),
      ScreenSize.tablet => const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ResponsiveCardRow(children: [assets, liabilities]),
            SizedBox(height: AppSpacing.sm),
            report,
          ],
        ),
      ScreenSize.mobile => const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            assets,
            SizedBox(height: AppSpacing.sm),
            liabilities,
            SizedBox(height: AppSpacing.sm),
            report,
          ],
        ),
    };
  }
}

class _Link extends StatelessWidget {
  const _Link({required this.route, required this.icon});

  final AppRoute route;
  final IconData icon;

  String _subtitle(AppLocalizations l10n) => switch (route) {
        AppRoute.netWorthAssets => l10n.netWorthAssetsSubtitle,
        AppRoute.netWorthLiabilities => l10n.netWorthLiabilitiesSubtitle,
        _ => l10n.netWorthReportSubtitle,
      };

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: () => context.goNamed(route.name),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(icon, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        route.title(context.l10n),
                        style: AppTypography.bodyLarge,
                      ),
                      Text(
                        _subtitle(context.l10n),
                        style: AppTypography.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
