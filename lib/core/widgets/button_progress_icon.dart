import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';

/// Small spinner that replaces a button's icon or label while its action
/// runs.
class ButtonProgressIcon extends StatelessWidget {
  const ButtonProgressIcon({this.semanticsLabel, super.key});

  static const double size = AppSpacing.md;
  static const double strokeWidth = 2;

  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        semanticsLabel: semanticsLabel,
      ),
    );
  }
}
