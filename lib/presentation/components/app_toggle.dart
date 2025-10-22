import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppToggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;
  final Color activeColor;

  const AppToggle({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.icon,
    this.activeColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) Icon(icon, color: activeColor),
        if (icon != null) const SizedBox(width: 8),
        Expanded(child: Text(label, style: AppTextStyles.body)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.black,
          activeTrackColor: activeColor,
          inactiveThumbColor: AppColors.surface,
          inactiveTrackColor: AppColors.textSecondary.withOpacity(0.4),
        ),
      ],
    );
  }
}
