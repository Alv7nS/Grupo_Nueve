import 'package:flutter/material.dart';

import '../../services/api_config.dart';
import '../../services/data_sync.dart';
import '../../theme/app_colors.dart';
import '../../utils/feedback.dart';
import '../catalog/catalog_screen.dart';
import '../donations/my_donations_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';

/// Estrutura principal do utilizador com navegação inferior (4 separadores).
class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  /// Permite a ecrãs filhos mudar de separador (ex.: «Explorar o catálogo»).
  static void selectTab(BuildContext context, int index) {
    context.findAncestorStateOfType<_MainShellState>()?.select(index);
  }

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index = widget.initialIndex;

  bool _syncing = false;

  void select(int index) => setState(() => _index = index);

  @override
  void initState() {
    super.initState();
    // Carrega os dados do servidor depois do primeiro frame.
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  Future<void> _sync() async {
    if (ApiConfig.offlineMode) return;
    setState(() => _syncing = true);
    final error = await DataSync.refreshAll();
    if (!mounted) return;
    setState(() => _syncing = false);
    if (error != null) {
      showInfo(context, '$error A mostrar dados de exemplo.');
    }
  }

  static const _pages = <Widget>[
    HomeScreen(),
    MyDonationsScreen(),
    CatalogScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (_syncing) const LinearProgressIndicator(minHeight: 2),
          Expanded(child: IndexedStack(index: _index, children: _pages)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: select,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.greenLight,
        surfaceTintColor: Colors.transparent,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.green),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2, color: AppColors.green),
            label: 'Doações',
          ),
          NavigationDestination(
            icon: Icon(Icons.checkroom_outlined),
            selectedIcon: Icon(Icons.checkroom, color: AppColors.green),
            label: 'Catálogo',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.green),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
