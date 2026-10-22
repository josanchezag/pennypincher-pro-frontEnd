import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/oauth_exception.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/stored_callback.dart';

/// Opens the authorization page and resolves with the callback URL.
abstract interface class WebAuthenticator {
  /// Removes a callback URL left in browser storage by an earlier,
  /// abandoned sign-in (see `web/auth_callback.js`).
  void clearPendingCallback();

  Future<String> authenticate({
    required Uri url,
    required String callbackUrlScheme,
  });
}

/// [WebAuthenticator] backed by `flutter_web_auth_2`. On the web the
/// callback page `web/auth.html` hands the URL back to the app.
@LazySingleton(as: WebAuthenticator)
class FlutterWebAuthenticator implements WebAuthenticator {
  @override
  void clearPendingCallback() => clearStoredCallback();

  @override
  Future<String> authenticate({
    required Uri url,
    required String callbackUrlScheme,
  }) async {
    try {
      return await FlutterWebAuth2.authenticate(
        url: url.toString(),
        callbackUrlScheme: callbackUrlScheme,
      );
    } on PlatformException {
      throw const OAuthException.cancelled();
    }
  }
}
