import 'package:pennypincher_pro/features/auth/data/oauth/oauth_constants.dart';
import 'package:web/web.dart';

/// Drops a callback URL that `web/auth_callback.js` stored for an abandoned
/// sign-in, so an old authorization code never lingers in the browser.
void clearStoredCallback() =>
    window.localStorage.removeItem(OAuthStorage.callbackKey);
