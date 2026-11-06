import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Pequeno indicador numérico (pontos, doações, kg recuperados).
class StatTile extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const StatTile({super.key, required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.terracotta, size: 22),
          const SizedBox(height: 6),
          Text(value, style: AppText.section),
          const SizedBox(height: 2),
          Text(label, style: AppText.small, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

/// Cartão selecionável (ex.: escolha de ponto de recolha).
class SelectableCard extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  const SelectableCard({
    super.key,
    required this.selected,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.greenLight : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: selected ? AppColors.green : AppColors.border,
          width: selected ? 1.6 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: selected ? AppColors.green : AppColors.textMuted,
              ),
              const SizedBox(width: 12),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

/// Linha de menu do perfil.
class MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const MenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.greenLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.green, size: 22),
      ),
      title: Text(title, style: AppText.cardTitle.copyWith(fontSize: 15)),
      subtitle: subtitle == null ? null : Text(subtitle!, style: AppText.small),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.textMuted),
    );
  }
}

/// Cabeçalho de passo de um fluxo (ex.: «DOAÇÃO · 2 / 5 · SUBMETER»).
class FlowStepLabel extends StatelessWidget {
  final String text;

  const FlowStepLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text.toUpperCase(), style: AppText.overline),
    );
  }
}

/// Lista de verificação simples (ícone + título + descrição).
class ChecklistItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool done;

  const ChecklistItem({
    super.key,
    required this.title,
    required this.subtitle,
    this.done = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done ? AppColors.green : AppColors.textMuted,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.cardTitle.copyWith(fontSize: 15)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppText.small),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
