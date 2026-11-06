import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/l10n/locale_cubit.dart';
import 'package:pennypincher_pro/core/theme/app_theme.dart';
import 'package:pennypincher_pro/core/utils/money_formatter.dart';
import 'package:pennypincher_pro/core/widgets/money_format_scope.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pennypincher_pro/features/settings/presentation/cubit/preferences_cubit.dart';

/// Root widget: wires the theme, the language, the currency of the
/// amounts, the router and the session state, and starts the session check
/// as soon as the app starts. Every sign-in loads the user's preferences; a
/// sign-out forgets them.
class PennyPincherApp extends StatefulWidget {
  const PennyPincherApp({
    required this.router,
    required this.authBloc,
    required this.localeCubit,
    required this.preferencesCubit,
    super.key,
  });

  final GoRouter router;
  final AuthBloc authBloc;
  final LocaleCubit localeCubit;
  final PreferencesCubit preferencesCubit;

  @override
  State<PennyPincherApp> createState() => _PennyPincherAppState();
}

class _PennyPincherAppState extends State<PennyPincherApp> {
  @override
  void initState() {
    super.initState();
    widget.authBloc.add(const AuthCheckRequested());
    if (widget.authBloc.state is AuthAuthenticated) {
      widget.preferencesCubit.load();
    }
  }

  /// A new session starts, or the current one ends.
  static bool _sessionChanged(AuthState previous, AuthState current) =>
      (current is AuthAuthenticated) != (previous is AuthAuthenticated) ||
      (current is AuthAuthenticated &&
          previous is AuthAuthenticated &&
          current.user.id != previous.user.id);

  void _onSessionChanged(BuildContext context, AuthState state) =>
      state is AuthAuthenticated
          ? widget.preferencesCubit.load()
          : widget.preferencesCubit.reset();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: widget.authBloc),
        BlocProvider<LocaleCubit>.value(value: widget.localeCubit),
        BlocProvider<PreferencesCubit>.value(value: widget.preferencesCubit),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        bloc: widget.authBloc,
        listenWhen: _sessionChanged,
        listener: _onSessionChanged,
        child: BlocBuilder<LocaleCubit, Locale>(
          bloc: widget.localeCubit,
          builder: (context, locale) => MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.dark,
            locale: locale,
            supportedLocales: AppLocales.supported,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            routerConfig: widget.router,
            builder: (context, child) => _MoneyFormat(
              languageCode: locale.languageCode,
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}

/// Formats every amount below it in the user's currency and the interface
/// language, and redraws them when either changes.
class _MoneyFormat extends StatelessWidget {
  const _MoneyFormat({required this.languageCode, required this.child});

  final String languageCode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final currency =
        context.select((PreferencesCubit cubit) => cubit.state.currency);
    return MoneyFormatScope(
      formatter: MoneyFormatter.of(currency, languageCode),
      child: child,
    );
  }
}
