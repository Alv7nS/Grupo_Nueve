import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/donation.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/feedback.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/info_row.dart';
import '../../widgets/notice_box.dart';

/// Caso de utilização 3: leitura do QR Code do doador no ponto de recolha.
/// A câmara é simulada; na implementação será usado um leitor real.
class AdminScannerScreen extends StatefulWidget {
  const AdminScannerScreen({super.key});

  @override
  State<AdminScannerScreen> createState() => _AdminScannerScreenState();
}

class _AdminScannerScreenState extends State<AdminScannerScreen> {
  Donation? _scanned;
  bool _confirmed = false;

  void _simulateScan() {
    final approved = MockData.donations.where((d) => d.status == DonationStatus.approved);
    if (approved.isEmpty) {
      showInfo(context, 'Não há pedidos aprovados à espera de entrega.');
      return;
    }
    setState(() {
      _scanned = approved.first;
      _confirmed = false;
    });
  }

  void _confirmReception() {
    final d = _scanned;
    if (d == null) return;
    MockData.updateDonation(d.copyWith(
      status: DonationStatus.delivered,
      statusMessage: 'Tecido recebido. Preparação em curso.',
    ));
    MockData.addPoints(d.donorEmail, 120, 'Entrega validada · ${d.id}');
    setState(() => _confirmed = true);
    showInfo(context, '${d.id} marcado como «Entregue». +120 pontos atribuídos ao doador.');
  }

  @override
  Widget build(BuildContext context) {
    final d = _scanned;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        const Text(
          'Leia o QR Code apresentado pelo doador para validar a entrega.',
          style: AppText.bodyMuted,
        ),
        const SizedBox(height: 14),
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1B1F1D),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Icon(
                  d == null ? Icons.qr_code_scanner : Icons.check_circle,
                  size: 64,
                  color: d == null ? Colors.white54 : AppColors.greenLight,
                ),
                const Positioned(
                  bottom: 16,
                  child: Text(
                    'Pré-visualização da câmara (simulada)',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        AppButton(
          label: d == null ? 'Simular leitura de QR Code' : 'Ler outro código',
          icon: Icons.qr_code_scanner,
          onPressed: _simulateScan,
        ),
        const SizedBox(height: 16),
        if (d != null)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _confirmed ? 'Entrega confirmada' : 'Código válido',
                  style: AppText.section.copyWith(color: AppColors.green),
                ),
                const SizedBox(height: 8),
                InfoRow(label: 'Pedido', value: d.id),
                InfoRow(label: 'Peça', value: d.garment),
                InfoRow(label: 'Doador', value: d.donorName),
                InfoRow(label: 'Estado', value: _confirmed ? 'Entregue' : 'Aprovada · Aguarda entrega'),
                const SizedBox(height: 10),
                AppButton(
                  label: _confirmed ? 'Receção registada' : 'Confirmar receção da peça',
                  icon: Icons.inventory_2_outlined,
                  onPressed: _confirmed ? null : _confirmReception,
                ),
              ],
            ),
          )
        else
          const NoticeBox(
            icon: Icons.info_outline,
            title: 'Como funciona',
            message: 'Após a leitura, a API valida a autenticidade do código, altera o '
                'estado para «Entregue» e atribui os pontos ao doador.',
          ),
      ],
    );
  }
}
