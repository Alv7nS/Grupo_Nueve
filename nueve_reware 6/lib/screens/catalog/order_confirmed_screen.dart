import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/notice_box.dart';

/// Confirmação de encomenda após o checkout simulado.
class OrderConfirmedScreen extends StatelessWidget {
  final String orderId;

  const OrderConfirmedScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.greenLight,
                child: Icon(Icons.check, size: 48, color: AppColors.green),
              ),
              const SizedBox(height: 20),
              const Text('Encomenda confirmada!', style: AppText.title),
              const SizedBox(height: 8),
              Text(
                'Encomenda $orderId · Exemplo. Receberá um e-mail com os detalhes '
                'e o seguimento do envio.',
                style: AppText.bodyMuted,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const NoticeBox(
                tone: NoticeTone.success,
                icon: Icons.eco_outlined,
                title: 'Impacto da sua compra',
                message: 'Ao escolher uma peça Nuevé ReWare evitou que cerca de '
                    '0,8 kg de tecido fosse para aterro (valor ilustrativo).',
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'Continuar a explorar',
                onPressed: () => AppRoutes.goToTab(context, 2),
              ),
              const SizedBox(height: 10),
              AppButton.secondary(
                label: 'Voltar ao início',
                onPressed: () => AppRoutes.goToTab(context, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
