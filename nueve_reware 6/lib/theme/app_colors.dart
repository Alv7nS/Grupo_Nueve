import 'package:flutter/material.dart';

/// Paleta definida no Mobile App Style Guide do grupo G03.
class AppColors {
  AppColors._();

  // Cores principais
  static const Color green = Color(0xFF1F4D3A); // Verde floresta — ações principais
  static const Color greenDark = Color(0xFF173A2C);
  static const Color greenLight = Color(0xFFE2ECE5);
  static const Color terracotta = Color(0xFFA8441F); // Terracota — destaques e preços
  static const Color terracottaLight = Color(0xFFF6E3D9);
  static const Color cream = Color(0xFFF6F3EC); // Creme — fundo da aplicação

  // Neutros
  static const Color surface = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFFEDE9E0);
  static const Color border = Color(0xFFDCD6C9);
  static const Color text = Color(0xFF1E2421);
  static const Color textMuted = Color(0xFF66706A);

  // Estados
  static const Color warning = Color(0xFFB7791F);
  static const Color warningLight = Color(0xFFFBF0DC);
  static const Color error = Color(0xFFB3261E);
  static const Color errorLight = Color(0xFFF9E1DF);
}
