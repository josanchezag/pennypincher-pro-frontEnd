import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/goals_texts.dart';

/// Wraps a goal card and, when [play] turns on, celebrates once that the
/// goal passed half of its target: the card swells slightly, glows in gold
/// and shows a short message, then calls [onFinished].
class HalfwayCelebration extends StatefulWidget {
  const HalfwayCelebration({
    required this.play,
    required this.onFinished,
    required this.child,
    super.key,
  });

  static const Duration duration = Duration(milliseconds: 1800);
  static const double peakScale = 1.03;
  static const double glowBlur = AppSpacing.md;
  static const Key messageKey = Key('halfway-celebration-message');

  final bool play;
  final VoidCallback onFinished;
  final Widget child;

  @override
  State<HalfwayCelebration> createState() => _HalfwayCelebrationState();
}

class _HalfwayCelebrationState extends State<HalfwayCelebration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: HalfwayCelebration.duration,
  )..addStatusListener(_onStatus);

  /// Up to the peak and back, so the card ends at its normal size.
  late final Animation<double> _pulse = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 1),
  ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void initState() {
    super.initState();
    if (widget.play) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(HalfwayCelebration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.play && !oldWidget.play) {
      _controller.forward(from: 0);
    }
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onFinished();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      child: widget.child,
      builder: (context, child) => Transform.scale(
        scale: 1 + (HalfwayCelebration.peakScale - 1) * _pulse.value,
        child: Stack(
          children: [
            _Glow(strength: _pulse.value, child: child!),
            if (_controller.isAnimating) const _Message(),
          ],
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.strength, required this.child});

  final double strength;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(AppSpacing.radiusCard),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGold.withOpacity(strength),
            blurRadius: HalfwayCelebration.glowBlur * strength,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Message extends StatelessWidget {
  const _Message();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSpacing.xs,
      right: AppSpacing.xs,
      child: Semantics(
        liveRegion: true,
        child: Container(
          key: HalfwayCelebration.messageKey,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xxs,
          ),
          decoration: const BoxDecoration(
            color: AppColors.accentGoldMuted,
            borderRadius: BorderRadius.all(
              Radius.circular(AppSpacing.radiusCard),
            ),
          ),
          child: Text(
            GoalsTexts.halfwayThere,
            style: AppTypography.label.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
