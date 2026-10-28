import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Cartão base (fundo branco, borda suave, cantos arredondados).
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color borderColor;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = AppColors.surface,
    this.borderColor = AppColors.border,
    this.onTap,
  });

  /// Variante neutra usada para avisos/informação secundária.
  const AppCard.muted({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  })  : color = AppColors.muted,
        borderColor = AppColors.muted;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14);
    return Material(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
