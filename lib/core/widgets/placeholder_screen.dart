import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/l10n/l10n.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/widgets/status_message.dart';

/// Temporary screen for a route whose feature is not built yet.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.route, super.key});

  final AppRoute route;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StatusMessage(
        icon: Icons.construction_outlined,
        title: route.title(context.l10n),
        message: context.l10n.placeholderMessage,
      ),
    );
  }
}

/// Shown when the URL does not match any route.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StatusMessage(
        icon: Icons.explore_off_outlined,
        title: context.l10n.notFoundTitle,
        message: context.l10n.notFoundMessage,
      ),
    );
  }
}
