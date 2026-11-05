import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/core/widgets/responsive_card_row.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_snapshot_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_summary_entity.dart';

/// Total assets, total liabilities and net worth: side by side from
/// tablet up, stacked on mobile.
class NetWorthStatCards extends StatelessWidget {
  const NetWorthStatCards({
    required this.current,
    required this.baseline,
    required this.change,
    super.key,
  });

  final NetWorthSummary current;

  /// Snapshot the net worth change is measured against, if any.
  final NetWorthSnapshot? baseline;

  /// Net worth change since [baseline], when there is one.
  final Money? change;

  @override
  Widget build(BuildContext context) =>
      ResponsiveCardRow(children: _cards(context.l10n, context.money));

  List<Widget> _cards(AppLocalizations l10n, MoneyFormatter money) => [
        StatCard(
          label: l10n.totalAssets,
          value: money.format(current.totalAssets),
          icon: Icons.trending_up,
          valueColor: AppColors.success,
        ),
        StatCard(
          label: l10n.totalLiabilities,
          value: money.format(current.totalLiabilities),
          icon: Icons.trending_down,
          valueColor: AppColors.error,
        ),
        StatCard(
          label: l10n.netWorth,
          value: money.format(current.netWorth),
          icon: Icons.account_balance_outlined,
          valueColor: _colorOf(current.netWorth),
          delta: _delta(l10n, money),
        ),
      ];

  StatDelta? _delta(AppLocalizations l10n, MoneyFormatter money) {
    final reference = baseline;
    final difference = change;
    if (reference == null || difference == null) {
      return null;
    }
    return StatDelta(
      text: l10n.changeVersus(
        money.formatSigned(difference),
        MonthFormat.short.format(reference.snapshotDate),
      ),
      isPositive: !difference.isNegative,
    );
  }

  static Color _colorOf(Money netWorth) =>
      netWorth.isNegative ? AppColors.error : AppColors.success;
}
