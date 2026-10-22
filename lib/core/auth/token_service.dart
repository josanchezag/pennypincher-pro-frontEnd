import 'package:injectable/injectable.dart';

/// Holds the access token in memory only. It is never written to browser
/// storage: after a page reload the session is restored with the httpOnly
/// refresh cookie instead.
@lazySingleton
class TokenService {
  String? _accessToken;

  String? get accessToken => _accessToken;

  bool get hasToken => _accessToken != null;

  void save(String accessToken) => _accessToken = accessToken;

  void clear() => _accessToken = null;
}
