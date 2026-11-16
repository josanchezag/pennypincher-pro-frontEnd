import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/features/financial_goals/domain/entity/financial_goal_entity.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/bloc/goal_plan_basis_cubit.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/bloc/goal_projection_bloc.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/bloc/goals_bloc.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/screen/goal_projection_screen.dart';
import 'package:pennypincher_pro/features/financial_goals/presentation/screen/goals_screen.dart';

/// Screens of the goals section, each with fresh blocs that start loading
/// as soon as the screen opens and close with it. The goals screen also
/// loads the income and net worth its form previews plans from.
abstract final class FinancialGoalsPages {
  static final Map<AppRoute, WidgetBuilder> builders = {
    AppRoute.goals: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<GoalsBloc>(
              create: (_) =>
                  getIt<GoalsBloc>()..add(const CrudLoadRequested<GoalDraft>()),
            ),
            BlocProvider<GoalPlanBasisCubit>(
              // Loaded with the screen, so the form has it when it opens.
              lazy: false,
              create: (_) => getIt<GoalPlanBasisCubit>()..load(),
            ),
          ],
          child: const GoalsScreen(),
        ),
    AppRoute.goalProjection: (_) => const GoalProjectionPage(),
  };
}

/// The projection screen of the goal named in the path, with its bloc.
class GoalProjectionPage extends StatelessWidget {
  const GoalProjectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final goalId =
        GoRouterState.of(context).pathParameters[AppRoute.goalIdParam] ?? '';
    return BlocProvider<GoalProjectionBloc>(
      key: ValueKey(goalId),
      create: (_) =>
          getIt<GoalProjectionBloc>()..add(GoalProjectionRequested(goalId)),
      child: GoalProjectionScreen(goalId: goalId),
    );
  }
}
