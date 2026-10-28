import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/donation.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/donation_card.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/notice_box.dart';
import '../../widgets/page_app_bar.dart';
import '../../widgets/product_card.dart';
import '../../widgets/section_header.dart';
import '../donations/my_donations_screen.dart';
import '../shell/main_shell.dart';

/// Separador «Início»: atalhos para doar/comprar, última doação e novidades.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(title: 'Olá, ${MockData.currentUser.firstName}!'),
      body: ValueListenableBuilder<int>(
        valueListenable: MockData.changes,
        builder: (context, _, __) {
          final user = MockData.currentUser;
          final mine = MockData.myDonations;
          final Donation? last = mine.isEmpty ? null : mine.first;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            children: [
              const Text(
                'O que quer doar hoje? Dê uma nova utilidade à roupa que já não usa.',
                style: AppText.bodyMuted,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatTile(
                      value: '${user.points}',
                      label: 'pontos',
                      icon: Icons.stars_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatTile(
                      value: '${mine.length}',
                      label: 'doações',
                      icon: Icons.inventory_2_outlined,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatTile(
                      value: '${user.kgRecovered.toString().replaceAll('.', ',')} kg',
                      label: 'tecido salvo',
                      icon: Icons.eco_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _ActionCard(
                icon: Icons.volunteer_activism_outlined,
                title: 'Doar roupa',
                description: 'Envie fotografias e detalhes. A nossa equipa avalia o '
                    'potencial do tecido.',
                button: AppButton(
                  label: 'Começar uma doação',
                  icon: Icons.arrow_forward,
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.newDonation),
                ),
              ),
              const SizedBox(height: 12),
              _ActionCard(
                icon: Icons.checkroom_outlined,
                title: 'Comprar peças únicas',
                description:
                    'Vestuário feminino e masculino feito com tecidos recuperados.',
                button: AppButton.secondary(
                  label: 'Explorar o catálogo',
                  onPressed: () => MainShell.selectTab(context, 2),
                ),
              ),
              const SizedBox(height: 16),
              SectionHeader(
                title: 'A sua última doação',
                actionLabel: last == null ? null : 'Ver todas',
                onAction: () => MainShell.selectTab(context, 1),
              ),
              if (last != null)
                DonationCard(
                  donation: last,
                  onTap: () => MyDonationsScreen.openDonation(context, last),
                )
              else
                const NoticeBox(
                  icon: Icons.inventory_2_outlined,
                  title: 'Ainda não fez nenhuma doação',
                  message: 'Quando submeter a primeira peça, poderá acompanhar aqui '
                      'a avaliação, a entrega e a nova vida do tecido.',
                ),
              const SizedBox(height: 16),
              SectionHeader(
                title: 'Novidades no catálogo',
                actionLabel: 'Ver catálogo',
                onAction: () => MainShell.selectTab(context, 2),
              ),
              SizedBox(
                height: 230,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: MockData.products.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final p = MockData.products[i];
                    return SizedBox(
                      width: 160,
                      child: ProductCard(
                        product: p,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.productDetail,
                          arguments: p,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const SectionHeader(title: 'Do tecido à nova peça'),
              const _ProcessStrip(),
              const SizedBox(height: 8),
              const Text(
                'Acompanhe as peças criadas com o tecido que doou na área '
                '«Minhas doações».',
                style: AppText.small,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget button;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.green),
              const SizedBox(width: 10),
              Text(title, style: AppText.section),
            ],
          ),
          const SizedBox(height: 8),
          Text(description, style: AppText.bodyMuted),
          const SizedBox(height: 14),
          button,
        ],
      ),
    );
  }
}

/// Faixa com as 4 etapas do serviço: Submeter → Avaliar → Entregar → Transformar.
class _ProcessStrip extends StatelessWidget {
  const _ProcessStrip();

  static const _steps = [
    (Icons.photo_camera_outlined, 'Submeter'),
    (Icons.fact_check_outlined, 'Avaliar'),
    (Icons.qr_code_2, 'Entregar'),
    (Icons.auto_awesome_outlined, 'Transformar'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < _steps.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.terracottaLight,
                  child: Icon(_steps[i].$1, color: AppColors.terracotta),
                ),
                const SizedBox(height: 6),
                Text(_steps[i].$2, style: AppText.small),
              ],
            ),
          ),
          if (i < _steps.length - 1)
            const Padding(
              padding: EdgeInsets.only(bottom: 18),
              child: Icon(Icons.chevron_right, color: AppColors.textMuted, size: 18),
            ),
        ],
      ],
    );
  }
}
