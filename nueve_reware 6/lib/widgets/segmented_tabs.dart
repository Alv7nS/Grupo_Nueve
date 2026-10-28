import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Seletor segmentado (ex.: Todas / Em curso / Concluídas).
class SegmentedTabs extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const SegmentedTabs({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: _Segment(
              label: options[i],
              selected: i == selectedIndex,
              onTap: () => onChanged(i),
            ),
          ),
        ],
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Segment({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.green : AppColors.muted,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 44,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? Colors.white : AppColors.text,
            ),
          ),
        ),
      ),
    );
  }
}

/// Separadores com sublinhado (usado no ecrã de autenticação).
class UnderlineTabs extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const UnderlineTabs({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < options.length; i++)
          Expanded(
            child: InkWell(
              onTap: () => onChanged(i),
              child: Container(
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: i == selectedIndex ? AppColors.surface : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: i == selectedIndex ? AppColors.green : AppColors.border,
                      width: i == selectedIndex ? 2 : 1,
                    ),
                  ),
                ),
                child: Text(
                  options[i],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: i == selectedIndex ? FontWeight.w600 : FontWeight.w400,
                    color: i == selectedIndex ? AppColors.text : AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
