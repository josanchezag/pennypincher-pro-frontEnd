import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';

/// Top-level sections shown in the navigation bar, rail or drawer.
enum AppDestination {
  dashboard(AppRoute.dashboard, Icons.space_dashboard_outlined),
  netWorth(AppRoute.netWorth, Icons.account_balance_outlined),
  budget(AppRoute.budget, Icons.pie_chart_outline),
  expenses(AppRoute.expenses, Icons.receipt_long_outlined),
  goals(AppRoute.goals, Icons.flag_outlined),
  settings(AppRoute.settings, Icons.settings_outlined);

  const AppDestination(this.route, this.icon);

  final AppRoute route;
  final IconData icon;

  String get label => route.title;

  /// Sections of the mobile bottom bar. Settings is reached from the app
  /// bar instead, so every label fits on one line on narrow phones.
  static List<AppDestination> get mobile =>
      values.where((destination) => destination != settings).toList();

  /// Section that owns [location], or the dashboard when none matches.
  static AppDestination forLocation(String location) => values.firstWhere(
        (destination) => destination._owns(location),
        orElse: () => dashboard,
      );

  /// Index in [values] of the section that owns [location].
  static int indexForLocation(String location) => forLocation(location).index;

  bool _owns(String location) =>
      location == route.path || location.startsWith('${route.path}/');
}
