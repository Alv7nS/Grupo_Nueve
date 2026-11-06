import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import 'admin_fabrics_screen.dart';
import 'admin_scanner_screen.dart';
import 'admin_triage_screen.dart';

/// Área interna do gestor/operador com navegação inferior própria.
class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;

  static const _titles = ['Painel do gestor', 'Ler QR / Entregas', 'Tecidos'];
  static const _pages = <Widget>[
    AdminTriageScreen(),
    AdminScannerScreen(),
    AdminFabricsScreen(),
  ];

  void _exit() {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 72,
        titleSpacing: 20,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('GESTÃO · ÁREA INTERNA', style: AppText.overline),
            Text(_titles[_index], style: AppText.title),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sair da área do gestor',
            icon: const Icon(Icons.logout),
            onPressed: _exit,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.terracottaLight,
        surfaceTintColor: Colors.transparent,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.fact_check_outlined), label: 'Triagem'),
          NavigationDestination(icon: Icon(Icons.qr_code_scanner), label: 'Ler QR'),
          NavigationDestination(icon: Icon(Icons.layers_outlined), label: 'Tecidos'),
        ],
      ),
    );
  }
}
