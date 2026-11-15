import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/shortcuts/ant_expense_shortcut.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/screen/dashboard_screen.dart';

/// The dashboard screen, with a fresh bloc that starts loading as soon as
/// the screen opens and closes with it, and the shortcut that adds an ant
/// expense from its quick actions (looked up the first time it is used).
abstract final class DashboardPages {
  static final Map<AppRoute, WidgetBuilder> builders = {
    AppRoute.dashboard: (_) => RepositoryProvider<AntExpenseShortcut>(
          create: (_) => getIt<AntExpenseShortcut>(),
          child: BlocProvider<DashboardBloc>(
            create: (_) =>
                getIt<DashboardBloc>()..add(const DashboardLoadRequested()),
            child: const DashboardScreen(),
          ),
        ),
  };
}
