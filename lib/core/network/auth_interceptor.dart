import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/auth/session_refresher.dart';
import 'package:pennypincher_pro/core/auth/token_service.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';

/// Adds the bearer token to API calls and, on a `401`, refreshes the
/// session once and retries the request once.
///
/// Errors are handled one at a time (queued), so concurrent `401`s share a
/// single refresh without extra locking: later ones see that the token
/// changed and only retry.
/// Retries go through [_retryClient], a client without this interceptor,
/// so a retried request can never trigger another refresh. `/auth/*`
/// calls never get a bearer and never trigger a refresh.
@lazySingleton
class AuthInterceptor extends QueuedInterceptorsWrapper {
  AuthInterceptor(
    this._tokens,
    this._refresher,
    @Named(NetworkNames.plainDio) this._retryClient,
  );

  static const String bearerPrefix = 'Bearer ';

  final TokenService _tokens;
  final SessionRefresher _refresher;
  final Dio _retryClient;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokens.accessToken;
    if (token != null && !_isAuthEndpoint(options)) {
      options.headers[HttpHeaders.authorization] = '$bearerPrefix$token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final sentToken = _sentToken(err.requestOptions);
    if (!_isUnauthorized(err) || sentToken == null) {
      return handler.next(err);
    }
    final token = await _currentOrRefreshedToken(sentToken);
    if (token == null) {
      return handler.next(err);
    }
    try {
      handler.resolve(await _retry(err.requestOptions, token));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<String?> _currentOrRefreshedToken(String sentToken) async {
    final current = _tokens.accessToken;
    if (current == null || current != sentToken) {
      return current;
    }
    final outcome = await _refresher.refreshSession();
    if (outcome == RefreshOutcome.rejected) {
      _tokens.expireSession();
    }
    return outcome == RefreshOutcome.refreshed ? _tokens.accessToken : null;
  }

  Future<Response<Object?>> _retry(RequestOptions options, String token) =>
      _retryClient.fetch<Object?>(
        options.copyWith(
          headers: {
            ...options.headers,
            HttpHeaders.authorization: '$bearerPrefix$token',
          },
        ),
      );

  static bool _isUnauthorized(DioException err) =>
      err.response?.statusCode == HttpStatusCodes.unauthorized &&
      !_isAuthEndpoint(err.requestOptions);

  static bool _isAuthEndpoint(RequestOptions options) =>
      options.path.startsWith(ApiPaths.authPrefix);

  static String? _sentToken(RequestOptions options) {
    final header = options.headers[HttpHeaders.authorization];
    return header is String && header.startsWith(bearerPrefix)
        ? header.substring(bearerPrefix.length)
        : null;
  }
}
