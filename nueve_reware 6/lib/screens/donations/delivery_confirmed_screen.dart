import 'package:flutter/material.dart';

import '../../models/donation.dart';
import '../../models/misc_models.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/notice_box.dart';
import '../../widgets/page_app_bar.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/timeline_step.dart';

/// Passo 6: entrega confirmada, pontos atribuídos e rastreio do tecido.
class DeliveryConfirmedScreen extends StatelessWidget {
  final Donation donation;

  const DeliveryConfirmedScreen({super.key, required this.donation});

  static const _nextLife = [
    TimelineItem('Receção confirmada', 'Entrega validada através do QR Code.', TimelineState.done),
    TimelineItem('Desconstrução e higienização', 'Próxima etapa, a realizar pela equipa.', TimelineState.current),
    TimelineItem('Criação de novas peças', 'O tecido é transformado pelos artesãos.', TimelineState.pending),
    TimelineItem('Peças disponíveis no catálogo', 'As novas peças serão associadas à sua doação.', TimelineState.pending),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageAppBar(title: 'Entrega confirmada'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          const FlowStepLabel('Doação · 6 / 6 · Acompanhar o tecido'),
          NoticeBox(
            tone: NoticeTone.success,
            icon: Icons.favorite_border,
            title: 'Obrigado pela sua doação!',
            message: 'Pedido ${donation.id} · ${donation.garment}. '
                'Validado pelo operador · Exemplo.',
            footer: StatusBadge.donation(DonationStatus.delivered),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.stars_outlined, color: AppColors.terracotta),
                    SizedBox(width: 10),
                    Expanded(child: Text('+120 pontos atribuídos', style: AppText.section)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Crédito registado na sua conta após a validação da entrega. '
                  'Pode usá-lo como desconto no catálogo.',
                  style: AppText.bodyMuted,
                ),
                const SizedBox(height: 8),
                AppButton.text(
                  label: 'Consultar pontos e descontos',
                  icon: Icons.arrow_forward,
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.points),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('A próxima vida do seu tecido', style: AppText.section),
          const SizedBox(height: 14),
          const TimelineList(items: _nextLife),
          const SizedBox(height: 12),
          const NoticeBox(
            icon: Icons.hourglass_empty,
            title: 'Ainda não há novas peças associadas',
            message: 'Avisaremos quando o tecido der origem a uma nova peça. Pode '
                'voltar a este acompanhamento em «Minhas doações».',
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Voltar às minhas doações',
            onPressed: () => AppRoutes.goToTab(context, 1),
          ),
          const SizedBox(height: 10),
          AppButton.secondary(
            label: 'Explorar o catálogo',
            onPressed: () => AppRoutes.goToTab(context, 2),
          ),
        ],
      ),
    );
  }
}
