import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/balance_layout.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/credit_card_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/credit_card_bloc.dart';

/// `/expenses/credit-cards`: every credit card with its monthly payment
/// and balance, and both totals under the list. Expects a
/// [CreditCardBloc] above it.
class CreditCardsScreen extends StatelessWidget {
  const CreditCardsScreen({super.key});

  static final CrudScreenConfig<CreditCard, BalanceDraft> config =
      CrudScreenConfig(
    route: AppRoute.expensesCreditCards,
    parent: AppRoute.expenses,
    itemNoun: (l10n) => l10n.creditCardNoun,
    emptyIcon: Icons.credit_card_outlined,
    emptyMessage: (l10n) => l10n.creditCardsEmptyMessage,
    layout: BalanceLayout(
      monthly: BalanceAmountStyle(
        label: (l10n) => l10n.monthlyPayment,
        totalLabel: (l10n) => l10n.totalMonthlyPayments,
        icon: Icons.event_repeat_outlined,
        color: AppColors.warning,
      ),
      balance: BalanceAmountStyle(
        label: (l10n) => l10n.totalBalance,
        totalLabel: (l10n) => l10n.totalOutstandingBalance,
        icon: Icons.trending_down,
        color: AppColors.error,
      ),
      summaryAtBottom: true,
    ),
  );

  @override
  Widget build(BuildContext context) =>
      CrudScreen<CreditCard, BalanceDraft, CreditCardBloc>(
        config: config,
      );
}
