import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/error/failure.dart';
import 'package:pennypincher_pro/features/auth/domain/entity/user_entity.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/sign_in_with_dev_login.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/sign_in_with_google.dart';
import 'package:pennypincher_pro/features/auth/domain/usecase/sign_out.dart';

part 'auth_event.dart';
part 'auth_state.dart';

typedef _SignInAction = Future<Either<Failure, User>> Function();

/// Owns the session state of the app. One instance lives for the whole
/// app so the router and every screen observe the same session.
@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._signInWithGoogle, this._signInWithDevLogin, this._signOut)
      : super(const AuthInitial()) {
    on<AuthSignInRequested>((_, emit) => _signIn(_signInWithGoogle.call, emit));
    on<AuthDevSignInRequested>(
      (_, emit) => _signIn(_signInWithDevLogin.call, emit),
    );
    on<AuthSignOutRequested>(_onSignOutRequested);
  }

  final SignInWithGoogle _signInWithGoogle;
  final SignInWithDevLogin _signInWithDevLogin;
  final SignOut _signOut;

  Future<void> _signIn(_SignInAction action, Emitter<AuthState> emit) async {
    if (state is AuthLoading) {
      return;
    }
    emit(const AuthLoading());
    final result = await action();
    emit(
      result.fold(
        (failure) => AuthError(failure.message),
        AuthAuthenticated.new,
      ),
    );
  }

  /// The local session ends even when the backend cannot be reached.
  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await _signOut();
    emit(const AuthUnauthenticated());
  }
}
