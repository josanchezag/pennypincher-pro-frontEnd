import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/utils/currency_formatter.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/core/widgets/responsive_card_row.dart';
import 'package:pennypincher_pro/core/widgets/stat_card.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_snapshot_entity.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_summary_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/net_worth_texts.dart';

/// Total assets, total liabilities and net worth: side by side from
/// tablet up, stacked on mobile.
class NetWorthStatCards extends StatelessWidget {
  const NetWorthStatCards({
    required this.current,
    required this.baseline,
    required this.change,
    super.key,
  });

  static final DateFormat baselineMonth = DateFormat('MMM yyyy');

  final NetWorthSummary current;

  /// Snapshot the net worth change is measured against, if any.
  final NetWorthSnapshot? baseline;

  /// Net worth change since [baseline], when there is one.
  final Money? change;

  @override
  Widget build(BuildContext context) => ResponsiveCardRow(children: _cards());

  List<Widget> _cards() => [
        StatCard(
          label: NetWorthTexts.totalAssets,
          value: CurrencyFormatter.format(current.totalAssets),
          icon: Icons.trending_up,
          valueColor: AppColors.success,
        ),
        StatCard(
          label: NetWorthTexts.totalLiabilities,
          value: CurrencyFormatter.format(current.totalLiabilities),
          icon: Icons.trending_down,
          valueColor: AppColors.error,
        ),
        StatCard(
          label: NetWorthTexts.netWorth,
          value: CurrencyFormatter.format(current.netWorth),
          icon: Icons.account_balance_outlined,
          valueColor: _colorOf(current.netWorth),
          delta: _delta(),
        ),
      ];

  StatDelta? _delta() {
    final reference = baseline;
    final difference = change;
    if (reference == null || difference == null) {
      return null;
    }
    return StatDelta(
      text: '${CurrencyFormatter.formatSigned(difference)} '
          '${NetWorthTexts.versus} '
          '${baselineMonth.format(reference.snapshotDate)}',
      isPositive: !difference.isNegative,
    );
  }

  static Color _colorOf(Money netWorth) =>
      netWorth.isNegative ? AppColors.error : AppColors.success;
}
