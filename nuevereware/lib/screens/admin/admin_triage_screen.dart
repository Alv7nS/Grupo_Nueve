import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_text.dart';
import '../../widgets/donation_card.dart';
import '../../widgets/status_badge.dart';

/// Lista de pedidos pendentes de avaliação (estado Pendente_Avaliacao).
class AdminTriageScreen extends StatelessWidget {
  const AdminTriageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: MockData.changes,
      builder: (context, _, __) {
        final pending = MockData.pendingReview;
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          itemCount: pending.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            if (i == 0) {
              return Row(
                children: [
                  const Expanded(child: Text('Pedidos para avaliar', style: AppText.section)),
                  StatusBadge(label: '${pending.length} pendentes'),
                ],
              );
            }
            final d = pending[i - 1];
            return DonationCard(
              donation: d,
              showDonor: true,
              onTap: () => Navigator.pushNamed(context, AppRoutes.adminReview, arguments: d),
            );
          },
        );
      },
    );
  }
}
