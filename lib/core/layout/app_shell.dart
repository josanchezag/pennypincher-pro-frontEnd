import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/router/app_destination.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_breakpoints.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';

/// Responsive scaffold around every authenticated screen: app bar and
/// bottom bar on mobile, collapsed rail on tablet and expanded rail on
/// desktop.
class AppShell extends StatelessWidget {
  const AppShell({required this.location, required this.child, super.key});

  static const String settingsTooltip = 'Settings';
  static const String backTooltip = 'Back to dashboard';

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final current = AppDestination.forLocation(location);
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = ScreenSize.fromWidth(constraints.maxWidth);
        if (size == ScreenSize.mobile) {
          return _MobileLayout(current: current, child: child);
        }
        return _WideLayout(
          current: current,
          extended: size == ScreenSize.desktop,
          child: child,
        );
      },
    );
  }
}

void _goTo(BuildContext context, AppDestination destination) =>
    context.goNamed(destination.route.name);

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.current, required this.child});

  final AppDestination current;
  final Widget child;

  bool get _inSettings => current == AppDestination.settings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        leading: _inSettings
            ? IconButton(
                tooltip: AppShell.backTooltip,
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.goNamed(AppRoute.dashboard.name),
              )
            : null,
        actions: [
          if (!_inSettings)
            IconButton(
              tooltip: AppShell.settingsTooltip,
              icon: Icon(AppDestination.settings.icon),
              onPressed: () => _goTo(context, AppDestination.settings),
            ),
        ],
      ),
      body: _ConstrainedContent(child: child),
      bottomNavigationBar: _inSettings ? null : _BottomBar(current: current),
    );
  }
}

class _WideLayout extends StatelessWidget {
  const _WideLayout({
    required this.current,
    required this.extended,
    required this.child,
  });

  final AppDestination current;
  final bool extended;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _SideRail(current: current, extended: extended),
          const VerticalDivider(),
          Expanded(child: _ConstrainedContent(child: child)),
        ],
      ),
    );
  }
}

class _ConstrainedContent extends StatelessWidget {
  const _ConstrainedContent({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.current});

  final AppDestination current;

  @override
  Widget build(BuildContext context) {
    final destinations = AppDestination.mobile;
    return NavigationBar(
      selectedIndex: destinations.indexOf(current),
      onDestinationSelected: (index) => _goTo(context, destinations[index]),
      destinations: [
        for (final destination in destinations)
          NavigationDestination(
            icon: Icon(destination.icon),
            label: destination.label,
          ),
      ],
    );
  }
}

class _SideRail extends StatelessWidget {
  const _SideRail({required this.current, required this.extended});

  final AppDestination current;
  final bool extended;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: current.index,
      extended: extended,
      labelType: extended ? null : NavigationRailLabelType.none,
      onDestinationSelected: (index) =>
          _goTo(context, AppDestination.values[index]),
      destinations: [
        for (final destination in AppDestination.values)
          NavigationRailDestination(
            icon: Icon(destination.icon),
            label: Text(destination.label),
          ),
      ],
    );
  }
}
