import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:pennypincher_pro/app.dart';
import 'package:pennypincher_pro/core/config/app_config.dart';
import 'package:pennypincher_pro/core/di/injection.dart';
import 'package:pennypincher_pro/core/l10n/locale_cubit.dart';
import 'package:pennypincher_pro/core/router/app_router.dart';
import 'package:pennypincher_pro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pennypincher_pro/features/dashboard/domain/entity/part_of_day.dart';
import 'package:pennypincher_pro/features/dashboard/presentation/bloc/dashboard_bloc.dart';

import 'dashboard_mocks.dart';
import 'l10n.dart';
import 'mocks.dart';
import 'settings_fakes.dart';
import 'test_config.dart';

/// Logical screen widths used to exercise each breakpoint.
abstract final class TestViewports {
  static const Size mobile = Size(375, 812);
  static const Size tablet = Size(768, 1024);
  static const Size desktop = Size(1280, 800);

  /// Widths the expenses screens are checked at, from a phone to a desktop.
  static const List<Size> expenseWidths = [
    Size(390, 844),
    Size(800, 1000),
    desktop,
  ];
}

extension PumpApp on WidgetTester {
  /// Pumps the whole app at [location] with a logical [size]. Signed-in
  /// users land on the dashboard, so unless the test registered its own
  /// dashboard bloc, one that stays loading is provided. The interface is
  /// in [locale] (English by default) unless [localeCubit] is given. The
  /// account's preferences come from [preferences], which by default has
  /// that language saved.
  Future<void> pumpApp({
    String location = '/dashboard',
    Size size = TestViewports.desktop,
    AuthBloc? authBloc,
    AppConfig config = TestConfigs.googleOnly,
    bool settle = true,
    Locale locale = testLocale,
    LocaleCubit? localeCubit,
    FakePreferencesRepository? preferences,
  }) async {
    view.physicalSize = size;
    view.devicePixelRatio = 1;
    addTearDown(view.reset);
    if (!getIt.isRegistered<DashboardBloc>()) {
      registerDashboardBloc(const DashboardState(period: PartOfDay.morning));
    }
    final bloc = authBloc ?? mockAuthBloc(AuthAuthenticated(testUser));
    final router = AppRouter.buildRouter(
      appConfig: config,
      authBloc: bloc,
      initialLocation: location,
    );
    addTearDown(router.dispose);
    final store = MemoryLocaleStore(
      (localeCubit?.state ?? locale).languageCode,
    );
    final language = localeCubit ?? LocaleCubit(store);
    if (localeCubit == null) {
      addTearDown(language.close);
    }
    addTearDown(() => Intl.defaultLocale = testLocale.languageCode);
    final account = preferences ??
        FakePreferencesRepository(
          savedPreferences(language.state.languageCode),
        );
    final settings = preferencesCubit(account, language, store);
    addTearDown(settings.close);
    await pumpWidget(
      PennyPincherApp(
        router: router,
        authBloc: bloc,
        localeCubit: language,
        preferencesCubit: settings,
      ),
    );
    if (settle) {
      await pumpAndSettle();
    }
  }
}
