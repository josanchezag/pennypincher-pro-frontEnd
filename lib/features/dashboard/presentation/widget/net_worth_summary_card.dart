import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/time/month_format.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/widgets/labeled_figure.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/dashboard_summary_entity.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/dashboard_texts.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/dashboard_card.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/widget/mini_sparkline.dart';

/// Current net worth in large type with its change since the previous
/// snapshot, the total assets and liabilities, and a sparkline of the last
/// months (or a hint while there are fewer than two snapshots).
class NetWorthSummaryCard extends StatelessWidget {
  const NetWorthSummaryCard({
    required this.netWorth,
    required this.sparkline,
    super.key,
  });

  static const double valueHeight = AppSpacing.xxl;
  static const int minSparklinePoints = 2;

  final NetWorthOverview netWorth;
  final List<NetWorthPoint> sparkline;

  /// `+$ 5.282.773 (+1,3 %) vs Sep 2026`; the percentage is left out when
  /// the previous net worth was zero.
  static String deltaText(NetWorthChange change) {
    final percentage = change.percentage;
    final sign = change.delta.isNegative ? '' : CurrencyFormatter.positiveSign;
    final share = percentage == null
        ? ''
        : ' ($sign${PercentFormatter.format(percentage)})';
    return '${CurrencyFormatter.formatSigned(change.delta)}$share '
        '${DashboardTexts.versus} ${MonthFormat.short.format(change.previousDate)}';
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      icon: Icons.account_balance_outlined,
      title: DashboardTexts.netWorth,
      children: [
        _Value(amount: netWorth),
        const SizedBox(height: AppSpacing.xxs),
        _change(),
        const SizedBox(height: AppSpacing.md),
        _Totals(netWorth: netWorth),
        const SizedBox(height: AppSpacing.md),
        _trend(),
      ],
    );
  }

  Widget _change() {
    final change = netWorth.change;
    if (change == null) {
      return const Text(
        DashboardTexts.noPreviousSnapshot,
        style: AppTypography.bodySmall,
      );
    }
    return StatDeltaLine(
      delta: StatDelta(
        text: deltaText(change),
        isPositive: !change.delta.isNegative,
      ),
    );
  }

  Widget _trend() => sparkline.length < minSparklinePoints
      ? const Text(DashboardTexts.sparklineHint, style: AppTypography.bodySmall)
      : MiniSparkline(points: sparkline);
}

class _Value extends StatelessWidget {
  const _Value({required this.amount});

  final NetWorthOverview amount;

  @override
  Widget build(BuildContext context) {
    final current = amount.current;
    return SizedBox(
      height: NetWorthSummaryCard.valueHeight,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(
          CurrencyFormatter.format(current),
          style: AppTypography.monoLarge.copyWith(
            fontSize: AppTypography.displaySize,
            color: current.isNegative ? AppColors.error : AppColors.success,
          ),
        ),
      ),
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.netWorth});

  final NetWorthOverview netWorth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LabeledFigure(
            label: DashboardTexts.totalAssets,
            value: CurrencyFormatter.format(netWorth.totalAssets),
            valueColor: AppColors.success,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: LabeledFigure(
            label: DashboardTexts.totalLiabilities,
            value: CurrencyFormatter.format(netWorth.totalLiabilities),
            valueColor: AppColors.error,
          ),
        ),
      ],
    );
  }
}
