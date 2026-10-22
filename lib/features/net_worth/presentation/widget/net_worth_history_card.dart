import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/widgets/status_message.dart';
import 'package:pennypincher_pro/features/net_worth/domain/entity/net_worth_snapshot_entity.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/net_worth_texts.dart';
import 'package:pennypincher_pro/features/net_worth/presentation/widget/net_worth_chart.dart';

/// Card with the net worth chart, or an empty state without snapshots.
class NetWorthHistoryCard extends StatelessWidget {
  const NetWorthHistoryCard({required this.history, super.key});

  final List<NetWorthSnapshot> history;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              container: true,
              header: true,
              child: const Text(
                NetWorthTexts.history,
                style: AppTypography.heading3,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (history.isEmpty)
              const StatusMessage(
                icon: Icons.show_chart,
                title: NetWorthTexts.emptyHistoryTitle,
                message: NetWorthTexts.emptyHistoryMessage,
              )
            else
              NetWorthChart(history: history),
          ],
        ),
      ),
    );
  }
}
