import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/router/auth_guard.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pennypincher_pro/features/auth/presentation/widget/brand_header.dart';

/// Brand screen shown on startup while the session is restored.
///
/// It stays at least [AppConstants.splashMinDuration], then opens [from]
/// (or the dashboard) when the session was restored, or the login screen
/// otherwise. If the check is still running after
/// [AppConstants.splashMaxDuration] it moves on to the login screen, which
/// the router leaves as soon as the session is restored.
class SplashScreen extends StatefulWidget {
  const SplashScreen({this.from, super.key});

  /// Location requested before the session check.
  final String? from;

  static const String progressLabel = 'Loading';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<Timer> _timers = [];
  bool _minimumShown = false;
  bool _left = false;

  @override
  void initState() {
    super.initState();
    _timers
      ..add(Timer(AppConstants.splashMinDuration, _onMinimumShown))
      ..add(Timer(AppConstants.splashMaxDuration, _onMaximumReached));
  }

  @override
  void dispose() {
    _cancelTimers();
    super.dispose();
  }

  void _onMinimumShown() {
    _minimumShown = true;
    _leaveFor(context.read<AuthBloc>().state);
  }

  void _onMaximumReached() => _go(AuthGuard.loginFor(widget.from));

  void _leaveFor(AuthState state) {
    if (!_minimumShown) {
      return;
    }
    switch (state) {
      case AuthAuthenticated():
        _go(AuthGuard.targetAfterSignIn(widget.from));
      case AuthUnauthenticated() || AuthError():
        _go(AuthGuard.loginFor(widget.from));
      case AuthInitial() || AuthLoading():
        break;
    }
  }

  void _go(String location) {
    if (!mounted || _left) {
      return;
    }
    _left = true;
    _cancelTimers();
    context.go(location);
  }

  void _cancelTimers() {
    for (final timer in _timers) {
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) => _leaveFor(state),
      child: const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BrandHeader(titleStyle: AppTypography.display),
              SizedBox(height: AppSpacing.xl),
              CircularProgressIndicator(
                semanticsLabel: SplashScreen.progressLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
