import 'package:flutter/material.dart';

import '../models/donation.dart';
import '../theme/app_colors.dart';

/// Etiqueta de estado (ex.: «Em avaliação», «Aprovada»).
class StatusBadge extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;

  const StatusBadge({
    super.key,
    required this.label,
    this.background = AppColors.muted,
    this.foreground = AppColors.text,
  });

  factory StatusBadge.donation(DonationStatus status, {Key? key}) {
    return StatusBadge(
      key: key,
      label: status.label,
      background: status.background,
      foreground: status.foreground,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  }
}
