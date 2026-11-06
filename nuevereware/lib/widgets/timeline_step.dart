import 'package:flutter/material.dart';

import '../models/misc_models.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Um passo numa linha temporal (estado do pedido, percurso do tecido...).
class TimelineStep extends StatelessWidget {
  final TimelineItem item;
  final bool isLast;

  const TimelineStep({super.key, required this.item, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    late Color circleColor;
    late Color borderColor;
    late Widget inner;

    switch (item.state) {
      case TimelineState.done:
        circleColor = AppColors.greenLight;
        borderColor = AppColors.green;
        inner = const Icon(Icons.check, size: 14, color: AppColors.green);
        break;
      case TimelineState.current:
        circleColor = AppColors.green;
        borderColor = AppColors.green;
        inner = Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        );
        break;
      case TimelineState.pending:
        circleColor = AppColors.surface;
        borderColor = AppColors.border;
        inner = const Icon(Icons.remove, size: 14, color: AppColors.textMuted);
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor),
                ),
                child: inner,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    color: AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 3, bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppText.cardTitle.copyWith(
                      fontSize: 15,
                      color: item.state == TimelineState.pending
                          ? AppColors.textMuted
                          : AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(item.subtitle, style: AppText.small),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lista de passos construída dinamicamente a partir de uma coleção.
class TimelineList extends StatelessWidget {
  final List<TimelineItem> items;

  const TimelineList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < items.length; i++)
          TimelineStep(item: items[i], isLast: i == items.length - 1),
      ],
    );
  }
}
