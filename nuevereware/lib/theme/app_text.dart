import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Escala tipográfica usada em toda a aplicação.
class AppText {
  AppText._();

  static const TextStyle brand = TextStyle(
    fontFamily: 'serif',
    fontSize: 26,
    color: AppColors.green,
    letterSpacing: 0.3,
  );
  static const TextStyle display = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    height: 1.2,
  );
  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );
  static const TextStyle section = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.text,
    height: 1.4,
  );
  static const TextStyle bodyMuted = TextStyle(
    fontSize: 14,
    color: AppColors.textMuted,
    height: 1.4,
  );
  static const TextStyle small = TextStyle(
    fontSize: 12,
    color: AppColors.textMuted,
    height: 1.35,
  );
  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
  static const TextStyle overline = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: AppColors.textMuted,
  );
  static const TextStyle price = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.terracotta,
  );
  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.green,
    decoration: TextDecoration.underline,
  );
}
