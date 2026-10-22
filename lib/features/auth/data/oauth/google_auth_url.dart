import 'package:pennypincher_pro/features/auth/data/oauth/oauth_constants.dart';

/// Builds the Google authorization request URL.
abstract final class GoogleAuthUrl {
  static Uri build({
    required String clientId,
    required String redirectUri,
    required String codeChallenge,
    required String state,
  }) =>
      Uri.https(GoogleOAuth.authorizationHost, GoogleOAuth.authorizationPath, {
        OAuthParams.clientId: clientId,
        OAuthParams.redirectUri: redirectUri,
        OAuthParams.responseType: GoogleOAuth.responseType,
        OAuthParams.scope: GoogleOAuth.scope,
        OAuthParams.codeChallenge: codeChallenge,
        OAuthParams.codeChallengeMethod: GoogleOAuth.codeChallengeMethod,
        OAuthParams.state: state,
        OAuthParams.prompt: GoogleOAuth.prompt,
      });
}
