import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

enum NoticeTone { neutral, success, warning, error }

/// Caixa de aviso/informação com ícone, título e mensagem.
class NoticeBox extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final NoticeTone tone;
  final Widget? footer;

  const NoticeBox({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.tone = NoticeTone.neutral,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color accent) = switch (tone) {
      NoticeTone.neutral => (AppColors.muted, AppColors.text),
      NoticeTone.success => (AppColors.greenLight, AppColors.green),
      NoticeTone.warning => (AppColors.warningLight, AppColors.warning),
      NoticeTone.error => (AppColors.errorLight, AppColors.error),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: accent, size: 22),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(title, style: AppText.cardTitle.copyWith(color: accent)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(message, style: AppText.bodyMuted.copyWith(fontSize: 13)),
          if (footer != null) ...[
            const SizedBox(height: 12),
            footer!,
          ],
        ],
      ),
    );
  }
}
