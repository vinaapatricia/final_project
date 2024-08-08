import 'package:flutter/material.dart';
import '../../../core/configs/theme/app_colors.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final Color? color;
  final Widget? prefixIcon;
  final bool isOutlined;

  const AuthButton({
    super.key,
    required this.onTap,
    required this.text,
    this.color,
    this.prefixIcon,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 42,
        width: 334,
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: isOutlined ? Border.all(color: AppColors.primary) : null,
          borderRadius: BorderRadius.circular(30),
          color: isOutlined ? Colors.transparent : (color ?? AppColors.primary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isOutlined ? AppColors.primary : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
