import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/theme/app_theme.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';

/// Root widget: wires the theme, the router and the session state.
class PennyPincherApp extends StatelessWidget {
  const PennyPincherApp({
    required this.router,
    required this.authBloc,
    super.key,
  });

  final GoRouter router;
  final AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: authBloc,
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        routerConfig: router,
      ),
    );
  }
}
