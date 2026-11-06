import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/app_user.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/feedback.dart';
import '../../widgets/app_card.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/page_app_bar.dart';

/// Separador «Perfil»: dados do utilizador, pontos, definições e sessão.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _pushEnabled = true;

  void _logout() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Terminar sessão?'),
        content: const Text('Terá de iniciar sessão novamente para doar ou comprar.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pushNamedAndRemoveUntil(
              AppRoutes.login,
              (route) => false,
            ),
            child: const Text('Terminar sessão'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageAppBar(title: 'Perfil'),
      body: ValueListenableBuilder<int>(
        valueListenable: MockData.changes,
        builder: (context, _, __) => _buildBody(context, MockData.currentUser),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppUser user) {
    final orders = MockData.myOrdersCount;
    return ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          AppCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.green,
                  child: Text(
                    user.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: AppText.section),
                      Text(user.email, style: AppText.small),
                      const SizedBox(height: 4),
                      Text(user.role, style: AppText.label.copyWith(color: AppColors.terracotta)),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Editar perfil',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => showSimulated(context, 'Edição do perfil'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatTile(value: '${user.points}', label: 'pontos', icon: Icons.stars_outlined),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatTile(
                  value: '${MockData.myDonations.length}',
                  label: 'doações',
                  icon: Icons.inventory_2_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatTile(
                  value: '$orders',
                  label: 'compras',
                  icon: Icons.shopping_bag_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('A minha conta', style: AppText.section),
          const SizedBox(height: 8),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                MenuTile(
                  icon: Icons.stars_outlined,
                  title: 'Pontos e descontos',
                  subtitle: '${user.points} pontos disponíveis',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.points),
                ),
                const Divider(height: 1),
                MenuTile(
                  icon: Icons.receipt_long_outlined,
                  title: 'As minhas encomendas',
                  subtitle: orders == 0
                      ? 'Ainda sem encomendas'
                      : (orders == 1 ? '1 encomenda' : '$orders encomendas'),
                  onTap: () => showSimulated(context, 'Histórico de encomendas'),
                ),
                const Divider(height: 1),
                MenuTile(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Carrinho',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
                ),
                const Divider(height: 1),
                MenuTile(
                  icon: Icons.location_on_outlined,
                  title: 'Moradas',
                  subtitle: 'Lisboa · Exemplo',
                  onTap: () => showSimulated(context, 'Gestão de moradas'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Definições', style: AppText.section),
          const SizedBox(height: 8),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                MenuTile(
                  icon: Icons.notifications_none_outlined,
                  title: 'Notificações',
                  subtitle: 'Estado das doações e novidades',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
                ),
                const Divider(height: 1),
                MenuTile(
                  icon: Icons.campaign_outlined,
                  title: 'Notificações push',
                  trailing: Switch(
                    value: _pushEnabled,
                    activeColor: AppColors.green,
                    onChanged: (v) => setState(() => _pushEnabled = v),
                  ),
                ),
                const Divider(height: 1),
                MenuTile(
                  icon: Icons.shield_outlined,
                  title: 'Privacidade e dados (RGPD)',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.privacy),
                ),
                const Divider(height: 1),
                MenuTile(
                  icon: Icons.help_outline,
                  title: 'Ajuda',
                  onTap: () => showSimulated(context, 'Centro de ajuda'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                MenuTile(
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'Área do gestor (demo)',
                  subtitle: 'Triagem, leitura de QR e tecidos',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.admin),
                ),
                const Divider(height: 1),
                MenuTile(
                  icon: Icons.logout,
                  title: 'Terminar sessão',
                  onTap: _logout,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Center(child: Text('Nuevé ReWare · v0.1 (protótipo)', style: AppText.small)),
        ],
    );
  }
}
