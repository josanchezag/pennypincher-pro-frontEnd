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
import 'package:pennypincher_pro/core/crud/domain/usecase/crud_use_cases.dart'
    as _i678;
import 'package:pennypincher_pro/core/network/auth_interceptor.dart' as _i93;
import 'package:pennypincher_pro/core/network/network_module.dart' as _i683;
import 'package:pennypincher_pro/core/router/app_router.dart' as _i446;
import 'package:pennypincher_pro/core/time/clock.dart' as _i656;
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
import 'package:pennypincher_pro/features/net_worth/data/datasource/asset_remote_datasource.dart'
    as _i392;
import 'package:pennypincher_pro/features/net_worth/data/datasource/liability_remote_datasource.dart'
    as _i277;
import 'package:pennypincher_pro/features/net_worth/data/datasource/net_worth_remote_datasource.dart'
    as _i464;
import 'package:pennypincher_pro/features/net_worth/data/repository/asset_repository_impl.dart'
    as _i171;
import 'package:pennypincher_pro/features/net_worth/data/repository/liability_repository_impl.dart'
    as _i418;
import 'package:pennypincher_pro/features/net_worth/data/repository/net_worth_repository_impl.dart'
    as _i257;
import 'package:pennypincher_pro/features/net_worth/di/net_worth_module.dart'
    as _i125;
import 'package:pennypincher_pro/features/net_worth/domain/entity/asset_entity.dart'
    as _i499;
import 'package:pennypincher_pro/features/net_worth/domain/entity/liability_entity.dart'
    as _i941;
import 'package:pennypincher_pro/features/net_worth/domain/repository/asset_repository.dart'
    as _i365;
import 'package:pennypincher_pro/features/net_worth/domain/repository/liability_repository.dart'
    as _i90;
import 'package:pennypincher_pro/features/net_worth/domain/repository/net_worth_repository.dart'
    as _i606;
import 'package:pennypincher_pro/features/net_worth/domain/usecase/net_worth_use_cases.dart'
    as _i424;
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/asset_bloc.dart'
    as _i1068;
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/liability_bloc.dart'
    as _i944;
import 'package:pennypincher_pro/features/net_worth/presentation/bloc/net_worth_bloc.dart'
    as _i697;

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
    final netWorthModule = _$NetWorthModule();
    gh.singleton<_i504.AppConfig>(() => configModule.config);
    gh.lazySingleton<_i449.PkceGenerator>(() => _i449.PkceGenerator());
    gh.lazySingleton<_i852.TokenService>(
      () => _i852.TokenService(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i361.HttpClientAdapter>(
        () => networkModule.httpClientAdapter);
    gh.lazySingleton<_i656.Clock>(() => _i656.SystemClock());
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
    gh.lazySingleton<_i392.AssetRemoteDataSource>(
        () => _i392.AssetRemoteDataSource(gh<_i361.Dio>()));
    gh.lazySingleton<_i277.LiabilityRemoteDataSource>(
        () => _i277.LiabilityRemoteDataSource(gh<_i361.Dio>()));
    gh.lazySingleton<_i464.NetWorthRemoteDataSource>(
        () => _i464.NetWorthRemoteDataSource(gh<_i361.Dio>()));
    gh.lazySingleton<_i446.AppRouter>(() => _i446.AppRouter(
          gh<_i504.AppConfig>(),
          gh<_i238.AuthBloc>(),
        ));
    gh.lazySingleton<_i365.AssetRepository>(
        () => _i171.AssetRepositoryImpl(gh<_i392.AssetRemoteDataSource>()));
    gh.lazySingleton<_i606.NetWorthRepository>(() =>
        _i257.NetWorthRepositoryImpl(gh<_i464.NetWorthRemoteDataSource>()));
    gh.lazySingleton<_i90.LiabilityRepository>(() =>
        _i418.LiabilityRepositoryImpl(gh<_i277.LiabilityRemoteDataSource>()));
    gh.factory<_i678.GetItems<_i499.Asset, _i499.AssetCategory>>(
        () => netWorthModule.getAssets(gh<_i365.AssetRepository>()));
    gh.factory<_i678.SaveItem<_i499.Asset, _i499.AssetCategory>>(
        () => netWorthModule.saveAsset(gh<_i365.AssetRepository>()));
    gh.factory<_i678.DeleteItem<_i499.Asset, _i499.AssetCategory>>(
        () => netWorthModule.deleteAsset(gh<_i365.AssetRepository>()));
    gh.factory<_i1068.AssetBloc>(() => _i1068.AssetBloc(
          gh<_i678.GetItems<_i499.Asset, _i499.AssetCategory>>(),
          gh<_i678.SaveItem<_i499.Asset, _i499.AssetCategory>>(),
          gh<_i678.DeleteItem<_i499.Asset, _i499.AssetCategory>>(),
        ));
    gh.factory<_i678.GetItems<_i941.Liability, _i941.LiabilityCategory>>(
        () => netWorthModule.getLiabilities(gh<_i90.LiabilityRepository>()));
    gh.factory<_i678.SaveItem<_i941.Liability, _i941.LiabilityCategory>>(
        () => netWorthModule.saveLiability(gh<_i90.LiabilityRepository>()));
    gh.factory<_i678.DeleteItem<_i941.Liability, _i941.LiabilityCategory>>(
        () => netWorthModule.deleteLiability(gh<_i90.LiabilityRepository>()));
    gh.factory<_i944.LiabilityBloc>(() => _i944.LiabilityBloc(
          gh<_i678.GetItems<_i941.Liability, _i941.LiabilityCategory>>(),
          gh<_i678.SaveItem<_i941.Liability, _i941.LiabilityCategory>>(),
          gh<_i678.DeleteItem<_i941.Liability, _i941.LiabilityCategory>>(),
        ));
    gh.factory<_i424.GetNetWorthSnapshots>(() =>
        netWorthModule.getNetWorthSnapshots(gh<_i606.NetWorthRepository>()));
    gh.factory<_i424.GetCurrentNetWorth>(() =>
        netWorthModule.getCurrentNetWorth(gh<_i606.NetWorthRepository>()));
    gh.factory<_i424.CreateSnapshot>(
        () => netWorthModule.createSnapshot(gh<_i606.NetWorthRepository>()));
    gh.factory<_i697.NetWorthBloc>(() => _i697.NetWorthBloc(
          gh<_i424.GetCurrentNetWorth>(),
          gh<_i424.GetNetWorthSnapshots>(),
          gh<_i424.CreateSnapshot>(),
          gh<_i656.Clock>(),
        ));
    return this;
  }
}

class _$ConfigModule extends _i544.ConfigModule {}

class _$NetworkModule extends _i683.NetworkModule {}

class _$AuthModule extends _i381.AuthModule {}

class _$NetWorthModule extends _i125.NetWorthModule {}
