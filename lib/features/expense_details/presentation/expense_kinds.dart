import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/features/expense_details/domain/entity/expense_summary_entity.dart';
import 'package:pennypincher_pro/features/expense_details/presentation/expense_texts.dart';

/// How the hub presents the summary of one [ExpenseKind].
class ExpenseKindView {
  const ExpenseKindView({
    required this.route,
    required this.icon,
    required this.monthlyLabel,
    required this.singular,
    required this.plural,
    this.balanceLabel,
  });

  /// List screen the card opens; its title names the card.
  final AppRoute route;
  final IconData icon;
  final String monthlyLabel;

  /// Label of the balance total, for the kinds that have one.
  final String? balanceLabel;

  /// Nouns of the item count, such as `card` and `cards`.
  final String singular;
  final String plural;

  String countLabel(int count) => '$count ${count == 1 ? singular : plural}';

  /// The view of every kind, in the order of [ExpenseKind.values].
  static const Map<ExpenseKind, ExpenseKindView> all = {
    ExpenseKind.creditCards: ExpenseKindView(
      route: AppRoute.expensesCreditCards,
      icon: Icons.credit_card_outlined,
      monthlyLabel: ExpenseTexts.totalMonthlyPayments,
      balanceLabel: ExpenseTexts.totalOutstandingBalance,
      singular: ExpenseTexts.cardNoun,
      plural: ExpenseTexts.cardsNoun,
    ),
    ExpenseKind.loans: ExpenseKindView(
      route: AppRoute.expensesLoans,
      icon: Icons.account_balance_outlined,
      monthlyLabel: ExpenseTexts.totalMonthlyPayments,
      balanceLabel: ExpenseTexts.totalOutstandingDebt,
      singular: ExpenseTexts.loanNoun,
      plural: ExpenseTexts.loansNoun,
    ),
    ExpenseKind.fixedExpenses: ExpenseKindView(
      route: AppRoute.expensesFixed,
      icon: Icons.event_repeat_outlined,
      monthlyLabel: ExpenseTexts.totalMonthlyAmount,
      singular: ExpenseTexts.expenseNoun,
      plural: ExpenseTexts.expensesNoun,
    ),
    ExpenseKind.variableExpenses: ExpenseKindView(
      route: AppRoute.expensesVariable,
      icon: Icons.shopping_bag_outlined,
      monthlyLabel: ExpenseTexts.totalMonthlyAmount,
      singular: ExpenseTexts.expenseNoun,
      plural: ExpenseTexts.expensesNoun,
    ),
    ExpenseKind.savings: ExpenseKindView(
      route: AppRoute.expensesSavings,
      icon: Icons.savings_outlined,
      monthlyLabel: ExpenseTexts.totalMonthlyContributions,
      balanceLabel: ExpenseTexts.totalSavingsBalance,
      singular: ExpenseTexts.accountNoun,
      plural: ExpenseTexts.accountsNoun,
    ),
  };
}
