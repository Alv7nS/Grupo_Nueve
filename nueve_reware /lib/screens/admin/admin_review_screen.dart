import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/donation.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/feedback.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/form_fields.dart';
import '../../widgets/info_row.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/page_app_bar.dart';
import '../../widgets/photo_strip.dart';

/// Caso de utilização 2: triagem e validação da peça pelo gestor.
class AdminReviewScreen extends StatefulWidget {
  final Donation donation;

  const AdminReviewScreen({super.key, required this.donation});

  @override
  State<AdminReviewScreen> createState() => _AdminReviewScreenState();
}

class _AdminReviewScreenState extends State<AdminReviewScreen> {
  final Map<String, bool> _checks = {
    'Fotografias suficientes para avaliar': true,
    'Tecido com potencial de reutilização': true,
    'Danos localizados e aproveitáveis': false,
  };
  String _method = MockData.deliveryMethods.first;
  String _point = MockData.collectionPoints.first.name;
  late final TextEditingController _message = TextEditingController(
    text: 'Embale a peça e identifique o pedido ${widget.donation.id}. '
        'Apresente o QR Code no ponto de recolha.',
  );

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  void _finish(String message, DonationStatus newStatus, String statusMessage) {
    MockData.pendingReview.removeWhere((d) => d.id == widget.donation.id);
    // Se o pedido pertence ao utilizador de exemplo, o estado reflete-se
    // também em «Minhas doações» (simula a atualização na BD).
    MockData.updateDonation(
      widget.donation.copyWith(status: newStatus, statusMessage: statusMessage),
    );
    showInfo(context, message);
    Navigator.pop(context);
  }

  Future<void> _reject() async {
    const reasons = [
      'Tecido sem potencial de reaproveitamento',
      'Fotografias insuficientes',
      'Peça fora das categorias aceites',
    ];
    final reason = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('Indicar motivo da recusa', style: AppText.section),
            ),
            for (final r in reasons)
              ListTile(
                leading: const Icon(Icons.block, color: AppColors.error),
                title: Text(r),
                onTap: () => Navigator.pop(ctx, r),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (reason != null && mounted) {
      _finish(
        'Pedido ${widget.donation.id} não aprovado: $reason (simulado).',
        DonationStatus.rejected,
        '$reason.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.donation;
    final keys = _checks.keys.toList();

    return Scaffold(
      appBar: const PageAppBar(title: 'Avaliar pedido', showNotifications: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          const FlowStepLabel('Gestão · Triagem manual'),
          Text('${d.id} · ${d.garment}', style: AppText.section),
          const SizedBox(height: 4),
          Text('Submetido a ${d.submittedAt} por ${d.donorName}', style: AppText.small),
          const SizedBox(height: 16),
          const Text('Fotografias recebidas', style: AppText.cardTitle),
          const SizedBox(height: 10),
          PhotoStrip(photos: d.photos, size: 130),
          const SizedBox(height: 6),
          const Text('Toque numa fotografia para ampliar e verificar os danos.',
              style: AppText.small),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Especificações do doador', style: AppText.cardTitle),
                const SizedBox(height: 6),
                InfoRow(label: 'Estado', value: d.condition),
                InfoRow(label: 'Tecido', value: d.composition),
                InfoRow(label: 'Danos', value: d.notes),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Avaliação do potencial do tecido', style: AppText.section),
          const SizedBox(height: 4),
          for (final k in keys)
            CheckboxListTile(
              value: _checks[k],
              onChanged: (v) => setState(() => _checks[k] = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.green,
              dense: true,
              title: Text(k, style: AppText.body),
            ),
          const SizedBox(height: 8),
          const AppTextField(
            label: 'Nota da avaliação',
            hint: 'Ex.: tecido aproveitável no corpo da peça',
            maxLines: 2,
          ),
          const SizedBox(height: 20),
          const Text('Instruções a enviar ao doador', style: AppText.section),
          const SizedBox(height: 12),
          AppDropdown(
            label: 'Métodos autorizados',
            value: _method,
            items: MockData.deliveryMethods,
            onChanged: (v) => setState(() => _method = v),
          ),
          const SizedBox(height: 14),
          AppDropdown(
            label: 'Ponto / morada de receção',
            value: _point,
            items: MockData.collectionPoints.map((p) => p.name).toList(),
            onChanged: (v) => setState(() => _point = v),
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Mensagem de entrega',
            maxLines: 3,
            controller: _message,
          ),
          const SizedBox(height: 20),
          AppButton(
            label: 'Aprovar e enviar instruções',
            icon: Icons.check,
            onPressed: () => _finish(
              'Pedido ${d.id} aprovado. Notificação push enviada ao doador (simulado).',
              DonationStatus.approved,
              'Consulte as instruções de entrega.',
            ),
          ),
          const SizedBox(height: 10),
          AppButton.secondary(
            label: 'Pedir fotografias ou detalhes',
            onPressed: () => showSimulated(context, 'Pedido de mais informação'),
          ),
          const SizedBox(height: 4),
          Center(
            child: AppButton.text(label: 'Não aprovar · Indicar motivo', onPressed: _reject),
          ),
        ],
      ),
    );
  }
}
