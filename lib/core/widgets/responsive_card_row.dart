import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/theme/app_breakpoints.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';

/// Cards side by side with the same height from tablet up, stacked on
/// mobile.
class ResponsiveCardRow extends StatelessWidget {
  const ResponsiveCardRow({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          ScreenSize.fromWidth(constraints.maxWidth) == ScreenSize.mobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _spaced(children, vertical: true),
                )
              : IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _spaced(
                      [for (final card in children) Expanded(child: card)],
                      vertical: false,
                    ),
                  ),
                ),
    );
  }

  static List<Widget> _spaced(List<Widget> cards, {required bool vertical}) => [
        for (final (index, card) in cards.indexed) ...[
          if (index > 0)
            SizedBox(
              width: vertical ? null : AppSpacing.md,
              height: vertical ? AppSpacing.sm : null,
            ),
          card,
        ],
      ];
}
