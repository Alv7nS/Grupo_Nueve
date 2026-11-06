import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/donation.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/info_row.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/notice_box.dart';
import '../../widgets/page_app_bar.dart';
import '../../widgets/photo_strip.dart';

/// Passo 2 do fluxo de doação: rever dados e submeter o pedido.
class ReviewDonationScreen extends StatefulWidget {
  final Donation donation;

  const ReviewDonationScreen({super.key, required this.donation});

  @override
  State<ReviewDonationScreen> createState() => _ReviewDonationScreenState();
}

class _ReviewDonationScreenState extends State<ReviewDonationScreen> {
  bool _accepted = false;
  bool _submitted = false;

  void _submit() {
    // Simulação do POST /donations — guarda apenas em memória.
    MockData.donations.insert(0, widget.donation);
    MockData.pendingReview.insert(0, widget.donation); // aparece na triagem do gestor
    MockData.notifyChanged();
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.donation;

    return Scaffold(
      appBar: const PageAppBar(title: 'Rever e submeter'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          const FlowStepLabel('Doação · 2 / 6 · Submeter'),
          const Text(
            'Confirme os dados antes de enviar o pedido à equipa Nuevé ReWare.',
            style: AppText.bodyMuted,
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.garment, style: AppText.section),
                const SizedBox(height: 12),
                PhotoStrip(photos: d.photos, size: 110),
                const SizedBox(height: 12),
                InfoRow(label: 'Categoria', value: d.category),
                InfoRow(label: 'Estado', value: d.condition),
                InfoRow(label: 'Tecido', value: '${d.fabric} · ${d.composition}'),
                InfoRow(label: 'Observações', value: d.notes),
                if (!_submitted)
                  AppButton.text(
                    label: 'Editar fotografias e detalhes',
                    onPressed: () => Navigator.pop(context),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (!_submitted) ...[
            CheckboxListTile(
              value: _accepted,
              onChanged: (v) => setState(() => _accepted = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.green,
              title: const Text(
                'Li os termos da doação e a política de privacidade. Confirmo que '
                'posso doar esta peça.',
                style: AppText.small,
              ),
            ),
            const SizedBox(height: 8),
            AppButton(
              label: 'Confirmar submissão',
              onPressed: _accepted ? _submit : null,
            ),
            const SizedBox(height: 10),
            const Text(
              'A submissão não garante aprovação. Aguarde as instruções antes de '
              'entregar ou enviar a peça.',
              style: AppText.small,
            ),
          ] else
            NoticeBox(
              tone: NoticeTone.success,
              icon: Icons.check_circle_outline,
              title: 'Doação submetida',
              message: 'Pedido ${d.id}. A equipa irá avaliar as fotografias e o tecido. '
                  'Receberá uma notificação com a decisão.',
              footer: AppButton.secondary(
                label: 'Ver acompanhamento',
                icon: Icons.arrow_forward,
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.donationTracking,
                  ModalRoute.withName(AppRoutes.shell),
                  arguments: d,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
