import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/app.dart';
import 'package:pennypincher_pro/core/router/app_router.dart';

/// Logical screen widths used to exercise each breakpoint.
abstract final class TestViewports {
  static const Size mobile = Size(375, 812);
  static const Size tablet = Size(768, 1024);
  static const Size desktop = Size(1280, 800);
}

extension PumpApp on WidgetTester {
  /// Pumps the whole app at [location] with a logical [size].
  Future<void> pumpApp({
    String location = '/dashboard',
    Size size = TestViewports.desktop,
  }) async {
    view.physicalSize = size;
    view.devicePixelRatio = 1;
    addTearDown(view.reset);
    final router = AppRouter.buildRouter(initialLocation: location);
    addTearDown(router.dispose);
    await pumpWidget(PennyPincherApp(router: router));
    await pumpAndSettle();
  }
}
