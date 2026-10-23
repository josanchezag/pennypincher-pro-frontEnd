import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/theme/progress_band.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/core/widgets/progress_ring.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goals_texts.dart';

/// Ring that fills with the progress toward a goal, colored by its
/// [ProgressBand], with the percentage in large type in its center. A null
/// [percent] draws an empty ring with a dash.
class GoalCircularProgress extends StatelessWidget {
  const GoalCircularProgress({required this.percent, super.key});

  static const double size = 112;
  static const double strokeWidth = 10;

  /// From 0 to 100.
  final double? percent;

  Color get color => ProgressBand.colorOf(percent);

  @override
  Widget build(BuildContext context) {
    final text = PercentFormatter.formatOptional(ProgressBand.shown(percent));
    return Semantics(
      label: '${GoalsTexts.progress} $text',
      child: ExcludeSemantics(
        child: ProgressRing(
          percent: percent,
          size: size,
          strokeWidth: strokeWidth,
          child: _Percentage(text: text),
        ),
      ),
    );
  }
}

class _Percentage extends StatelessWidget {
  const _Percentage({required this.text});

  static const double padding = GoalCircularProgress.strokeWidth * 2;

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(padding),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: AppTypography.monoLarge.copyWith(
            fontSize: AppTypography.heading2Size,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
