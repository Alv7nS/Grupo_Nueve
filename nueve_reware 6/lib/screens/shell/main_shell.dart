import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
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

  void select(int index) => setState(() => _index = index);

  static const _pages = <Widget>[
    HomeScreen(),
    MyDonationsScreen(),
    CatalogScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
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
