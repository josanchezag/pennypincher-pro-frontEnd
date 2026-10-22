import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:pennypincher_pro/app.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/core/router/app_router.dart';
import 'package:pennypincher_pro/features/auth/data/oauth/web_authenticator.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  configureDependencies();
  getIt<WebAuthenticator>().clearPendingCallback();
  runApp(
    PennyPincherApp(
      router: getIt<AppRouter>().config,
      authBloc: getIt<AuthBloc>(),
    ),
  );
}
