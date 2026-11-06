import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/feedback.dart';
import '../../widgets/app_card.dart';
import '../../widgets/page_app_bar.dart';
import '../../widgets/section_header.dart';

/// Pontos acumulados por doações validadas e recompensas disponíveis (RF05).
class PointsScreen extends StatelessWidget {
  const PointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final points = MockData.currentUser.points;
    const nextGoal = 450;

    return Scaffold(
      appBar: const PageAppBar(title: 'Pontos e descontos'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Saldo disponível',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  '$points pontos',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: points / nextGoal,
                    minHeight: 8,
                    backgroundColor: AppColors.greenDark,
                    color: AppColors.terracottaLight,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Faltam ${nextGoal - points} pontos para 10 € de desconto',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Ganha pontos sempre que uma doação é validada no ponto de recolha. '
            'Regras e valores ilustrativos.',
            style: AppText.small,
          ),
          const SizedBox(height: 12),
          const SectionHeader(title: 'Trocar pontos'),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: MockData.rewards.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final r = MockData.rewards[i];
              final canRedeem = points >= r.cost;
              return AppCard(
                child: Row(
                  children: [
                    const Icon(Icons.local_offer_outlined, color: AppColors.terracotta),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.title, style: AppText.cardTitle),
                          Text('${r.subtitle} · ${r.cost} pts', style: AppText.small),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: canRedeem
                          ? () => showInfo(context, 'Cupão «${r.title}» gerado (simulado).')
                          : null,
                      child: Text(canRedeem ? 'Trocar' : 'Bloqueado'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          const SectionHeader(title: 'Histórico'),
          if (MockData.myPointsHistory.isEmpty)
            const Text(
              'Ainda não tem movimentos. Ganha pontos quando uma doação sua é '
              'validada no ponto de recolha.',
              style: AppText.bodyMuted,
            )
          else
          AppCard(
            padding: EdgeInsets.zero,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: MockData.myPointsHistory.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final e = MockData.myPointsHistory[i];
                final positive = e.amount > 0;
                return ListTile(
                  title: Text(e.description, style: AppText.body),
                  subtitle: Text(e.date, style: AppText.small),
                  trailing: Text(
                    '${positive ? '+' : ''}${e.amount}',
                    style: AppText.cardTitle.copyWith(
                      color: positive ? AppColors.green : AppColors.terracotta,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
