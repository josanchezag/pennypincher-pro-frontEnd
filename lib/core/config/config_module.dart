import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/config/app_config.dart';

/// Registers the compile-time configuration in the service locator.
@module
abstract class ConfigModule {
  @singleton
  AppConfig get config => AppConfig.fromEnvironment();
}
