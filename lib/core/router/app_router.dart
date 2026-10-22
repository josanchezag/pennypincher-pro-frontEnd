import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/config/app_config.dart';
import 'package:pennypincher_pro/core/layout/app_shell.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/router/auth_guard.dart';
import 'package:pennypincher_pro/core/router/refresh_listenable.dart';
import 'package:pennypincher_pro/core/widgets/placeholder_screen.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pennypincher_pro/features/auth/presentation/screen/login_screen.dart';
import 'package:pennypincher_pro/features/auth/presentation/screen/splash_screen.dart';

/// go_router configuration with a named route for every screen, protected
/// by [AuthGuard] and re-evaluated on every session change.
@lazySingleton
class AppRouter {
  AppRouter(AppConfig appConfig, AuthBloc authBloc)
      : config = buildRouter(appConfig: appConfig, authBloc: authBloc);

  final GoRouter config;

  /// Builds a fresh router; exposed so tests can start from any location.
  static GoRouter buildRouter({
    required AppConfig appConfig,
    required AuthBloc authBloc,
    String? initialLocation,
  }) =>
      GoRouter(
        initialLocation: initialLocation ?? AppRoute.splash.path,
        refreshListenable: StreamRefreshListenable(authBloc.stream),
        redirect: (context, state) =>
            AuthGuard.redirect(authBloc.state, state.uri),
        errorBuilder: (context, state) => const NotFoundScreen(),
        routes: _routes(appConfig, authBloc),
      );

  static List<RouteBase> _routes(AppConfig appConfig, AuthBloc authBloc) => [
        GoRoute(
          path: AppRoute.splash.path,
          name: AppRoute.splash.name,
          builder: (context, state) => SplashScreen(
            from: state.uri.queryParameters[AuthGuard.fromParam],
          ),
        ),
        GoRoute(
          path: AppRoute.login.path,
          name: AppRoute.login.name,
          builder: (context, state) => LoginScreen(config: appConfig),
        ),
        ShellRoute(
          builder: (context, state, child) => AppShell(
            location: state.uri.path,
            onSignOut: () => authBloc.add(const AuthSignOutRequested()),
            child: child,
          ),
          routes: AppRoute.shellRoutes.map(_placeholderRoute).toList(),
        ),
      ];

  static GoRoute _placeholderRoute(AppRoute route) => GoRoute(
        path: route.path,
        name: route.name,
        builder: (context, state) => PlaceholderScreen(route: route),
      );
}
