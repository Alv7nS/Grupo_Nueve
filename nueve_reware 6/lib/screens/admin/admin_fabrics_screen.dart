import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/misc_models.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/feedback.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/info_row.dart';
import '../../widgets/status_badge.dart';

/// Inventário de lotes de tecido recebidos e o seu estado de transformação.
class AdminFabricsScreen extends StatelessWidget {
  const AdminFabricsScreen({super.key});

  void _openLot(BuildContext context, FabricLot lot) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lote ${lot.id}', style: AppText.title),
              const SizedBox(height: 10),
              InfoRow(label: 'Tecido', value: lot.fabric),
              InfoRow(label: 'Origem', value: lot.origin),
              InfoRow(label: 'Peso', value: '${lot.kg.toString().replaceAll('.', ',')} kg'),
              InfoRow(label: 'Etapa', value: lot.stage),
              const SizedBox(height: 14),
              AppButton(
                label: lot.progress >= 1 ? 'Ver peça no catálogo' : 'Avançar etapa',
                onPressed: () {
                  Navigator.pop(ctx);
                  showSimulated(context, 'Gestão de lotes');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lots = MockData.fabricLots;
    final totalKg = lots.fold<double>(0, (s, l) => s + l.kg);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: [
        Text(
          '${lots.length} lotes · ${totalKg.toStringAsFixed(1).replaceAll('.', ',')} kg de tecido recuperado',
          style: AppText.bodyMuted,
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: lots.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final lot = lots[i];
            final done = lot.progress >= 1;
            return AppCard(
              onTap: () => _openLot(context, lot),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('${lot.id} · ${lot.fabric}', style: AppText.cardTitle),
                      ),
                      StatusBadge(
                        label: lot.stage,
                        background: done ? AppColors.greenLight : AppColors.terracottaLight,
                        foreground: done ? AppColors.green : AppColors.terracotta,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('${lot.origin} · ${lot.kg.toString().replaceAll('.', ',')} kg',
                      style: AppText.small),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: lot.progress,
                      minHeight: 6,
                      backgroundColor: AppColors.muted,
                      color: done ? AppColors.green : AppColors.terracotta,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        AppButton.secondary(
          label: 'Publicar nova peça no catálogo',
          icon: Icons.add_photo_alternate_outlined,
          onPressed: () => showSimulated(context, 'Publicação de produtos'),
        ),
      ],
    );
  }
}
