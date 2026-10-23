import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/progress_band.dart';

/// Ring of [size] that fills with a progress of [percent] (0 to 100),
/// colored by its [ProgressBand], with an optional [child] in its center. A
/// null [percent] draws only the grey track.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    required this.percent,
    required this.size,
    required this.strokeWidth,
    this.child,
    super.key,
  });

  static const double _fullPercent = 100;

  final double? percent;
  final double size;
  final double strokeWidth;
  final Widget? child;

  Color get color => ProgressBand.colorOf(percent);

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _RingPainter(
          share: ((percent ?? 0) / _fullPercent).clamp(0, 1).toDouble(),
          color: color,
          strokeWidth: strokeWidth,
        ),
        child: child == null ? null : Center(child: child),
      ),
    );
  }
}

/// Grey track and an arc of [share] of the circle, from twelve o'clock.
class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.share,
    required this.color,
    required this.strokeWidth,
  });

  static const double _startAngle = -math.pi / 2;
  static const double _fullTurn = 2 * math.pi;

  final double share;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(strokeWidth / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
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
      oldDelegate.share != share ||
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth;
}
