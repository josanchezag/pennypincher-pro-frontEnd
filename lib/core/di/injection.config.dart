// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pennypincher_pro/core/auth/session_refresher.dart' as _i1018;
import 'package:pennypincher_pro/core/auth/token_service.dart' as _i852;
import 'package:pennypincher_pro/core/config/app_config.dart' as _i504;
import 'package:pennypincher_pro/core/config/config_module.dart' as _i544;
import 'package:pennypincher_pro/core/network/auth_interceptor.dart' as _i93;
import 'package:pennypincher_pro/core/network/network_module.dart' as _i683;
import 'package:pennypincher_pro/core/router/app_router.dart' as _i446;
import 'package:pennypincher_pro/features/auth/data/datasource/auth_remote_datasource.dart'
    as _i113;
import 'package:pennypincher_pro/features/auth/data/datasource/google_auth_datasource.dart'
    as _i886;
import 'package:pennypincher_pro/features/auth/data/oauth/pkce_generator.dart'
    as _i449;
import 'package:pennypincher_pro/features/auth/data/oauth/web_authenticator.dart'
    as _i506;
import 'package:pennypincher_pro/features/auth/data/repository/auth_repository_impl.dart'
    as _i162;
import 'package:pennypincher_pro/features/auth/data/repository/repository_session_refresher.dart'
    as _i268;
import 'package:pennypincher_pro/features/auth/di/auth_module.dart' as _i381;
import 'package:pennypincher_pro/features/auth/domain/repository/auth_repository.dart'
    as _i246;
import 'package:pennypincher_pro/features/auth/domain/usecase/restore_session.dart'
    as _i180;
import 'package:pennypincher_pro/features/auth/domain/usecase/sign_in_with_dev_login.dart'
    as _i440;
import 'package:pennypincher_pro/features/auth/domain/usecase/sign_in_with_google.dart'
    as _i255;
import 'package:pennypincher_pro/features/auth/domain/usecase/sign_out.dart'
    as _i128;
import 'package:pennypincher_pro/features/auth/domain/usecase/watch_session_expiry.dart'
    as _i614;
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart'
    as _i238;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final configModule = _$ConfigModule();
    final networkModule = _$NetworkModule();
    final authModule = _$AuthModule();
    gh.singleton<_i504.AppConfig>(() => configModule.config);
    gh.lazySingleton<_i449.PkceGenerator>(() => _i449.PkceGenerator());
    gh.lazySingleton<_i852.TokenService>(
      () => _i852.TokenService(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i361.HttpClientAdapter>(
        () => networkModule.httpClientAdapter);
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.plainDio(
        gh<_i504.AppConfig>(),
        gh<_i361.HttpClientAdapter>(),
      ),
      instanceName: 'plainDio',
    );
    gh.lazySingleton<_i113.AuthRemoteDataSource>(() =>
        _i113.DioAuthRemoteDataSource(gh<_i361.Dio>(instanceName: 'plainDio')));
    gh.lazySingleton<_i506.WebAuthenticator>(
        () => _i506.FlutterWebAuthenticator());
    gh.lazySingleton<_i886.GoogleAuthDataSource>(
        () => _i886.GoogleAuthDataSource(
              gh<_i504.AppConfig>(),
              gh<_i449.PkceGenerator>(),
              gh<_i506.WebAuthenticator>(),
            ));
    gh.lazySingleton<_i246.AuthRepository>(() => _i162.AuthRepositoryImpl(
          gh<_i886.GoogleAuthDataSource>(),
          gh<_i113.AuthRemoteDataSource>(),
          gh<_i852.TokenService>(),
        ));
    gh.lazySingleton<_i1018.SessionRefresher>(
        () => _i268.RepositorySessionRefresher(gh<_i246.AuthRepository>()));
    gh.lazySingleton<_i93.AuthInterceptor>(() => _i93.AuthInterceptor(
          gh<_i852.TokenService>(),
          gh<_i1018.SessionRefresher>(),
          gh<_i361.Dio>(instanceName: 'plainDio'),
        ));
    gh.factory<_i255.SignInWithGoogle>(
        () => authModule.signInWithGoogle(gh<_i246.AuthRepository>()));
    gh.factory<_i440.SignInWithDevLogin>(
        () => authModule.signInWithDevLogin(gh<_i246.AuthRepository>()));
    gh.factory<_i128.SignOut>(
        () => authModule.signOut(gh<_i246.AuthRepository>()));
    gh.factory<_i180.RestoreSession>(
        () => authModule.restoreSession(gh<_i246.AuthRepository>()));
    gh.factory<_i614.WatchSessionExpiry>(
        () => authModule.watchSessionExpiry(gh<_i246.AuthRepository>()));
    gh.lazySingleton<_i238.AuthBloc>(() => _i238.AuthBloc(
          gh<_i180.RestoreSession>(),
          gh<_i255.SignInWithGoogle>(),
          gh<_i440.SignInWithDevLogin>(),
          gh<_i128.SignOut>(),
          gh<_i614.WatchSessionExpiry>(),
        ));
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio(
          gh<_i504.AppConfig>(),
          gh<_i361.HttpClientAdapter>(),
          gh<_i93.AuthInterceptor>(),
        ));
    gh.lazySingleton<_i446.AppRouter>(() => _i446.AppRouter(
          gh<_i504.AppConfig>(),
          gh<_i238.AuthBloc>(),
        ));
    return this;
  }
}

class _$ConfigModule extends _i544.ConfigModule {}

class _$NetworkModule extends _i683.NetworkModule {}

class _$AuthModule extends _i381.AuthModule {}
