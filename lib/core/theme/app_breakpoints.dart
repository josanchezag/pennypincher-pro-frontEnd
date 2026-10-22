/// Responsive breakpoints: mobile < 600 px <= tablet < 1024 px <= desktop.
abstract final class AppBreakpoints {
  static const double mobile = 0;
  static const double tablet = 600;
  static const double desktop = 1024;
}

/// Layout class derived from the available width.
enum ScreenSize {
  mobile,
  tablet,
  desktop;

  static ScreenSize fromWidth(double width) {
    if (width >= AppBreakpoints.desktop) {
      return ScreenSize.desktop;
    }
    if (width >= AppBreakpoints.tablet) {
      return ScreenSize.tablet;
    }
    return ScreenSize.mobile;
  }
}
