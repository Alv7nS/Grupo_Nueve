import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/donation.dart';
import '../../models/misc_models.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/feedback.dart';
import '../../widgets/address_shipping_form.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/info_row.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/notice_box.dart';
import '../../widgets/page_app_bar.dart';
import '../../widgets/segmented_tabs.dart';

/// Passo 4: doação aprovada — escolher forma de entrega.
class DonationApprovedScreen extends StatefulWidget {
  final Donation donation;

  const DonationApprovedScreen({super.key, required this.donation});

  @override
  State<DonationApprovedScreen> createState() => _DonationApprovedScreenState();
}

class _DonationApprovedScreenState extends State<DonationApprovedScreen> {
  int _method = 0; // 0 = ponto de recolha, 1 = correio
  int _selectedPoint = 0;
  ShippingResult? _mailShipping; // morada do doador + portes (envio por correio)

  bool get _canContinue => _method == 0 || _mailShipping != null;

  String _eur(double v) => '${v.toStringAsFixed(2).replaceAll('.', ',')} €';

  DeliveryArgs get _args => DeliveryArgs(
        donation: widget.donation,
        point: _method == 0 ? MockData.collectionPoints[_selectedPoint] : MockData.warehouse,
        byMail: _method == 1,
        shipping: _method == 1 ? _mailShipping : null,
      );

  @override
  Widget build(BuildContext context) {
    final d = widget.donation;

    return Scaffold(
      appBar: const PageAppBar(title: 'Doação aprovada'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          const FlowStepLabel('Doação · 4 / 6 · Preparar entrega'),
          NoticeBox(
            tone: NoticeTone.success,
            icon: Icons.check_circle_outline,
            title: 'O tecido pode ser aproveitado',
            message: 'Pedido ${d.id} · ${d.garment}. Aprovada pela equipa. '
                'Já pode preparar a entrega.',
          ),
          const SizedBox(height: 20),
          const Text('Como pretende entregar?', style: AppText.section),
          const SizedBox(height: 12),
          SegmentedTabs(
            options: const ['Ponto de recolha', 'Enviar por correio'],
            selectedIndex: _method,
            onChanged: (i) => setState(() {
              _method = i;
              _mailShipping = null;
            }),
          ),
          const SizedBox(height: 14),
          if (_method == 0) ...[
            const Text('Pontos de recolha próximos', style: AppText.label),
            const SizedBox(height: 8),
            // Coleção dinâmica de pontos de recolha (no futuro: GPS + mapa).
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: MockData.collectionPoints.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final p = MockData.collectionPoints[i];
                return SelectableCard(
                  selected: i == _selectedPoint,
                  onTap: () => setState(() => _selectedPoint = i),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(p.name, style: AppText.cardTitle)),
                          Text(p.distance, style: AppText.small),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(p.address, style: AppText.body),
                      Text(p.hours, style: AppText.small),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: AppButton.text(
                label: 'Ver localização no mapa',
                icon: Icons.map_outlined,
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.deliveryInstructions,
                  arguments: _args,
                ),
              ),
            ),
          ] else ...[
            AddressShippingForm(
              title: 'A sua morada',
              subtitle: 'De onde vai enviar a peça? Calculamos o valor do envio até '
                  'ao armazém Nuevé ReWare.',
              resultPrefix: 'Enviar a partir de',
              onChanged: (r) => setState(() => _mailShipping = r),
            ),
            if (_mailShipping != null) ...[
              const SizedBox(height: 12),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.local_shipping_outlined, color: AppColors.green),
                        SizedBox(width: 10),
                        Text('Resumo do envio', style: AppText.cardTitle),
                      ],
                    ),
                    const SizedBox(height: 10),
                    InfoRow(label: 'Origem', value: _mailShipping!.fullAddress),
                    InfoRow(
                      label: 'Destino',
                      value: '${MockData.warehouse.name}\n'
                          '${MockData.warehouse.address}, ${MockData.warehouse.postalCode}',
                    ),
                    InfoRow(label: 'Referência', value: d.id),
                    InfoRow(
                      label: 'Frete',
                      value: '${_eur(_mailShipping!.quote.price)} · ${_mailShipping!.quote.eta}',
                    ),
                    const SizedBox(height: 6),
                    AppButton.secondary(
                      label: 'Gerar guia de envio',
                      icon: Icons.description_outlined,
                      onPressed: () => showSimulated(context, 'Geração da guia de envio'),
                    ),
                  ],
                ),
              ),
            ],
          ],
          const SizedBox(height: 20),
          const Text('Antes de sair de casa', style: AppText.section),
          const SizedBox(height: 12),
          ChecklistItem(
            title: 'Separe a peça aprovada',
            subtitle: 'Entregue apenas a ${d.garment.toLowerCase()} indicada no pedido.',
            done: true,
          ),
          ChecklistItem(
            title: 'Proteja a roupa numa embalagem',
            subtitle: 'Mantenha a referência ${d.id} visível.',
          ),
          ChecklistItem(
            title: _method == 0 ? 'Apresente o seu QR Code' : 'Inclua o QR Code impresso',
            subtitle: 'O operador lê o código e confirma a receção.',
          ),
          const SizedBox(height: 6),
          AppButton(
            label: 'Apresentar QR Code de entrega',
            icon: Icons.qr_code_2,
            onPressed: _canContinue
                ? () => Navigator.pushNamed(
                      context,
                      AppRoutes.deliveryQr,
                      arguments: _args,
                    )
                : null,
          ),
          if (!_canContinue) ...[
            const SizedBox(height: 6),
            const Text(
              'Indique a sua morada e calcule o frete para continuar.',
              style: AppText.small,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
