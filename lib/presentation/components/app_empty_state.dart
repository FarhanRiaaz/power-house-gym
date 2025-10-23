import 'package:finger_print_flutter/core/style/app_colors.dart';
import 'package:finger_print_flutter/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppEmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const AppEmptyState({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width*0.35,
            height: MediaQuery.of(context).size.height*0.40 ,
            child: Image.asset("assets/images/illus.png",fit: BoxFit.fitHeight,color: Colors.white60,)),
          Text(message, style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
          if (actionLabel != null && onActionTap != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onActionTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
              ),
              child: Text(actionLabel!, style: AppTextStyles.subheading),
            ),
          ],
        ],
      ),
    );
  }
}
