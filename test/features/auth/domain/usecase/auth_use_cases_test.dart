import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/auth/domain/entity/user_entity.dart';
import 'package:pennypincher_pro/features/auth/domain/repository/auth_repository.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/restore_session.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/sign_in_with_dev_login.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/sign_in_with_google.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/sign_out.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/watch_session_expiry.dart';

import '../../../../helpers/mocks.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  final Either<Failure, User> signedIn = Right(testUser);

  setUp(() => repository = _MockAuthRepository());

  test('SignInWithGoogle delegates to the repository', () async {
    when(repository.signInWithGoogle).thenAnswer((_) async => signedIn);

    expect(await SignInWithGoogle(repository)(), signedIn);
  });

  test('SignInWithDevLogin delegates to the repository', () async {
    when(repository.signInWithDevLogin).thenAnswer((_) async => signedIn);

    expect(await SignInWithDevLogin(repository)(), signedIn);
  });

  test('RestoreSession refreshes the session', () async {
    when(repository.refreshSession).thenAnswer((_) async => signedIn);

    expect(await RestoreSession(repository)(), signedIn);
  });

  test('SignOut delegates to the repository', () async {
    when(repository.signOut).thenAnswer((_) async => const Right(unit));

    expect(await SignOut(repository)(), const Right<Failure, Unit>(unit));
  });

  test('WatchSessionExpiry exposes the repository expirations', () {
    const expirations = Stream<void>.empty();
    when(() => repository.sessionExpirations).thenAnswer((_) => expirations);

    expect(WatchSessionExpiry(repository)(), same(expirations));
  });
}
