import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pennypincher_pro/core/di/injection.config.dart';

/// Global service locator.
final GetIt getIt = GetIt.instance;

/// Registers every `@injectable` dependency. Call once before `runApp`.
@InjectableInit()
void configureDependencies() => getIt.init();
