import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/bloc/goals_bloc.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/screen/goals_screen.dart';

/// Screens of the goals section, each with a fresh bloc that starts
/// loading as soon as the screen opens and closes with it.
abstract final class FinancialGoalsPages {
  static final Map<AppRoute, WidgetBuilder> builders = {
    AppRoute.goals: (_) => BlocProvider<GoalsBloc>(
          create: (_) =>
              getIt<GoalsBloc>()..add(const CrudLoadRequested<GoalDraft>()),
          child: const GoalsScreen(),
        ),
  };
}
