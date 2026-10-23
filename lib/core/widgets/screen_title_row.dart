import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';

/// Title of a screen below a section, with a back button that opens the
/// [parent] route.
class ScreenTitleRow extends StatelessWidget {
  const ScreenTitleRow({
    required this.title,
    required this.backTooltip,
    required this.parent,
    super.key,
  });

  final String title;
  final String backTooltip;

  /// Name of the route the back button opens.
  final String parent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: backTooltip,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(parent),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Semantics(
            header: true,
            child: Text(title, style: AppTypography.heading1),
          ),
        ),
      ],
    );
  }
}
