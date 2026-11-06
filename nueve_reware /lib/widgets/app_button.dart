import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum AppButtonVariant { primary, secondary, accent, text }

/// Botão reutilizável com as variantes do Style Guide.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool expanded;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.expanded = true,
  });

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = false,
  }) : variant = AppButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    const padding = EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    const textStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w600);

    final Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Flexible(child: Text(label, textAlign: TextAlign.center)),
      ],
    );

    final Color bg = variant == AppButtonVariant.accent
        ? AppColors.terracotta
        : AppColors.green;

    late Widget button;
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.accent:
        button = ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.border,
            disabledForegroundColor: AppColors.textMuted,
            elevation: 0,
            padding: padding,
            shape: shape,
            textStyle: textStyle,
          ),
          child: child,
        );
        break;
      case AppButtonVariant.secondary:
        button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.text,
            backgroundColor: AppColors.surface,
            side: const BorderSide(color: AppColors.text, width: 1.2),
            padding: padding,
            shape: shape,
            textStyle: textStyle,
          ),
          child: child,
        );
        break;
      case AppButtonVariant.text:
        button = TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.green,
            textStyle: textStyle.copyWith(decoration: TextDecoration.underline),
          ),
          child: child,
        );
        break;
    }

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
