import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';

/// Brand loading screen shown on startup before entering the app.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String progressLabel = 'Loading';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(AppConstants.splashDuration, _continue);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _continue() {
    if (mounted) {
      context.goNamed(AppRoute.dashboard.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppConstants.appName, style: AppTypography.display),
            SizedBox(height: AppSpacing.xs),
            Text(AppConstants.tagline, style: AppTypography.bodyMedium),
            SizedBox(height: AppSpacing.xl),
            CircularProgressIndicator(
              semanticsLabel: SplashScreen.progressLabel,
            ),
          ],
        ),
      ),
    );
  }
}
