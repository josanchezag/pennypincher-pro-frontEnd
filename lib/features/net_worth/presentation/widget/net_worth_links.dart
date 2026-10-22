import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_breakpoints.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/net_worth_texts.dart';

/// Links to the assets and liabilities screens.
class NetWorthLinks extends StatelessWidget {
  const NetWorthLinks({super.key});

  static const List<Widget> links = [
    _Link(
      route: AppRoute.netWorthAssets,
      icon: Icons.account_balance_wallet_outlined,
      subtitle: NetWorthTexts.assetsSubtitle,
    ),
    _Link(
      route: AppRoute.netWorthLiabilities,
      icon: Icons.credit_card_outlined,
      subtitle: NetWorthTexts.liabilitiesSubtitle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          ScreenSize.fromWidth(constraints.maxWidth) == ScreenSize.mobile
              ? Column(
                  children: [
                    links.first,
                    const SizedBox(height: AppSpacing.sm),
                    links.last,
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: links.first),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(child: links.last),
                  ],
                ),
    );
  }
}

class _Link extends StatelessWidget {
  const _Link({
    required this.route,
    required this.icon,
    required this.subtitle,
  });

  final AppRoute route;
  final IconData icon;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: Icon(icon),
        title: Text(route.title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.goNamed(route.name),
      ),
    );
  }
}
