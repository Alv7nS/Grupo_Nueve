import 'package:flutter/material.dart';

import '../models/donation.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'app_card.dart';
import 'garment_placeholder.dart';
import 'status_badge.dart';

/// Cartão de pedido de doação (lista «Minhas doações», início, gestor).
class DonationCard extends StatelessWidget {
  final Donation donation;
  final VoidCallback onTap;
  final bool showDonor;

  const DonationCard({
    super.key,
    required this.donation,
    required this.onTap,
    this.showDonor = false,
  });

  /// Texto da ação conforme o estado (igual ao mockup Figma).
  String get actionLabel => switch (donation.status) {
        DonationStatus.inReview => 'Ver acompanhamento',
        DonationStatus.approved => 'Ver instruções e QR',
        DonationStatus.delivered => 'Acompanhar o tecido',
        DonationStatus.rejected => 'Ver avaliação',
      };

  @override
  Widget build(BuildContext context) {
    final meta = showDonor
        ? '${donation.id} · ${donation.submittedAt} · ${donation.donorName}'
        : '${donation.id} · ${donation.submittedAt}';

    final content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(donation.garment, style: AppText.cardTitle)),
              const SizedBox(width: 8),
              StatusBadge.donation(donation.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(meta, style: AppText.small),
          const SizedBox(height: 8),
          Text(donation.statusMessage, style: AppText.bodyMuted),
          const SizedBox(height: 12),
          Row(
            children: [
              Flexible(
                child: Text(
                  showDonor ? 'Avaliar pedido' : actionLabel,
                  style: AppText.cardTitle.copyWith(fontSize: 14, color: AppColors.green),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward, size: 16, color: AppColors.green),
            ],
          ),
        ],
    );

    final photo = donation.mainPhoto;
    return AppCard(
      onTap: onTap,
      child: photo == null
          ? content
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 64,
                  child: GarmentPlaceholder(image: photo, height: 64),
                ),
                const SizedBox(width: 12),
                Expanded(child: content),
              ],
            ),
    );
  }
}
