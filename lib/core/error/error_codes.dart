/// Error codes produced on the client. Backend codes (for example
/// `GOOGLE_AUTH_FAILED` or `UNAUTHORIZED`) are passed through unchanged.
abstract final class ErrorCodes {
  static const String networkError = 'NETWORK_ERROR';
  static const String invalidResponse = 'INVALID_RESPONSE';
  static const String unknown = 'UNKNOWN_ERROR';

  /// Backend: another tab rotated the refresh cookie first. The browser
  /// already holds the newer cookie, so the refresh is simply retried.
  static const String refreshSuperseded = 'REFRESH_SUPERSEDED';
}

/// User-facing messages for errors without a backend message.
abstract final class ErrorMessages {
  static const String network =
      'Could not reach the server. Check your connection and try again.';
  static const String invalidResponse =
      'The server sent an unexpected response.';
  static const String unexpected = 'Something went wrong. Please try again.';
}
