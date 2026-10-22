import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';

/// Route protection: decides where a location must be redirected for the
/// current session state, or `null` to stay. The splash screen is never
/// redirected: it leaves by itself once the session check finishes.
abstract final class AuthGuard {
  /// Query parameter that keeps the location requested before signing in.
  static const String fromParam = 'from';

  static String? redirect(AuthState state, Uri location) {
    final path = location.path;
    if (path == AppRoute.splash.path) {
      return null;
    }
    final atLogin = path == AppRoute.login.path;
    if (state is AuthAuthenticated) {
      return atLogin
          ? targetAfterSignIn(location.queryParameters[fromParam])
          : null;
    }
    if (atLogin) {
      return null;
    }
    if (state is AuthUnauthenticated && state.signedOut) {
      return AppRoute.login.path;
    }
    final entry = _isResolving(state) ? AppRoute.splash : AppRoute.login;
    return _withFrom(entry.path, location.toString());
  }

  /// Login location that returns to [from] after signing in.
  static String loginFor(String? from) =>
      from == null ? AppRoute.login.path : _withFrom(AppRoute.login.path, from);

  /// The startup session check (or a sign-in) has not finished: wait on
  /// the splash. Signing out never passes through here.
  static bool _isResolving(AuthState state) =>
      state is AuthInitial || state is AuthLoading;

  /// Location to open after signing in: the requested in-app location, or
  /// the dashboard. Only relative locations of a known protected route are
  /// followed; anything else (schemes, hosts, backslashes, unknown paths or
  /// the splash and login screens) falls back to the dashboard.
  static String targetAfterSignIn(String? from) =>
      from != null && _isSafeTarget(from) ? from : AppRoute.dashboard.path;

  static bool _isSafeTarget(String from) {
    final uri = Uri.tryParse(from);
    if (uri == null || uri.hasScheme || uri.hasAuthority) {
      return false;
    }
    if (_hasBackslash(from) || !uri.path.startsWith('/')) {
      return false;
    }
    final route = AppRoute.matching(uri.path);
    return route != null && AppRoute.shellRoutes.contains(route);
  }

  /// Raw or percent-encoded backslash: browsers read `/\host` as `//host`.
  static bool _hasBackslash(String from) =>
      from.contains(_backslash) ||
      from.toLowerCase().contains(_encodedBackslash);

  static const String _backslash = r'\';
  static const String _encodedBackslash = '%5c';

  static String _withFrom(String path, String from) => Uri(
        path: path,
        queryParameters: {fromParam: from},
      ).toString();
}
