import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/donation.dart';
import '../../models/misc_models.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/fake_qr_code.dart';
import '../../widgets/info_row.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/notice_box.dart';
import '../../widgets/page_app_bar.dart';
import '../../widgets/status_badge.dart';

/// Passo 5: QR Code único a apresentar ao operador do ponto de recolha.
class DeliveryQrScreen extends StatelessWidget {
  final DeliveryArgs args;

  const DeliveryQrScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final donation = args.donation;
    return Scaffold(
      appBar: const PageAppBar(title: 'QR Code de entrega'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          const FlowStepLabel('Doação · 5 / 6 · Validar no local'),
          const Text(
            'Apresente este código ao operador quando entregar a peça aprovada.',
            style: AppText.bodyMuted,
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                const StatusBadge(
                  label: 'Aprovada · Aguarda entrega',
                  background: AppColors.green,
                  foreground: Colors.white,
                ),
                const SizedBox(height: 16),
                FakeQrCode(data: 'NUEVE-${donation.id}', size: 200),
                const SizedBox(height: 12),
                Text(donation.id, style: AppText.title),
                const SizedBox(height: 4),
                const Text('Código ilustrativo · Não utilizável', style: AppText.small),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              children: [
                InfoRow(label: 'Peça', value: donation.garment),
                InfoRow(label: 'Doador', value: donation.donorName),
                InfoRow(
                  label: 'Entrega',
                  value: args.byMail ? 'Envio por correio' : args.point.name,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const NoticeBox(
            icon: Icons.qr_code_scanner,
            title: 'A confirmação é feita pelo operador',
            message: 'Este código é único por pedido. Após a leitura e validação, o '
                'estado passa a «Entregue» e os pontos são atribuídos. Não partilhe '
                'o código publicamente.',
          ),
          const SizedBox(height: 16),
          AppButton.secondary(
            label: 'Consultar instruções de entrega',
            icon: Icons.map_outlined,
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.deliveryInstructions,
              arguments: args.openedFromQr(),
            ),
          ),
          const SizedBox(height: 10),
          AppButton.text(
            label: 'Simular leitura pelo operador (demo)',
            expanded: true,
            onPressed: () {
              final delivered = MockData.updateDonation(donation.copyWith(
                status: DonationStatus.delivered,
                statusMessage: 'Tecido recebido. Preparação em curso.',
              ));
              MockData.addPoints(
                donation.donorEmail,
                120,
                'Entrega validada · ${donation.id}',
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.deliveryConfirmed,
                ModalRoute.withName(AppRoutes.shell),
                arguments: delivered,
              );
            },
          ),
        ],
      ),
    );
  }
}
