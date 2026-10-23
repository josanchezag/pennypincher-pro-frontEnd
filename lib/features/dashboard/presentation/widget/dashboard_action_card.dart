import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';

/// Card that suggests a next step, such as creating the month's budget,
/// and opens [route] when tapped. Announced to screen readers as a button.
class DashboardActionCard extends StatelessWidget {
  const DashboardActionCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.route,
    super.key,
  });

  static const double iconSize = AppSpacing.xl;

  final IconData icon;
  final String title;
  final String message;
  final AppRoute route;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: () => context.goNamed(route.name),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(icon, size: iconSize, color: AppColors.brandPrimary),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _Texts(title: title, message: message)),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Texts extends StatelessWidget {
  const _Texts({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.heading3),
        const SizedBox(height: AppSpacing.xxs),
        Text(message, style: AppTypography.bodyMedium),
      ],
    );
  }
}
