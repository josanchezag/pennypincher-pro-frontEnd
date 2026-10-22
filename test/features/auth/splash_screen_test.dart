import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/app.dart';
import 'package:pennypincher_pro/core/constants/app_constants.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/router/app_router.dart';
import 'package:pennypincher_pro/core/widgets/placeholder_screen.dart';
import 'package:pennypincher_pro/features/auth/presentation/screen/splash_screen.dart';

void main() {
  testWidgets('shows the brand while loading and then opens the dashboard',
      (tester) async {
    final router = AppRouter.buildRouter();
    addTearDown(router.dispose);
    await tester.pumpWidget(PennyPincherApp(router: router));

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.tagline), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

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
