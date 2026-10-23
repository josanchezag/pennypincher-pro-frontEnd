import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/utils/percent_formatter.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goal_styles.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goals_texts.dart';

/// Ring that fills with the progress toward a goal, colored by its
/// [ProgressBand], with the percentage in large type in its center. A null
/// [percent] draws an empty ring with a dash.
class GoalCircularProgress extends StatelessWidget {
  const GoalCircularProgress({required this.percent, super.key});

  static const double size = 112;
  static const double strokeWidth = 10;
  static const double _fullPercent = 100;
  static const int _tenths = 10;

  /// Absorbs the binary error of values such as `57.3 * 10`.
  static const double _epsilon = 1e-9;

  /// From 0 to 100.
  final double? percent;

  /// [percent] cut to the one decimal shown, so the label never rounds up
  /// into the next band: 74.96 is shown as `74,9 %`, in amber.
  static double? shown(double? percent) => percent == null
      ? null
      : (percent * _tenths + _epsilon).floorToDouble() / _tenths;

  Color get color => ProgressBand.of(shown(percent) ?? 0).color;

  @override
  Widget build(BuildContext context) {
    final value = percent;
    final text = PercentFormatter.formatOptional(shown(value));
    return Semantics(
      label: '${GoalsTexts.progress} $text',
      child: ExcludeSemantics(
        child: SizedBox.square(
          dimension: size,
          child: CustomPaint(
            painter: _RingPainter(
              share: ((value ?? 0) / _fullPercent).clamp(0, 1).toDouble(),
              color: color,
            ),
            child: Center(child: _Percentage(text: text)),
          ),
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

/// Grey track and an arc of [share] of the circle, from twelve o'clock.
class _RingPainter extends CustomPainter {
  const _RingPainter({required this.share, required this.color});

  static const double _startAngle = -math.pi / 2;
  static const double _fullTurn = 2 * math.pi;

  final double share;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const inset = GoalCircularProgress.strokeWidth / 2;
    final rect = (Offset.zero & size).deflate(inset);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = GoalCircularProgress.strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect,
      0,
      _fullTurn,
      false,
      paint..color = AppColors.backgroundTertiary,
    );
    if (share > 0) {
      canvas.drawArc(
        rect,
        _startAngle,
        _fullTurn * share,
        false,
        paint..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.share != share || oldDelegate.color != color;
}
