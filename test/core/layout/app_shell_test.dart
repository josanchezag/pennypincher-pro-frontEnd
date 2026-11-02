import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pennypincher_pro/core/crud/presentation/bloc/crud_bloc.dart';
import 'package:pennypincher_pro/core/layout/account_menu.dart';
import 'package:pennypincher_pro/core/layout/app_shell.dart';
import 'package:pennypincher_pro/core/router/app_destination.dart';
import 'package:pennypincher_pro/core/router/app_route.dart';
import 'package:pennypincher_pro/core/theme/app_colors.dart';
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

    for (final size in [
      TestViewports.mobile,
      TestViewports.tablet,
      TestViewports.desktop,
    ]) {
      testWidgets('shows the account menu at the top right at ${size.width} px',
          (tester) async {
        await tester.pumpApp(size: size);

        final button = find.byTooltip(AccountMenu.tooltip);
        expect(button, findsOneWidget);
        expect(
          find.ancestor(of: button, matching: find.byType(AppBar)),
          findsOneWidget,
        );
        final corner = tester.getTopRight(button);
        expect(corner.dx, greaterThan(size.width - AppSpacing.xxl - 8));
        expect(corner.dy, lessThan(kToolbarHeight));
      });

      testWidgets('signs out from the account menu at ${size.width} px',
          (tester) async {
        final bloc = mockAuthBloc(AuthAuthenticated(testUser));
        await tester.pumpApp(size: size, authBloc: bloc);

        await tester.tap(find.byTooltip(AccountMenu.tooltip));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AccountMenu.signOutLabel));
        await tester.pump();

        verify(() => bloc.add(const AuthSignOutRequested())).called(1);
      });
    }

    testWidgets('no longer shows a sign-out button outside the menu',
        (tester) async {
      await tester.pumpApp();

      expect(find.byIcon(Icons.logout), findsNothing);
      expect(find.text(AccountMenu.signOutLabel), findsNothing);
    });

    testWidgets('shows the name and email of the user in the menu',
        (tester) async {
      await tester.pumpApp(size: TestViewports.mobile);

      await tester.tap(find.byTooltip(AccountMenu.tooltip));
      await tester.pumpAndSettle();

      final header = find.byKey(AccountMenu.headerKey);
      expect(
        find.descendant(of: header, matching: find.text(testUser.name)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: header, matching: find.text(testUser.email)),
        findsOneWidget,
      );
      expect(
        find.ancestor(of: header, matching: find.byType(MenuItemButton)),
        findsNothing,
      );
    });

    testWidgets('paints the sign-out entry in the error color', (tester) async {
      await tester.pumpApp();

      await tester.tap(find.byTooltip(AccountMenu.tooltip));
      await tester.pumpAndSettle();

      final label = tester.widget<Text>(find.text(AccountMenu.signOutLabel));
      expect(label.style?.color, AppColors.error);
    });

    testWidgets('shows the initials when the user has no picture',
        (tester) async {
      final user = testUser.copyWith(pictureUrl: null);
      await tester.pumpApp(authBloc: mockAuthBloc(AuthAuthenticated(user)));

      expect(
        find.descendant(
          of: find.byKey(AccountMenu.buttonKey),
          matching: find.text('AL'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('opens the menu and signs out with the keyboard',
        (tester) async {
      final bloc = mockAuthBloc(AuthAuthenticated(testUser));
      await tester.pumpApp(authBloc: bloc);

      final avatar = find.descendant(
        of: find.byKey(AccountMenu.buttonKey),
        matching: find.byType(CircleAvatar),
      );
      Focus.of(tester.element(avatar)).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.byKey(AccountMenu.signOutKey), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      verify(() => bloc.add(const AuthSignOutRequested())).called(1);
    });
  });
}
