import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = buildAppTheme(isDark: false);
  static ThemeData dark = buildAppTheme(isDark: true);

  
}
ThemeData buildAppTheme({required bool isDark}) {
  final base = isDark ? ThemeData.dark() : ThemeData.light();

  return base.copyWith(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    cardColor: AppColors.surface,
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.heading,
      titleMedium: AppTextStyles.subheading,
      bodyMedium: AppTextStyles.body,
      labelSmall: AppTextStyles.caption,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: AppTextStyles.subheading,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: AppColors.surface,
      hintStyle: TextStyle(color: AppColors.textSecondary),
      labelStyle: TextStyle(color: AppColors.textPrimary),
    ),
    iconTheme: IconThemeData(color: AppColors.primary),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      titleTextStyle: AppTextStyles.heading,
    ),
    dividerColor: Colors.grey[700],
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surface,
      contentTextStyle: AppTextStyles.body,
      actionTextColor: AppColors.primary,
    ),
  );
}
