import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/expense_summary_entity.dart';

/// How the hub presents the summary of one [ExpenseKind].
class ExpenseKindView {
  const ExpenseKindView({
    required this.route,
    required this.icon,
    required this.monthlyLabel,
    required this.count,
    this.balanceLabel,
  });

  /// List screen the card opens; its title names the card.
  final AppRoute route;
  final IconData icon;
  final LocalizedText monthlyLabel;

  /// Label of the balance total, for the kinds that have one.
  final LocalizedText? balanceLabel;

  /// Number of items with their noun, such as `1 card` or `3 cards`.
  final String Function(AppLocalizations l10n, int count) count;

  /// The view of every kind, in the order of [ExpenseKind.values].
  static final Map<ExpenseKind, ExpenseKindView> all = {
    ExpenseKind.creditCards: ExpenseKindView(
      route: AppRoute.expensesCreditCards,
      icon: Icons.credit_card_outlined,
      monthlyLabel: (l10n) => l10n.totalMonthlyPayments,
      balanceLabel: (l10n) => l10n.totalOutstandingBalance,
      count: (l10n, count) => l10n.expenseCardCount(count),
    ),
    ExpenseKind.loans: ExpenseKindView(
      route: AppRoute.expensesLoans,
      icon: Icons.account_balance_outlined,
      monthlyLabel: (l10n) => l10n.totalMonthlyPayments,
      balanceLabel: (l10n) => l10n.totalOutstandingDebt,
      count: (l10n, count) => l10n.expenseLoanCount(count),
    ),
    ExpenseKind.fixedExpenses: ExpenseKindView(
      route: AppRoute.expensesFixed,
      icon: Icons.event_repeat_outlined,
      monthlyLabel: (l10n) => l10n.totalMonthlyAmount,
      count: (l10n, count) => l10n.expenseItemCount(count),
    ),
    ExpenseKind.variableExpenses: ExpenseKindView(
      route: AppRoute.expensesVariable,
      icon: Icons.shopping_bag_outlined,
      monthlyLabel: (l10n) => l10n.totalMonthlyAmount,
      count: (l10n, count) => l10n.expenseItemCount(count),
    ),
    ExpenseKind.savings: ExpenseKindView(
      route: AppRoute.expensesSavings,
      icon: Icons.savings_outlined,
      monthlyLabel: (l10n) => l10n.totalMonthlyContributions,
      balanceLabel: (l10n) => l10n.totalSavingsBalance,
      count: (l10n, count) => l10n.expenseAccountCount(count),
    ),
  };
}
