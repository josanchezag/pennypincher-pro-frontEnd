import 'package:pennypincher_pro/core/error/app_exception.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/oauth_constants.dart';

/// The authorization step with Google did not produce a usable code.
class OAuthException extends AppException {
  const OAuthException({required super.code, required super.message});

  OAuthException.cancelled()
      : this(code: OAuthErrorCodes.cancelled, message: OAuthMessages.cancelled);

  OAuthException.stateMismatch()
      : this(
          code: OAuthErrorCodes.stateMismatch,
          message: OAuthMessages.stateMismatch,
        );

  OAuthException.failed()
      : this(code: OAuthErrorCodes.failed, message: OAuthMessages.failed);

  OAuthException.notConfigured()
      : this(
          code: OAuthErrorCodes.notConfigured,
          message: OAuthMessages.notConfigured,
        );
}
