import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/domain/categorized_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/fixed_expense_entity.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/variable_expense_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/credit_card_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/expenses_hub_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/fixed_expense_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/loan_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/variable_expense_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/credit_cards_screen.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/expenses_hub_screen.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/fixed_expenses_screen.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/loans_screen.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/screen/variable_expenses_screen.dart';

/// Screens of the expenses section, each with a fresh bloc that starts
/// loading as soon as the screen opens and closes with it.
abstract final class ExpenseDetailsPages {
  static final Map<AppRoute, WidgetBuilder> builders = {
    AppRoute.expenses: (_) => BlocProvider<ExpensesHubBloc>(
          create: (_) =>
              getIt<ExpensesHubBloc>()..add(const ExpensesHubStarted()),
          child: const ExpensesHubScreen(),
        ),
    AppRoute.expensesCreditCards: (_) => BlocProvider<CreditCardBloc>(
          create: (_) => getIt<CreditCardBloc>()
            ..add(const CrudLoadRequested<BalanceDraft>()),
          child: const CreditCardsScreen(),
        ),
    AppRoute.expensesLoans: (_) => BlocProvider<LoanBloc>(
          create: (_) =>
              getIt<LoanBloc>()..add(const CrudLoadRequested<BalanceDraft>()),
          child: const LoansScreen(),
        ),
    AppRoute.expensesFixed: (_) => BlocProvider<FixedExpenseBloc>(
          create: (_) => getIt<FixedExpenseBloc>()
            ..add(
              const CrudLoadRequested<CategorizedDraft<FixedExpenseCategory>>(),
            ),
          child: const FixedExpensesScreen(),
        ),
    AppRoute.expensesVariable: (_) => BlocProvider<VariableExpenseBloc>(
          create: (_) => getIt<VariableExpenseBloc>()
            ..add(
              const CrudLoadRequested<
                  CategorizedDraft<VariableExpenseCategory>>(),
            ),
          child: const VariableExpensesScreen(),
        ),
  };
}
