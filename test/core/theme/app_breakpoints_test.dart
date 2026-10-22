import 'package:flutter_test/flutter_test.dart';
import 'package:pennypincher_pro/core/theme/app_breakpoints.dart';

void main() {
  group('ScreenSize.fromWidth', () {
    test('returns mobile below 600 px', () {
      expect(ScreenSize.fromWidth(0), ScreenSize.mobile);
      expect(ScreenSize.fromWidth(599), ScreenSize.mobile);
    });

    test('returns tablet from 600 px to below 1024 px', () {
      expect(ScreenSize.fromWidth(600), ScreenSize.tablet);
      expect(ScreenSize.fromWidth(1023), ScreenSize.tablet);
    });

    test('returns desktop from 1024 px', () {
      expect(ScreenSize.fromWidth(1024), ScreenSize.desktop);
      expect(ScreenSize.fromWidth(1920), ScreenSize.desktop);
    });
  });
}
