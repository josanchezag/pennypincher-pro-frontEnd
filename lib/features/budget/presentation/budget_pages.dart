import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/features/budget/domain/entity/income_source_entity.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/budget_comparison_bloc.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/income_source_bloc.dart';
import 'package:pennypincher_pro/features/budget/presentation/bloc/monthly_budget_bloc.dart';
import 'package:pennypincher_pro/features/budget/presentation/screen/budget_comparison_screen.dart';
import 'package:pennypincher_pro/features/budget/presentation/screen/budget_overview_screen.dart';
import 'package:pennypincher_pro/features/budget/presentation/screen/income_sources_screen.dart';

/// Screens of the budget section, each with a fresh bloc that starts
/// loading as soon as the screen opens and closes with it.
abstract final class BudgetPages {
  static final Map<AppRoute, WidgetBuilder> builders = {
    AppRoute.budgetOverview: (_) => BlocProvider<MonthlyBudgetBloc>(
          create: (_) =>
              getIt<MonthlyBudgetBloc>()..add(const MonthlyBudgetStarted()),
          child: const BudgetOverviewScreen(),
        ),
    AppRoute.budgetIncome: (_) => BlocProvider<IncomeSourceBloc>(
          create: (_) => getIt<IncomeSourceBloc>()
            ..add(const CrudLoadRequested<CategorizedDraft<IncomeCategory>>()),
          child: const IncomeSourcesScreen(),
        ),
    AppRoute.budgetComparison: (_) => BlocProvider<BudgetComparisonBloc>(
          create: (_) => getIt<BudgetComparisonBloc>()
            ..add(const BudgetComparisonLoadRequested()),
          child: const BudgetComparisonScreen(),
        ),
  };
}
