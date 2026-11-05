import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/widgets/button_progress_icon.dart';

/// Card of one setting: an icon, a [title] and a [description] above the
/// control that changes it. [busy] shows a small progress indicator while
/// a change is being saved.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.icon,
    required this.title,
    required this.description,
    required this.child,
    this.busy = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget child;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: AppColors.brandPrimary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _Heading(title: title, text: description)),
                if (busy)
                  ButtonProgressIcon(semanticsLabel: context.l10n.commonSaving),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            child,
          ],
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: AppTypography.heading3),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          text,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
