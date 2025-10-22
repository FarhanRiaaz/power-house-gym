import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const heading = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const subheading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const body = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  /// Optional: dynamic styles based on theme context
  static TextStyle dynamicHeading(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold);

  static TextStyle dynamicBody(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!;
}
