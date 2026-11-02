import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/balance_layout.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/savings_account_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/savings_account_bloc.dart';

/// `/expenses/savings`: the total savings balance first, in green, and the
/// monthly contributions, above every savings account. Expects a
/// [SavingsAccountBloc] above it.
class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  static final CrudScreenConfig<SavingsAccount, BalanceDraft> config =
      CrudScreenConfig(
    route: AppRoute.expensesSavings,
    parent: AppRoute.expenses,
    itemNoun: (l10n) => l10n.savingsAccountNoun,
    emptyIcon: Icons.savings_outlined,
    emptyMessage: (l10n) => l10n.savingsEmptyMessage,
    layout: BalanceLayout(
      monthly: BalanceAmountStyle(
        label: (l10n) => l10n.monthlyContribution,
        totalLabel: (l10n) => l10n.totalMonthlyContributions,
        icon: Icons.event_repeat_outlined,
        color: AppColors.textPrimary,
      ),
      balance: BalanceAmountStyle(
        label: (l10n) => l10n.currentBalance,
        totalLabel: (l10n) => l10n.totalSavingsBalance,
        icon: Icons.savings_outlined,
        color: AppColors.success,
      ),
      balanceFirst: true,
    ),
  );

  @override
  Widget build(BuildContext context) =>
      CrudScreen<SavingsAccount, BalanceDraft, SavingsAccountBloc>(
        config: config,
      );
}
