import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/widgets/placeholder_screen.dart';
import 'package:pennypincher_pro/features/auth/presentation/screen/splash_screen.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('shows the brand while loading and then opens the dashboard',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpApp(location: AppRoute.splash.path, settle: false);

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.tagline), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.bySemanticsLabel(SplashScreen.progressLabel), findsOneWidget);
    semantics.dispose();

    await tester.pump(AppConstants.splashDuration);
    await tester.pumpAndSettle();

    expect(find.byType(SplashScreen), findsNothing);
    expect(
      find.descendant(
        of: find.byType(PlaceholderScreen),
        matching: find.text(AppRoute.dashboard.title),
      ),
      findsOneWidget,
    );
  });
}
