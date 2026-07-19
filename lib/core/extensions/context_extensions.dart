import 'package:flutter/material.dart';

import '../layout/app_breakpoints.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  double get statusBarHeight => MediaQuery.paddingOf(this).top;
  double get bottomPadding => MediaQuery.paddingOf(this).bottom;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  ScreenSize get screenSizeCategory {
    if (screenWidth >= AppBreakpoints.desktop) {
      return ScreenSize.desktop;
    } else if (screenWidth >= AppBreakpoints.tablet) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.mobile;
    }
  }

  bool get isMobile => screenSizeCategory == ScreenSize.mobile;
  bool get isTablet => screenSizeCategory == ScreenSize.tablet;
  bool get isDesktop => screenSizeCategory == ScreenSize.desktop;

  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) {
      return desktop;
    } else if (isTablet && tablet != null) {
      return tablet;
    } else {
      return mobile;
    }
  }

  void showSuccessSnackBar(String message) {
    _showSnackBar(message, const Color(0xFF0F9D58), Icons.check_circle_rounded);
  }

  void showErrorSnackBar(String message) {
    _showSnackBar(message, const Color(0xFFD93025), Icons.error_rounded);
  }

  void showInfoSnackBar(String message) {
    _showSnackBar(message, const Color(0xFF4285F4), Icons.info_rounded);
  }

  void _showSnackBar(String message, Color backgroundColor, IconData icon) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();

    SnackBar snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  void dismissKeyboard() {
    FocusScope.of(this).unfocus();
  }
}

extension StringValidation on String {
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  bool get isValidPhone {
    return RegExp(r'^\+?[\d\s-]{10,15}$').hasMatch(this);
  }

  bool get isValidPassword {
    return length >= 8;
  }

  String get capitalize {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
