import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

enum AppDialogType { info, success, warning, error }

class AppDialog extends StatelessWidget {
  final String title;
  final String message;
  final AppDialogType type;
  final List<Widget> actions;

  const AppDialog({
    super.key,
    required this.title,
    required this.message,
    this.type = AppDialogType.info,
    this.actions = const [],
  });

  IconData get icon {
    switch (type) {
      case AppDialogType.success:
        return Icons.check_circle;
      case AppDialogType.warning:
        return Icons.warning;
      case AppDialogType.error:
        return Icons.error;
      case AppDialogType.info:
      default:
        return Icons.info;
    }
  }

  Color get iconColor {
    switch (type) {
      case AppDialogType.success:
        return AppColors.success;
      case AppDialogType.warning:
        return AppColors.warning;
      case AppDialogType.error:
        return AppColors.danger;
      case AppDialogType.info:
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 8),
          Expanded(child: Text(title, style: AppTextStyles.subheading)),
        ],
      ),
      content: Text(message, style: AppTextStyles.body),
      actions: actions,
    );
  }
}
