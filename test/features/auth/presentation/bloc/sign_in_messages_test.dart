import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/error/error_codes.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/sign_in_messages.dart';

void main() {
  test('explains that the Google account is not allowed', () {
    const failure = ServerFailure(
      'This account is not allowed to sign in',
      code: ErrorCodes.accountNotAllowed,
    );

    expect(
      SignInMessages.forFailure(failure),
      "This Google account isn't allowed to use PennyPincher Pro.",
    );
  });

  test('explains that sign-ups are closed', () {
    const failure = ServerFailure(
      'Registration is closed',
      code: ErrorCodes.registrationDisabled,
    );

    expect(
      SignInMessages.forFailure(failure),
      'Sign-ups are closed right now.',
    );
  });

  test('keeps the failure message for every other error', () {
    expect(
      SignInMessages.forFailure(
        const ServerFailure('Google rejected it', code: 'GOOGLE_AUTH_FAILED'),
      ),
      'Google rejected it',
    );
    expect(
      SignInMessages.forFailure(const NetworkFailure('offline')),
      'offline',
    );
  });
}
