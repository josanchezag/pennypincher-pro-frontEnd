import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/monthly_budget_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/budget_texts.dart';

/// How a category's share of the income compares with its ideal share.
///
/// Rule, with a tolerance of [BudgetLimits.targetTolerancePercent] % of the
/// ideal. Without an ideal the share is [neutral] (grey).
/// - [TargetDirection.atMost] (credit cards): at or below the ideal it is
///   [onTarget] (green); above it by at most the tolerance (for an ideal of
///   20 %, up to 22 %) it is [slightlyOver] (amber); higher is [over] (red).
/// - [TargetDirection.atLeast] (savings and charity): at or above the
///   ideal it is [onTarget] (green); below it by at most the tolerance (for
///   an ideal of 10 %, down to 9 %) it is [slightlyUnder] (amber); lower is
///   [under] (red).
///
/// Shares are compared in exact hundredths of a percent, as the API sends
/// them.
enum PercentageStatus {
  neutral(AppColors.neutral, BudgetTexts.noIdeal),
  onTarget(AppColors.success, BudgetTexts.onTarget),
  slightlyOver(AppColors.warning, BudgetTexts.slightlyOver),
  over(AppColors.error, BudgetTexts.over),
  slightlyUnder(AppColors.warning, BudgetTexts.slightlyUnder),
  under(AppColors.error, BudgetTexts.under);

  const PercentageStatus(this.color, this.description);

  final Color color;

  /// Read by screen readers after the percentages.
  final String description;

  static const int _hundred = 100;
  static const int _tolerance = BudgetLimits.targetTolerancePercent;

  static PercentageStatus of(
    double actual,
    double? ideal, {
    TargetDirection direction = TargetDirection.atMost,
  }) {
    if (ideal == null) {
      return neutral;
    }
    final actualHundredths = (actual * _hundred).round();
    final idealHundredths = (ideal * _hundred).round();
    return switch (direction) {
      TargetDirection.atMost => _atMost(actualHundredths, idealHundredths),
      TargetDirection.atLeast => _atLeast(actualHundredths, idealHundredths),
    };
  }

  static PercentageStatus _atMost(int actual, int ideal) {
    if (actual <= ideal) {
      return onTarget;
    }
    return actual * _hundred <= ideal * (_hundred + _tolerance)
        ? slightlyOver
        : over;
  }

  static PercentageStatus _atLeast(int actual, int ideal) {
    if (actual >= ideal) {
      return onTarget;
    }
    return actual * _hundred >= ideal * (_hundred - _tolerance)
        ? slightlyUnder
        : under;
  }
}

/// One category of the budget: label and amount, share of the income,
/// progress bar colored by [PercentageStatus] and the ideal share (`—`
/// without one). On narrow widths the bar moves under the texts.
class ExpensePercentageRow extends StatelessWidget {
  const ExpensePercentageRow({
    required this.label,
    required this.amount,
    required this.percentage,
    required this.idealPercentage,
    this.direction = TargetDirection.atMost,
    super.key,
  });

  static const double wideLayoutWidth = 480;
  static const double labelWidth = 160;
  static const double percentWidth = 72;
  static const double barHeight = AppSpacing.xs;
  static const double markerWidth = 2;
  static const Key barKey = Key('expense-percentage-bar');

  final String label;
  final String amount;

  /// Share of the income, in percent units.
  final double percentage;
  final double? idealPercentage;

  /// Whether [idealPercentage] is a ceiling or a floor.
  final TargetDirection direction;

  PercentageStatus get status =>
      PercentageStatus.of(percentage, idealPercentage, direction: direction);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: _semanticsLabel(),
      child: ExcludeSemantics(
        child: LayoutBuilder(
          builder: (context, constraints) =>
              constraints.maxWidth >= wideLayoutWidth ? _wide() : _narrow(),
        ),
      ),
    );
  }

  String _semanticsLabel() => [
        label,
        amount,
        '${PercentFormatter.format(percentage)} ${BudgetTexts.ofIncome}',
        if (idealPercentage != null)
          '${BudgetTexts.idealPrefix} ${PercentFormatter.format(idealPercentage!)}',
        status.description,
      ].join(', ');

  Widget _wide() => Row(
        children: [
          SizedBox(width: labelWidth, child: _description()),
          _percent(PercentFormatter.format(percentage), status.color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: _bar()),
          const SizedBox(width: AppSpacing.sm),
          _percent(
            PercentFormatter.formatOptional(idealPercentage),
            AppColors.textSecondary,
          ),
        ],
      );

  Widget _narrow() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: _description()),
              _percent(PercentFormatter.format(percentage), status.color),
              _percent(
                PercentFormatter.formatOptional(idealPercentage),
                AppColors.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          _bar(),
        ],
      );

  Widget _description() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.bodyLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(amount, style: AppTypography.monoSmall),
        ],
      );

  /// One line always: shares of 1.000 % or more shrink to fit the column.
  static Widget _percent(String text, Color color) => SizedBox(
        width: percentWidth,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Text(
            text,
            maxLines: 1,
            softWrap: false,
            style: AppTypography.monoMedium.copyWith(color: color),
          ),
        ),
      );

  Widget _bar() => _PercentageBar(
        key: barKey,
        value: percentage,
        ideal: idealPercentage,
        color: status.color,
      );
}

/// Share of the income as a bar from 0 to 100 %, with a tick at the ideal.
class _PercentageBar extends StatelessWidget {
  const _PercentageBar({
    required this.value,
    required this.ideal,
    required this.color,
    super.key,
  });

  static const double _full = 100;

  final double value;
  final double? ideal;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final target = ideal;
    return SizedBox(
      height: ExpensePercentageRow.barHeight + AppSpacing.xxs,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(ExpensePercentageRow.barHeight),
            child: LinearProgressIndicator(
              value: (value / _full).clamp(0, 1),
              minHeight: ExpensePercentageRow.barHeight,
              color: color,
              backgroundColor: AppColors.backgroundTertiary,
            ),
          ),
          if (target != null)
            Align(
              alignment: Alignment((target / _full).clamp(0, 1) * 2 - 1, 0),
              child: const SizedBox(
                width: ExpensePercentageRow.markerWidth,
                height: double.infinity,
                child: ColoredBox(color: AppColors.textSecondary),
              ),
            ),
        ],
      ),
    );
  }
}
