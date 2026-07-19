import 'package:flutter/material.dart';

import 'app_breakpoints.dart';

/// A builder widget that renders different layouts based on screen width.
///
/// Uses [LayoutBuilder] internally so it responds to parent size changes,
/// not just device orientation.
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        ScreenSize size = AppBreakpoints.getScreenSize(width);

        switch (size) {
          case ScreenSize.desktop:
            return desktop ?? tablet ?? mobile;
          case ScreenSize.tablet:
            return tablet ?? mobile;
          case ScreenSize.mobile:
            return mobile;
        }
      },
    );
  }
}
