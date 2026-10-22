import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/config/app_config.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/theme/app_breakpoints.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/theme/app_typography.dart';
import 'package:pennypincher_pro/core/widgets/app_snackbar.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pennypincher_pro/features/auth/presentation/widget/google_sign_in_button.dart';

/// Sign-in screen: a centered card on tablet and desktop, full screen on
/// mobile. Leaving it after signing in is the router guard's job.
class LoginScreen extends StatelessWidget {
  const LoginScreen({required this.config, super.key});

  static const String devLoginLabel = 'Dev login';
  static const String notConfiguredMessage =
      'Google sign-in is not configured for this build.';
  static const double cardMaxWidth = 440;
  static const double logoSize = AppSpacing.xxxl;
  static const Key cardKey = Key('login-card');
  static const Key devLoginKey = Key('dev-login-button');

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: _onStateChanged,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final content = _LoginContent(config: config);
            return ScreenSize.fromWidth(constraints.maxWidth) ==
                    ScreenSize.mobile
                ? _FullScreenLayout(child: content)
                : _CardLayout(child: content);
          },
        ),
      ),
    );
  }

  static void _onStateChanged(BuildContext context, AuthState state) {
    if (state is AuthError) {
      AppSnackbar.showError(context, state.message);
    }
  }
}

class _FullScreenLayout extends StatelessWidget {
  const _FullScreenLayout({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: child,
        ),
      ),
    );
  }
}

class _CardLayout extends StatelessWidget {
  const _CardLayout({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: LoginScreen.cardMaxWidth,
          ),
          child: Card(
            key: LoginScreen.cardKey,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent({required this.config});

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<AuthBloc, bool>(
      (bloc) => bloc.state is AuthLoading,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _Brand(),
        const SizedBox(height: AppSpacing.xl),
        GoogleSignInButton(
          isLoading: isLoading,
          onPressed: config.isGoogleSignInConfigured
              ? () => _add(context, const AuthSignInRequested())
              : null,
        ),
        if (!config.isGoogleSignInConfigured) ...[
          const SizedBox(height: AppSpacing.xs),
          const Text(
            LoginScreen.notConfiguredMessage,
            style: AppTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
        if (config.devLoginEnabled) ...[
          const SizedBox(height: AppSpacing.sm),
          _DevLoginButton(isLoading: isLoading),
        ],
      ],
    );
  }
}

void _add(BuildContext context, AuthEvent event) =>
    context.read<AuthBloc>().add(event);

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(
          Icons.account_balance_wallet_outlined,
          size: LoginScreen.logoSize,
          color: AppColors.accentGold,
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          AppConstants.appName,
          style: AppTypography.heading1,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          AppConstants.tagline,
          style: AppTypography.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _DevLoginButton extends StatelessWidget {
  const _DevLoginButton({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: GoogleSignInButton.height,
      child: OutlinedButton.icon(
        key: LoginScreen.devLoginKey,
        onPressed: isLoading
            ? null
            : () => _add(context, const AuthDevSignInRequested()),
        icon: const Icon(Icons.developer_mode_outlined),
        label: const Text(LoginScreen.devLoginLabel),
      ),
    );
  }
}
