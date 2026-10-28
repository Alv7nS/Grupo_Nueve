import 'package:flutter/material.dart';

import '../../models/misc_models.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/feedback.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/info_row.dart';
import '../../widgets/location_map.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/notice_box.dart';
import '../../widgets/page_app_bar.dart';

/// Instruções de entrega: mapa e localização escrita do ponto de recolha
/// (ou do armazém, no caso de envio por correio).
class DeliveryInstructionsScreen extends StatelessWidget {
  final DeliveryArgs args;

  const DeliveryInstructionsScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final p = args.point;
    final d = args.donation;

    return Scaffold(
      appBar: const PageAppBar(title: 'Instruções de entrega'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          FlowStepLabel(args.byMail ? 'Entrega · Envio por correio' : 'Entrega · Ponto de recolha'),
          LocationMap(lat: p.lat, lng: p.lng, label: p.name),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: AppColors.terracotta),
                    const SizedBox(width: 8),
                    Expanded(child: Text(p.name, style: AppText.section)),
                  ],
                ),
                const SizedBox(height: 10),
                InfoRow(label: 'Morada', value: '${p.address}\n${p.postalCode}'),
                InfoRow(label: 'Horário', value: p.hours),
                if (!args.byMail) InfoRow(label: 'Distância', value: '${p.distance} da sua morada'),
                InfoRow(label: args.byMail ? 'Envio' : 'Como chegar', value: p.directions),
                InfoRow(label: 'Contacto', value: p.contact),
                if (args.shipping != null) ...[
                  InfoRow(label: 'Enviar de', value: args.shipping!.fullAddress),
                  InfoRow(
                    label: 'Frete',
                    value: '${args.shipping!.quote.price.toStringAsFixed(2).replaceAll('.', ',')} € · '
                        '${args.shipping!.quote.eta}',
                  ),
                ],
                const SizedBox(height: 6),
                AppButton.secondary(
                  label: 'Abrir no Google Maps',
                  icon: Icons.directions_outlined,
                  onPressed: () => showSimulated(context, 'Navegação para o local'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Passo a passo', style: AppText.section),
          const SizedBox(height: 12),
          ChecklistItem(
            title: '1. Prepare a peça',
            subtitle: 'Entregue apenas a ${d.garment.toLowerCase()} do pedido ${d.id}, limpa e seca.',
          ),
          ChecklistItem(
            title: '2. Embale e identifique',
            subtitle: args.byMail
                ? 'Coloque a peça numa embalagem com o QR Code impresso no interior.'
                : 'Use um saco ou caixa com a referência ${d.id} visível.',
          ),
          ChecklistItem(
            title: args.byMail ? '3. Envie pelos correios' : '3. Dirija-se ao ponto de recolha',
            subtitle: args.byMail
                ? 'Use a guia de envio gerada na aplicação, com o frete calculado.'
                : 'Dentro do horário indicado. Não é necessária marcação.',
          ),
          ChecklistItem(
            title: args.byMail ? '4. Aguarde a confirmação' : '4. Mostre o QR Code ao operador',
            subtitle: args.byMail
                ? 'O estado passa a «Entregue» quando a equipa ler o código.'
                : 'Após a leitura, o estado passa a «Entregue» e recebe os pontos.',
          ),
          const SizedBox(height: 4),
          const NoticeBox(
            icon: Icons.info_outline,
            title: 'Morada e mapa ilustrativos',
            message: 'Os locais e contactos apresentados são fictícios, apenas para '
                'demonstração do protótipo.',
          ),
          const SizedBox(height: 16),
          AppButton(
            label: args.fromQr ? 'Voltar ao QR Code' : 'Apresentar QR Code de entrega',
            icon: Icons.qr_code_2,
            onPressed: () => args.fromQr
                ? Navigator.pop(context)
                : Navigator.pushReplacementNamed(context, AppRoutes.deliveryQr, arguments: args),
          ),
        ],
      ),
    );
  }
}
