import 'dart:async';

import 'package:injectable/injectable.dart';

/// Holds the access token in memory only. It is never written to browser
/// storage: after a page reload the session is restored with the httpOnly
/// refresh cookie instead.
@lazySingleton
class TokenService {
  final StreamController<void> _expirations = StreamController.broadcast();
  String? _accessToken;

  String? get accessToken => _accessToken;

  bool get hasToken => _accessToken != null;

  /// Emits when the session can no longer be refreshed.
  Stream<void> get sessionExpired => _expirations.stream;

  void save(String accessToken) => _accessToken = accessToken;

  void clear() => _accessToken = null;

  /// Forgets the token and notifies listeners that the user must sign in.
  void expireSession() {
    clear();
    _expirations.add(null);
  }

  @disposeMethod
  Future<void> dispose() => _expirations.close();
}
