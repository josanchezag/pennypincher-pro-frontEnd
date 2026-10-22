import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/config/app_config.dart';
import 'package:pennypincher_pro/features/auth/data/model/google_authorization.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/google_auth_url.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/oauth_constants.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/oauth_exception.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/pkce_generator.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/web_authenticator.dart';

/// Obtains a Google authorization code with PKCE. The verifier and the
/// state live only for the duration of one [authorize] call.
@lazySingleton
class GoogleAuthDataSource {
  GoogleAuthDataSource(this._config, this._pkce, this._authenticator);

  final AppConfig _config;
  final PkceGenerator _pkce;
  final WebAuthenticator _authenticator;

  /// Throws [OAuthException] when the flow is cancelled, misconfigured or
  /// the callback does not match the request.
  Future<GoogleAuthorization> authorize() async {
    if (!_config.isGoogleSignInConfigured) {
      throw const OAuthException.notConfigured();
    }
    _authenticator.clearPendingCallback();
    final verifier = _pkce.generateVerifier();
    final state = _pkce.generateState();
    final url = GoogleAuthUrl.build(
      clientId: _config.googleClientId,
      redirectUri: _config.googleRedirectUri,
      codeChallenge: PkceGenerator.challengeFor(verifier),
      state: state,
    );
    final callback = await _authenticator.authenticate(
      url: url,
      callbackUrlScheme: Uri.parse(_config.googleRedirectUri).scheme,
    );
    return GoogleAuthorization(
      code: _codeFrom(callback, expectedState: state),
      codeVerifier: verifier,
      redirectUri: _config.googleRedirectUri,
    );
  }

  static String _codeFrom(String callback, {required String expectedState}) {
    final params = Uri.tryParse(callback)?.queryParameters;
    if (params == null) {
      throw const OAuthException.failed();
    }
    if (params.containsKey(OAuthParams.error)) {
      throw const OAuthException.cancelled();
    }
    final actualState = params[OAuthParams.state];
    final stateIsValid = PkceGenerator.stateMatches(
      expected: expectedState,
      actual: actualState,
    );
    if (!stateIsValid) {
      throw const OAuthException.stateMismatch();
    }
    final code = params[OAuthParams.code];
    if (code == null || code.isEmpty) {
      throw const OAuthException.failed();
    }
    return code;
  }
}
