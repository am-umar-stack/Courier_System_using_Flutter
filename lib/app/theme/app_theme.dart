import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      error: AppColors.error,
      errorContainer: AppColors.errorContainer,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.onSurfaceLight,
      surfaceContainerHighest: AppColors.surfaceVariantLight,
      onSurfaceVariant: AppColors.onSurfaceVariantLight,
      outline: AppColors.outlineLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: AppTextStyles.lightTextTheme,
      brightness: Brightness.light,
      appBarTheme: _buildAppBarTheme(scheme, AppTextStyles.lightTextTheme),
      cardTheme: _buildCardTheme(scheme),
      elevatedButtonTheme: _buildElevatedButtonTheme(scheme, AppTextStyles.lightTextTheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(scheme, AppTextStyles.lightTextTheme),
      textButtonTheme: _buildTextButtonTheme(scheme, AppTextStyles.lightTextTheme),
      inputDecorationTheme: _buildInputDecorationTheme(AppTextStyles.lightTextTheme, false),
      bottomSheetTheme: _buildBottomSheetTheme(scheme),
      snackBarTheme: _buildSnackBarTheme(AppTextStyles.lightTextTheme, false),
      navigationBarTheme: _buildNavigationBarTheme(scheme),
      navigationRailTheme: _buildNavigationRailTheme(scheme),
      dialogTheme: _buildDialogTheme(scheme),
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineLight,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get dark {
    ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primaryLight,
      onPrimary: AppColors.primaryDark,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: AppColors.primaryContainer,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.secondaryDark,
      secondaryContainer: AppColors.secondaryDark,
      onSecondaryContainer: AppColors.secondaryContainer,
      tertiary: AppColors.tertiary,
      tertiaryContainer: AppColors.onTertiaryContainer,
      onTertiaryContainer: AppColors.tertiaryContainer,
      error: AppColors.error,
      errorContainer: AppColors.errorContainer,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurfaceDark,
      surfaceContainerHighest: AppColors.surfaceVariantDark,
      onSurfaceVariant: AppColors.onSurfaceVariantDark,
      outline: AppColors.outlineDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: AppTextStyles.darkTextTheme,
      brightness: Brightness.dark,
      appBarTheme: _buildAppBarTheme(scheme, AppTextStyles.darkTextTheme),
      cardTheme: _buildCardTheme(scheme),
      elevatedButtonTheme: _buildElevatedButtonTheme(scheme, AppTextStyles.darkTextTheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(scheme, AppTextStyles.darkTextTheme),
      textButtonTheme: _buildTextButtonTheme(scheme, AppTextStyles.darkTextTheme),
      inputDecorationTheme: _buildInputDecorationTheme(AppTextStyles.darkTextTheme, true),
      bottomSheetTheme: _buildBottomSheetTheme(scheme),
      snackBarTheme: _buildSnackBarTheme(AppTextStyles.darkTextTheme, true),
      navigationBarTheme: _buildNavigationBarTheme(scheme),
      navigationRailTheme: _buildNavigationRailTheme(scheme),
      dialogTheme: _buildDialogTheme(scheme),
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineDark,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static AppBarTheme _buildAppBarTheme(ColorScheme scheme, TextTheme textTheme) {
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: AppDimensions.elevationLow,
      centerTitle: false,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: textTheme.titleLarge,
    );
  }

  static CardThemeData _buildCardTheme(ColorScheme scheme) {
    return CardThemeData(
      elevation: AppDimensions.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      color: scheme.surface,
      surfaceTintColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing8,
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(ColorScheme scheme, TextTheme textTheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        textStyle: textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing24,
          vertical: AppDimensions.spacing16,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(ColorScheme scheme, TextTheme textTheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        side: BorderSide(color: scheme.primary, width: 1.5),
        foregroundColor: scheme.primary,
        textStyle: textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing24,
          vertical: AppDimensions.spacing16,
        ),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(ColorScheme scheme, TextTheme textTheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: scheme.primary,
        textStyle: textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing12,
        ),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(TextTheme textTheme, bool isDark) {
    Color fillColor = isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight;
    Color primaryColor = isDark ? AppColors.primaryLight : AppColors.primary;
    Color hintColor = isDark ? AppColors.grey600 : AppColors.grey500;
    Color labelColor = isDark ? AppColors.grey400 : AppColors.grey700;

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(color: hintColor),
      labelStyle: textTheme.bodyMedium?.copyWith(color: labelColor),
    );
  }

  static BottomSheetThemeData _buildBottomSheetTheme(ColorScheme scheme) {
    return BottomSheetThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
    );
  }

  static SnackBarThemeData _buildSnackBarTheme(TextTheme textTheme, bool isDark) {
    Color bgColor = isDark ? AppColors.grey200 : AppColors.grey900;
    Color textColor = isDark ? AppColors.grey900 : AppColors.white;

    return SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
      ),
      backgroundColor: bgColor,
      contentTextStyle: textTheme.bodyMedium?.copyWith(color: textColor),
    );
  }

  static NavigationBarThemeData _buildNavigationBarTheme(ColorScheme scheme) {
    return NavigationBarThemeData(
      elevation: AppDimensions.elevationLow,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: scheme.primaryContainer,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    );
  }

  static NavigationRailThemeData _buildNavigationRailTheme(ColorScheme scheme) {
    return NavigationRailThemeData(
      backgroundColor: scheme.surface,
      indicatorColor: scheme.primaryContainer,
      selectedIconTheme: IconThemeData(color: scheme.primary, size: AppDimensions.iconMD),
      unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant, size: AppDimensions.iconMD),
      selectedLabelTextStyle: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelTextStyle: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
    );
  }

  static DialogThemeData _buildDialogTheme(ColorScheme scheme) {
    return DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
      ),
      surfaceTintColor: Colors.transparent,
      backgroundColor: scheme.surface,
    );
  }
}
