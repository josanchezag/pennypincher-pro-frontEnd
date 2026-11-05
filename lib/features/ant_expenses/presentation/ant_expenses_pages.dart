import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/features/ant_expenses/domain/entity/ant_expense_entity.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_expense_bloc.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/bloc/ant_insights_cubit.dart';
import 'package:pennypincher_pro/features/ant_expenses/presentation/screen/ant_expenses_screen.dart';

/// The ant expenses screen, with a fresh bloc and cubit that start loading
/// as soon as it opens and close with it.
abstract final class AntExpensesPages {
  static final Map<AppRoute, WidgetBuilder> builders = {
    AppRoute.expensesAnt: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<AntExpenseBloc>(
              create: (_) => getIt<AntExpenseBloc>()
                ..add(const CrudLoadRequested<AntExpenseDraft>()),
            ),
            BlocProvider<AntInsightsCubit>(
              create: (_) => getIt<AntInsightsCubit>()..load(),
            ),
          ],
          child: const AntExpensesScreen(),
        ),
  };
}
