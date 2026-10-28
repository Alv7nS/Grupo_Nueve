import 'package:flutter/material.dart';

import '../theme/app_text.dart';

/// Título de secção com ação opcional à direita (ex.: «Ver todas»).
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppText.section)),
          if (actionLabel != null)
            InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(actionLabel!, style: AppText.link),
              ),
            ),
        ],
      ),
    );
  }
}
