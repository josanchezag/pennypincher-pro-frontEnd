import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/theme/app_theme.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';

/// Root widget: wires the theme, the router and the session state, and
/// starts the session check as soon as the app starts.
class PennyPincherApp extends StatefulWidget {
  const PennyPincherApp({
    required this.router,
    required this.authBloc,
    super.key,
  });

  final GoRouter router;
  final AuthBloc authBloc;

  @override
  State<PennyPincherApp> createState() => _PennyPincherAppState();
}

class _PennyPincherAppState extends State<PennyPincherApp> {
  @override
  void initState() {
    super.initState();
    widget.authBloc.add(const AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: widget.authBloc,
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        routerConfig: widget.router,
      ),
    );
  }
}
