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
import 'package:pennypincher_pro/core/config/app_config.dart' as _i504;
import 'package:pennypincher_pro/core/config/config_module.dart' as _i544;
import 'package:pennypincher_pro/core/network/network_module.dart' as _i683;
import 'package:pennypincher_pro/core/router/app_router.dart' as _i446;

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
    gh.singleton<_i504.AppConfig>(() => configModule.config);
    gh.lazySingleton<_i446.AppRouter>(() => _i446.AppRouter());
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio(gh<_i504.AppConfig>()));
    return this;
  }
}

class _$ConfigModule extends _i544.ConfigModule {}

class _$NetworkModule extends _i683.NetworkModule {}
