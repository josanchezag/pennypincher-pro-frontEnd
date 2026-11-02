import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/widgets/responsive_card_row.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_trend_entity.dart';

/// Latest net worth, best month and change over the range of a report:
/// side by side from tablet up, stacked on mobile.
class NetWorthReportSummary extends StatelessWidget {
  const NetWorthReportSummary({required this.trend, super.key});

  /// Must not be empty.
  final NetWorthTrend trend;

  @override
  Widget build(BuildContext context) => ResponsiveCardRow(
        children: [
          _latest(context.l10n),
          _best(context.l10n),
          _change(context.l10n),
        ],
      );

  Widget _latest(AppLocalizations l10n) {
    final points = trend.points;
    final last = points.last;
    final delta = last.delta;
    return StatCard(
      label: l10n.netWorthLatest,
      value: CurrencyFormatter.format(last.netWorth),
      icon: Icons.account_balance_outlined,
      valueColor: colorOf(last.netWorth),
      delta: delta == null || points.length < 2
          ? null
          : StatDelta(
              text: l10n.changeVersus(
                CurrencyFormatter.formatSigned(delta),
                MonthFormat.short.format(points[points.length - 2].month),
              ),
              isPositive: !delta.isNegative,
            ),
    );
  }

  Widget _best(AppLocalizations l10n) {
    final best = trend.best!;
    return StatCard(
      label: l10n.netWorthBestMonthOf(MonthFormat.short.format(best.month)),
      value: CurrencyFormatter.format(best.netWorth),
      icon: Icons.emoji_events_outlined,
      valueColor: AppColors.accentGold,
    );
  }

  Widget _change(AppLocalizations l10n) {
    final change = trend.change!;
    final percentage = trend.changePercentage;
    final start = MonthFormat.short.format(trend.points.first.month);
    return StatCard(
      label: l10n.netWorthChangeInRange,
      value: CurrencyFormatter.formatSigned(change),
      icon: Icons.timeline,
      valueColor: colorOf(change),
      delta: StatDelta(
        text: percentage == null
            ? l10n.netWorthSince(start)
            : l10n.netWorthChangeSince(
                '${percentage.isNegative ? '' : CurrencyFormatter.positiveSign}'
                '${PercentFormatter.format(percentage)}',
                start,
              ),
        isPositive: !change.isNegative,
      ),
    );
  }

  /// Green for zero or more, red below zero.
  static Color colorOf(Money amount) =>
      amount.isNegative ? AppColors.error : AppColors.success;
}
