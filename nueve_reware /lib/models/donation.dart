import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Estados possíveis de um pedido de doação (espelham os estados da BD).
enum DonationStatus { inReview, approved, rejected, delivered }

extension DonationStatusX on DonationStatus {
  String get label => switch (this) {
        DonationStatus.inReview => 'Em avaliação',
        DonationStatus.approved => 'Aprovada',
        DonationStatus.rejected => 'Não aprovada',
        DonationStatus.delivered => 'Entregue',
      };

  Color get background => switch (this) {
        DonationStatus.inReview => AppColors.warningLight,
        DonationStatus.approved => AppColors.green,
        DonationStatus.rejected => AppColors.errorLight,
        DonationStatus.delivered => AppColors.greenLight,
      };

  Color get foreground => switch (this) {
        DonationStatus.inReview => AppColors.warning,
        DonationStatus.approved => Colors.white,
        DonationStatus.rejected => AppColors.error,
        DonationStatus.delivered => AppColors.green,
      };

  /// "Em curso" = ainda precisa de ação; "Concluída" = fechada.
  bool get isOngoing =>
      this == DonationStatus.inReview || this == DonationStatus.approved;
}

/// Pedido de doação submetido por um utilizador doador.
class Donation {
  final String id;
  final String garment;
  final String category;
  final String condition;
  final String fabric;
  final String composition;
  final String notes;
  final String submittedAt;
  final String donorName;
  final String donorEmail; // identifica o dono do pedido (futuro: id do utilizador na BD)
  final DonationStatus status;
  final String statusMessage;
  final IconData icon;
  final List<String> photos; // caminhos das fotografias (assets nesta fase)

  const Donation({
    required this.id,
    required this.garment,
    required this.category,
    required this.condition,
    required this.fabric,
    required this.composition,
    required this.notes,
    required this.submittedAt,
    required this.donorName,
    this.donorEmail = '',
    required this.status,
    required this.statusMessage,
    this.icon = Icons.checkroom_outlined,
    this.photos = const [],
  });

  String? get mainPhoto => photos.isEmpty ? null : photos.first;

  Donation copyWith({DonationStatus? status, String? statusMessage}) {
    return Donation(
      id: id,
      garment: garment,
      category: category,
      condition: condition,
      fabric: fabric,
      composition: composition,
      notes: notes,
      submittedAt: submittedAt,
      donorName: donorName,
      donorEmail: donorEmail,
      status: status ?? this.status,
      statusMessage: statusMessage ?? this.statusMessage,
      icon: icon,
      photos: photos,
    );
  }
}
