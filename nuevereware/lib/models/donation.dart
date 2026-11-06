import 'package:flutter/material.dart';

import '../utils/json_utils.dart';

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

  /// Valor usado na API / base de dados.
  String get apiValue => switch (this) {
        DonationStatus.inReview => 'em_avaliacao',
        DonationStatus.approved => 'aprovada',
        DonationStatus.rejected => 'recusada',
        DonationStatus.delivered => 'entregue',
      };

  static DonationStatus fromApi(String? value) => switch (value) {
        'aprovada' => DonationStatus.approved,
        'recusada' => DonationStatus.rejected,
        'entregue' => DonationStatus.delivered,
        _ => DonationStatus.inReview,
      };

  /// "Em curso" = ainda precisa de ação; "Concluída" = fechada.
  bool get isOngoing =>
      this == DonationStatus.inReview || this == DonationStatus.approved;
}

/// Pedido de doação submetido por um utilizador doador.
class Donation {
  final int? dbId; // id numérico na base de dados
  final String id; // referência apresentada ao utilizador (ex.: D-024)
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
    this.dbId,
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

  /// Converte o JSON da API (ver API_CONTRATO.md) numa Donation.
  factory Donation.fromJson(Map<String, dynamic> json) {
    final dbId = asIntOrNull(json['id']);
    final status = DonationStatusX.fromApi(json['estado']?.toString());
    final categoria = asString(json['categoria'], 'Peça');
    final tecido = asString(json['tecido'], 'Não sei');
    return Donation(
      dbId: dbId,
      id: dbId == null ? 'D-???' : 'D-${dbId.toString().padLeft(3, '0')}',
      garment: asString(json['nome_peca'], '$categoria de ${tecido.toLowerCase()}'),
      category: categoria,
      condition: asString(json['estado_peca'], ''),
      fabric: tecido,
      composition: asString(json['composicao'], 'Não indicada'),
      notes: asString(json['observacoes'], ''),
      submittedAt: asDateLabel(json['data_submissao']),
      donorName: asString(json['doador_nome'], ''),
      donorEmail: asString(json['doador_email'], ''),
      status: status,
      statusMessage: asString(json['mensagem_estado'], _defaultMessage(status)),
      photos: ((json['fotografias'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  /// JSON enviado no POST /doacoes.
  Map<String, dynamic> toCreateJson(int utilizadorId) => {
        'utilizador_id': utilizadorId,
        'categoria': category,
        'estado_peca': condition,
        'tecido': fabric,
        'composicao': composition,
        'observacoes': notes,
        'fotografias': photos,
      };

  static String _defaultMessage(DonationStatus s) => switch (s) {
        DonationStatus.inReview => 'A equipa está a analisar as fotografias.',
        DonationStatus.approved => 'Consulte as instruções de entrega.',
        DonationStatus.rejected => 'Consulte o motivo indicado pela equipa.',
        DonationStatus.delivered => 'Tecido recebido. Preparação em curso.',
      };

  String? get mainPhoto => photos.isEmpty ? null : photos.first;

  Donation copyWith({
    DonationStatus? status,
    String? statusMessage,
    List<String>? photos,
    String? donorName,
    String? donorEmail,
  }) {
    return Donation(
      dbId: dbId,
      id: id,
      garment: garment,
      category: category,
      condition: condition,
      fabric: fabric,
      composition: composition,
      notes: notes,
      submittedAt: submittedAt,
      donorName: donorName ?? this.donorName,
      donorEmail: donorEmail ?? this.donorEmail,
      status: status ?? this.status,
      statusMessage: statusMessage ?? this.statusMessage,
      icon: icon,
      photos: photos ?? this.photos,
    );
  }
}
