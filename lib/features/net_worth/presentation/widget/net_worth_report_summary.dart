import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/widgets/responsive_card_row.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_trend_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/net_worth_texts.dart';

/// Latest net worth, best month and change over the range of a report:
/// side by side from tablet up, stacked on mobile.
class NetWorthReportSummary extends StatelessWidget {
  const NetWorthReportSummary({required this.trend, super.key});

  static const String labelSeparator = ' · ';

  /// Must not be empty.
  final NetWorthTrend trend;

  @override
  Widget build(BuildContext context) => ResponsiveCardRow(
        children: [_latest(), _best(), _change()],
      );

  Widget _latest() {
    final points = trend.points;
    final last = points.last;
    final delta = last.delta;
    return StatCard(
      label: NetWorthTexts.latestNetWorth,
      value: CurrencyFormatter.format(last.netWorth),
      icon: Icons.account_balance_outlined,
      valueColor: colorOf(last.netWorth),
      delta: delta == null || points.length < 2
          ? null
          : StatDelta(
              text: '${CurrencyFormatter.formatSigned(delta)} '
                  '${NetWorthTexts.versus} '
                  '${MonthFormat.short.format(points[points.length - 2].month)}',
              isPositive: !delta.isNegative,
            ),
    );
  }

  Widget _best() {
    final best = trend.best!;
    return StatCard(
      label: '${NetWorthTexts.bestMonth}$labelSeparator'
          '${MonthFormat.short.format(best.month)}',
      value: CurrencyFormatter.format(best.netWorth),
      icon: Icons.emoji_events_outlined,
      valueColor: AppColors.accentGold,
    );
  }

  Widget _change() {
    final change = trend.change!;
    final percentage = trend.changePercentage;
    final since = '${NetWorthTexts.sinceStartPrefix} '
        '${MonthFormat.short.format(trend.points.first.month)}';
    return StatCard(
      label: NetWorthTexts.changeSinceStart,
      value: CurrencyFormatter.formatSigned(change),
      icon: Icons.timeline,
      valueColor: colorOf(change),
      delta: StatDelta(
        text: percentage == null
            ? since
            : '${percentage.isNegative ? '' : CurrencyFormatter.positiveSign}'
                '${PercentFormatter.format(percentage)} $since',
        isPositive: !change.isNegative,
      ),
    );
  }

  /// Green for zero or more, red below zero.
  static Color colorOf(Money amount) =>
      amount.isNegative ? AppColors.error : AppColors.success;
}
