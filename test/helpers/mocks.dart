import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/features/auth/domain/entity/user_entity.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

final User testUser = User(
  id: '7d3f9a52-0c1e-4b8e-9a51-2f6d8c4b1e07',
  email: 'ada@example.com',
  name: 'Ada Lovelace',
  pictureUrl: 'https://lh3.googleusercontent.com/a/ada',
  createdAt: DateTime.utc(2026, 10, 1, 12),
);

/// An [AuthBloc] double that stays in [state] and then emits [stream].
MockAuthBloc mockAuthBloc(
  AuthState state, {
  Stream<AuthState> stream = const Stream.empty(),
}) {
  final bloc = MockAuthBloc();
  whenListen(bloc, stream, initialState: state);
  addTearDown(bloc.close);
  return bloc;
}
