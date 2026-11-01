import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';

/// What the login screen says when a sign-in fails. Sign-ins refused by the
/// backend access rules get a fixed message instead of the backend text.
abstract final class SignInMessages {
  static const String accountNotAllowed =
      "This Google account isn't allowed to use PennyPincher Pro.";
  static const String registrationDisabled = 'Sign-ups are closed right now.';

  static String forFailure(Failure failure) => switch (failure) {
        ServerFailure(code: ErrorCodes.accountNotAllowed) => accountNotAllowed,
        ServerFailure(code: ErrorCodes.registrationDisabled) =>
          registrationDisabled,
        _ => failure.message,
      };
}
