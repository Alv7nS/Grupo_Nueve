import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/donation.dart';
import '../../models/misc_models.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_text.dart';
import '../../utils/feedback.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/info_row.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/notice_box.dart';
import '../../widgets/page_app_bar.dart';
import '../../widgets/photo_strip.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/timeline_step.dart';

/// Passo 3: acompanhar um pedido em avaliação (ou ver o motivo da recusa).
class DonationTrackingScreen extends StatelessWidget {
  final Donation donation;

  const DonationTrackingScreen({super.key, required this.donation});

  List<TimelineItem> get _steps {
    final rejected = donation.status == DonationStatus.rejected;
    return [
      const TimelineItem('Pedido submetido', 'Fotografias e detalhes recebidos.', TimelineState.done),
      TimelineItem(
        'Avaliação pela equipa',
        'Verificação do estado e do potencial do tecido.',
        rejected ? TimelineState.done : TimelineState.current,
      ),
      TimelineItem(
        rejected ? 'Decisão: não aprovada' : 'Decisão e instruções',
        rejected
            ? 'Consulte o motivo indicado pela equipa.'
            : 'Se aprovado, receberá orientações e um QR Code.',
        rejected ? TimelineState.current : TimelineState.pending,
      ),
      if (!rejected)
        const TimelineItem(
          'Entrega da peça',
          'Apenas após aprovação e validação no local.',
          TimelineState.pending,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final rejected = donation.status == DonationStatus.rejected;

    return Scaffold(
      appBar: const PageAppBar(title: 'Acompanhar doação'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          const FlowStepLabel('Doação · 3 / 6 · Aguardar avaliação'),
          Row(
            children: [
              Expanded(child: Text('Pedido ${donation.id}', style: AppText.cardTitle)),
              StatusBadge.donation(donation.status),
            ],
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PhotoStrip(photos: donation.photos, size: 140),
                const SizedBox(height: 12),
                Text(donation.garment, style: AppText.section),
                const SizedBox(height: 6),
                InfoRow(label: 'Submetida', value: donation.submittedAt),
                InfoRow(label: 'Tecido / estado', value: '${donation.composition} · ${donation.condition}'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Estado do pedido', style: AppText.section),
          const SizedBox(height: 14),
          TimelineList(items: _steps),
          const SizedBox(height: 16),
          if (rejected)
            NoticeBox(
              tone: NoticeTone.error,
              icon: Icons.info_outline,
              title: 'Motivo da decisão',
              message: '${donation.statusMessage} Pode entregar a peça num contentor '
                  'têxtil convencional ou submeter outra peça.',
            )
          else
            const NoticeBox(
              icon: Icons.schedule_outlined,
              title: 'Ainda não precisa de entregar a peça',
              message: 'A avaliação é manual. Será notificado na aplicação quando '
                  'houver uma decisão. Não envie a peça nesta fase.',
            ),
          const SizedBox(height: 16),
          AppButton.secondary(
            label: 'Contactar a equipa',
            icon: Icons.chat_bubble_outline,
            onPressed: () => showSimulated(context, 'Contacto com a equipa'),
          ),
          if (!rejected) ...[
            const SizedBox(height: 10),
            // Atalho de demonstração: permite percorrer o fluxo completo sem backend.
            AppButton.text(
              label: 'Simular aprovação pela equipa (demo)',
              expanded: true,
              onPressed: () => Navigator.pushReplacementNamed(
                context,
                AppRoutes.donationApproved,
                arguments: MockData.updateDonation(donation.copyWith(
                  status: DonationStatus.approved,
                  statusMessage: 'Consulte as instruções de entrega.',
                )),
              ),
            ),
          ],
          const SizedBox(height: 8),
          const Text('Última atualização: hoje, 09:30 · Exemplo', style: AppText.small),
        ],
      ),
    );
  }
}
