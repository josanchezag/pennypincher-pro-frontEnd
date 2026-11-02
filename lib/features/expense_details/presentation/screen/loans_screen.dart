import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/crud/domain/balance_item.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen.dart';
import 'package:pennypincher_pro/core/crud/presentation/crud_screen_config.dart';
import 'package:pennypincher_pro/core/crud/presentation/layout/balance_layout.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
import 'package:pennypincher_pro/core/utils/money.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/loan_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/bloc/loan_bloc.dart';

/// `/expenses/loans`: every loan with its monthly installment, remaining
/// balance and, when the original amount is tracked, how much is paid;
/// both totals under the list. Expects a [LoanBloc] above it.
class LoansScreen extends StatelessWidget {
  const LoansScreen({super.key});

  static final CrudScreenConfig<Loan, BalanceDraft> config = CrudScreenConfig(
    route: AppRoute.expensesLoans,
    parent: AppRoute.expenses,
    itemNoun: (l10n) => l10n.loanNoun,
    emptyIcon: Icons.account_balance_outlined,
    emptyMessage: (l10n) => l10n.loansEmptyMessage,
    layout: BalanceLayout(
      monthly: BalanceAmountStyle(
        label: (l10n) => l10n.monthlyInstallment,
        totalLabel: (l10n) => l10n.totalMonthlyPayments,
        icon: Icons.event_repeat_outlined,
        color: AppColors.warning,
      ),
      balance: BalanceAmountStyle(
        label: (l10n) => l10n.remainingBalance,
        totalLabel: (l10n) => l10n.totalOutstandingDebt,
        icon: Icons.trending_down,
        color: AppColors.error,
      ),
      original: OriginalAmountStyle(
        label: (l10n) => l10n.originalAmount,
        read: _originalAmount,
      ),
      summaryAtBottom: true,
    ),
  );

  static Money? _originalAmount(Loan loan) => loan.originalAmount;

  @override
  Widget build(BuildContext context) =>
      CrudScreen<Loan, BalanceDraft, LoanBloc>(config: config);
}
