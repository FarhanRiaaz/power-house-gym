import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? leadingIcon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? statusColor;
  final bool isSelected;

  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.trailing,
    this.onTap,
    this.statusColor,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      tileColor: isSelected?AppColors.primary: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: leadingIcon != null
          ? CircleAvatar(
              backgroundColor: statusColor ?? AppColors.primary,
              child: Icon(leadingIcon, color: Colors.black),
            )
          : null,
      title: Text(title, style: AppTextStyles.subheading),
      subtitle: subtitle != null ? Text(subtitle!, style: AppTextStyles.caption) : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
