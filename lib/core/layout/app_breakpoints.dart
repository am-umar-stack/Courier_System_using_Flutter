enum ScreenSize { mobile, tablet, desktop }

class AppBreakpoints {
  AppBreakpoints._();

  static const double mobile = 0;
  static const double tablet = 600;
  static const double desktop = 1024;

  static ScreenSize getScreenSize(double width) {
    if (width >= desktop) {
      return ScreenSize.desktop;
    } else if (width >= tablet) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.mobile;
    }
  }
}
