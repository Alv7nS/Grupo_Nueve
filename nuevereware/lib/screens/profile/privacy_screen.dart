import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/feedback.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/notice_box.dart';
import '../../widgets/page_app_bar.dart';

/// Direitos do titular dos dados (RGPD) e consentimentos.
class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  final Map<String, bool> _consents = {
    'Notificações sobre as minhas doações': true,
    'Novidades e campanhas por e-mail': false,
    'Partilhar estatísticas anónimas de impacto': true,
  };

  @override
  Widget build(BuildContext context) {
    final keys = _consents.keys.toList();

    return Scaffold(
      appBar: const PageAppBar(title: 'Privacidade e dados', showNotifications: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          const NoticeBox(
            icon: Icons.shield_outlined,
            tone: NoticeTone.success,
            title: 'Tratamento de dados segundo o RGPD',
            message: 'Guardamos apenas o necessário: nome, e-mail, morada de envio e '
                'fotografias das peças. A identidade do doador nunca é mostrada no catálogo.',
          ),
          const SizedBox(height: 20),
          const Text('Consentimentos', style: AppText.section),
          const SizedBox(height: 8),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < keys.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  SwitchListTile(
                    value: _consents[keys[i]]!,
                    activeColor: AppColors.green,
                    title: Text(keys[i], style: AppText.body),
                    onChanged: (v) => setState(() => _consents[keys[i]] = v),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Os seus direitos', style: AppText.section),
          const SizedBox(height: 12),
          AppButton.secondary(
            label: 'Descarregar os meus dados',
            icon: Icons.download_outlined,
            onPressed: () => showSimulated(context, 'Exportação de dados'),
          ),
          const SizedBox(height: 10),
          AppButton.secondary(
            label: 'Corrigir dados pessoais',
            icon: Icons.edit_outlined,
            onPressed: () => showSimulated(context, 'Correção de dados'),
          ),
          const SizedBox(height: 10),
          AppButton.text(
            label: 'Pedir eliminação da conta',
            expanded: true,
            onPressed: () => showSimulated(context, 'Pedido de eliminação'),
          ),
        ],
      ),
    );
  }
}
