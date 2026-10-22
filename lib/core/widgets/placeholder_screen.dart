import 'package:flutter/material.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/widgets/status_message.dart';

/// Temporary screen for a route whose feature is not built yet.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.route, super.key});

  static const String message = 'This screen is under construction.';

  final AppRoute route;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StatusMessage(
        icon: Icons.construction_outlined,
        title: route.title,
        message: message,
      ),
    );
  }
}

/// Shown when the URL does not match any route.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  static const String title = 'Page not found';
  static const String message = 'The page you are looking for does not exist.';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: StatusMessage(
        icon: Icons.explore_off_outlined,
        title: title,
        message: message,
      ),
    );
  }
}
