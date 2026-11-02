import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';

/// What the login screen says when a sign-in fails, in the current
/// interface language. Sign-ins refused by the backend access rules get a
/// fixed message instead of the backend text.
abstract final class SignInMessages {
  static String get accountNotAllowed =>
      CurrentL10n.texts.signInAccountNotAllowed;

  static String get registrationDisabled =>
      CurrentL10n.texts.signInRegistrationDisabled;

  static String forFailure(Failure failure) => switch (failure) {
        ServerFailure(code: ErrorCodes.accountNotAllowed) => accountNotAllowed,
        ServerFailure(code: ErrorCodes.registrationDisabled) =>
          registrationDisabled,
        _ => failure.message,
      };
}
