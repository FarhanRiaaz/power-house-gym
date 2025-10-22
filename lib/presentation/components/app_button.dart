import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool fullWidth;
  final bool isOutline;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.fullWidth = true,
    this.isOutline = false,
  });

  Color get backgroundColor {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.primary;
      case AppButtonVariant.secondary:
        return AppColors.surface;
      case AppButtonVariant.danger:
        return AppColors.danger;
    }
  }

  Color get foregroundColor {
    switch (variant) {
      case AppButtonVariant.primary:
        return Colors.black;
      case AppButtonVariant.secondary:
        return AppColors.textPrimary;
      case AppButtonVariant.danger:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: isOutline?
      OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon, size: 18,color: Colors.white,): const SizedBox.shrink(),
        label: Text(label, style: AppTextStyles.subheading),
        style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor,
            side: BorderSide(color: backgroundColor, width: 2),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      ):

      ElevatedButton.icon(
        icon: icon != null ? Icon(icon, size: 18,color: Colors.white,): const SizedBox.shrink(),
        label: Text(label, style: AppTextStyles.subheading),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
