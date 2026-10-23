import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/layout/app_shell.dart';
import 'package:pennypincher_pro/core/router/app_destination.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_spacing.dart';
import 'package:pennypincher_pro/core/widgets/placeholder_screen.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';

import '../../helpers/expense_mocks.dart';
import '../../helpers/mocks.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('AppShell', () {
    testWidgets('uses a bottom navigation bar on mobile', (tester) async {
      await tester.pumpApp(size: TestViewports.mobile);

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      expect(
        find.byType(NavigationDestination),
        findsNWidgets(AppDestination.mobile.length),
      );
    });

    testWidgets('opens settings from the app bar on mobile', (tester) async {
      await tester.pumpApp(size: TestViewports.mobile);

      await tester.tap(find.byTooltip(AppShell.settingsTooltip));
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byTooltip(AppShell.settingsTooltip), findsNothing);
      expect(
        find.descendant(
          of: find.byType(PlaceholderScreen),
          matching: find.text(AppRoute.settings.title),
        ),
        findsOneWidget,
      );
    });

    testWidgets('returns from settings to the dashboard on mobile',
        (tester) async {
      await tester.pumpApp(
        location: AppRoute.settingsProfile.path,
        size: TestViewports.mobile,
      );

      await tester.tap(find.byTooltip(AppShell.backTooltip));
      await tester.pumpAndSettle();

      final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(bar.selectedIndex, AppDestination.dashboard.index);
    });

    testWidgets('uses a collapsed rail on tablet', (tester) async {
      await tester.pumpApp(size: TestViewports.tablet);

      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isFalse);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('uses an expanded rail with labels on desktop', (tester) async {
      await tester.pumpApp();

      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.extended, isTrue);
      expect(find.text(AppDestination.netWorth.label), findsWidgets);
    });

    testWidgets('highlights the section of the current location',
        (tester) async {
      registerFixedExpenseBloc(const CrudLoaded([]));
      await tester.pumpApp(location: '/expenses/fixed');

      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.selectedIndex, AppDestination.expenses.index);
    });

    testWidgets('limits the content width on large screens', (tester) async {
      await tester.pumpApp(size: const Size(1920, 1080));

      final box = tester.widget<ConstrainedBox>(
        find
            .byWidgetPredicate(
              (widget) =>
                  widget is ConstrainedBox &&
                  widget.constraints.maxWidth == AppSpacing.maxContentWidth,
            )
            .first,
      );
      expect(box.constraints.maxWidth, AppSpacing.maxContentWidth);
    });

    for (final size in [TestViewports.mobile, TestViewports.desktop]) {
      testWidgets('signs out from the shell at ${size.width} px',
          (tester) async {
        final bloc = mockAuthBloc(AuthAuthenticated(testUser));
        await tester.pumpApp(size: size, authBloc: bloc);

        await tester.tap(find.byTooltip(AppShell.signOutTooltip));

        verify(() => bloc.add(const AuthSignOutRequested())).called(1);
      });
    }
  });
}
