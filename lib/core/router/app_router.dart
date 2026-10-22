import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/layout/app_shell.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/widgets/placeholder_screen.dart';
import 'package:pennypincher_pro/features/auth/presentation/screen/splash_screen.dart';

/// go_router configuration with a named route for every screen.
@lazySingleton
class AppRouter {
  AppRouter() : config = buildRouter();

  final GoRouter config;

  /// Builds a fresh router; exposed so tests can start from any location.
  static GoRouter buildRouter({String? initialLocation}) => GoRouter(
        initialLocation: initialLocation ?? AppRoute.splash.path,
        errorBuilder: (context, state) => const NotFoundScreen(),
        routes: [
          GoRoute(
            path: AppRoute.splash.path,
            name: AppRoute.splash.name,
            builder: (context, state) => const SplashScreen(),
          ),
          _placeholderRoute(AppRoute.login),
          ShellRoute(
            builder: (context, state, child) => AppShell(
              location: state.uri.path,
              child: child,
            ),
            routes: AppRoute.shellRoutes.map(_placeholderRoute).toList(),
          ),
        ],
      );

  static GoRoute _placeholderRoute(AppRoute route) => GoRoute(
        path: route.path,
        name: route.name,
        builder: (context, state) => PlaceholderScreen(route: route),
      );
}
