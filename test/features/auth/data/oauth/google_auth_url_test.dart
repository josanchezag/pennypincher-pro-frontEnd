import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/google_auth_url.dart';

void main() {
  test('builds the Google authorization code request with PKCE', () {
    final url = GoogleAuthUrl.build(
      clientId: 'client-id',
      redirectUri: 'http://localhost:3000/auth.html',
      codeChallenge: 'challenge',
      state: 'state-1',
    );

    expect(url.scheme, 'https');
    expect(url.host, 'accounts.google.com');
    expect(url.path, '/o/oauth2/v2/auth');
    expect(url.queryParameters, {
      'client_id': 'client-id',
      'redirect_uri': 'http://localhost:3000/auth.html',
      'response_type': 'code',
      'scope': 'openid email profile',
      'code_challenge': 'challenge',
      'code_challenge_method': 'S256',
      'state': 'state-1',
      'prompt': 'select_account',
    });
  });
}
