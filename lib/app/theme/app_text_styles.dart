import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static final String _fontFamily = GoogleFonts.inter().fontFamily ?? 'Inter';

  static TextTheme get lightTextTheme {
    return _buildTextTheme(AppColors.onBackgroundLight, AppColors.onSurfaceVariantLight);
  }

  static TextTheme get darkTextTheme {
    return _buildTextTheme(AppColors.onBackgroundDark, AppColors.onSurfaceVariantDark);
  }

  static TextTheme _buildTextTheme(Color primaryColor, Color secondaryColor) {
    TextStyle make(double size, FontWeight weight, double height, double spacing, Color color) {
      return TextStyle(
        fontFamily: _fontFamily,
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: spacing,
        color: color,
      );
    }

    return TextTheme(
      displayLarge: make(57, FontWeight.w400, 1.12, -0.25, primaryColor),
      displayMedium: make(45, FontWeight.w400, 1.15, 0, primaryColor),
      displaySmall: make(36, FontWeight.w400, 1.22, 0, primaryColor),
      headlineLarge: make(32, FontWeight.w700, 1.25, 0, primaryColor),
      headlineMedium: make(28, FontWeight.w600, 1.28, 0, primaryColor),
      headlineSmall: make(24, FontWeight.w600, 1.33, 0, primaryColor),
      titleLarge: make(22, FontWeight.w600, 1.27, 0, primaryColor),
      titleMedium: make(16, FontWeight.w600, 1.5, 0.15, primaryColor),
      titleSmall: make(14, FontWeight.w600, 1.43, 0.1, primaryColor),
      bodyLarge: make(16, FontWeight.w400, 1.5, 0.5, primaryColor),
      bodyMedium: make(14, FontWeight.w400, 1.43, 0.25, primaryColor),
      bodySmall: make(12, FontWeight.w400, 1.33, 0.4, secondaryColor),
      labelLarge: make(14, FontWeight.w600, 1.43, 0.1, primaryColor),
      labelMedium: make(12, FontWeight.w600, 1.33, 0.5, primaryColor),
      labelSmall: make(11, FontWeight.w600, 1.45, 0.5, secondaryColor),
    );
  }
}
