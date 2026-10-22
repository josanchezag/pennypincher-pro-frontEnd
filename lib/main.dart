import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:pennypincher_pro/app.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/core/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  configureDependencies();
  runApp(PennyPincherApp(router: getIt<AppRouter>().config));
}
