/// Result of trying to renew the access token with the refresh cookie.
enum RefreshOutcome {
  /// A new access token is available.
  refreshed,

  /// The backend rejected the refresh cookie: the session is over.
  rejected,

  /// The refresh could not be completed (network or server error).
  failed,
}

/// Renews the access token. Implemented by the auth feature so the network
/// layer does not depend on it.
abstract interface class SessionRefresher {
  Future<RefreshOutcome> refreshSession();
}
