import 'package:finger_print_flutter/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'app_card.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String trailingText;
  final Color trailingColor;
  final double? fontSize;

  const MetricCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.trailingText,
    required this.trailingColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: title,
      subtitle: subtitle,
      leading: Icon(icon, size: 36, color: iconColor),
      trailing: Text(
        trailingText,
        style: AppTextStyles.subheading.copyWith(color: trailingColor,fontSize: fontSize ?? 20),
      ),
    );
  }
}
