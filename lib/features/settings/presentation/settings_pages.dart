import 'package:flutter/widgets.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/features/settings/presentation/screen/settings_screen.dart';

/// The settings screen. Its `PreferencesCubit` lives for the whole app, so
/// the account's settings are loaded on sign-in, not when the screen opens.
abstract final class SettingsPages {
  static final Map<AppRoute, WidgetBuilder> builders = {
    AppRoute.settings: (_) => const SettingsScreen(),
  };
}
