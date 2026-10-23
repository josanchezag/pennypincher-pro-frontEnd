import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/balance_layout.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/credit_card_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/credit_card_bloc.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/expense_texts.dart';

/// `/expenses/credit-cards`: every credit card with its monthly payment
/// and balance, and both totals under the list. Expects a
/// [CreditCardBloc] above it.
class CreditCardsScreen extends StatelessWidget {
  const CreditCardsScreen({super.key});

  static const CrudScreenConfig<CreditCard, BalanceDraft> config =
      CrudScreenConfig(
    route: AppRoute.expensesCreditCards,
    parent: AppRoute.expenses,
    itemNoun: 'credit card',
    emptyIcon: Icons.credit_card_outlined,
    emptyMessage: 'Add your credit cards with their monthly payment and '
        'total balance to see what you pay and owe on them.',
    layout: BalanceLayout(
      monthly: BalanceAmountStyle(
        label: ExpenseTexts.monthlyPayment,
        totalLabel: ExpenseTexts.totalMonthlyPayments,
        icon: Icons.event_repeat_outlined,
        color: AppColors.warning,
      ),
      balance: BalanceAmountStyle(
        label: ExpenseTexts.totalBalance,
        totalLabel: ExpenseTexts.totalOutstandingBalance,
        icon: Icons.trending_down,
        color: AppColors.error,
      ),
      summaryAtBottom: true,
    ),
  );

  @override
  Widget build(BuildContext context) =>
      const CrudScreen<CreditCard, BalanceDraft, CreditCardBloc>(
        config: config,
      );
}
