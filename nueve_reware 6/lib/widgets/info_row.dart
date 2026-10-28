import 'package:flutter/material.dart';

import '../theme/app_text.dart';

/// Linha «rótulo — valor» usada em resumos e detalhes.
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final double labelWidth;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.labelWidth = 110,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: labelWidth, child: Text(label, style: AppText.bodyMuted)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, style: AppText.body)),
        ],
      ),
    );
  }
}
