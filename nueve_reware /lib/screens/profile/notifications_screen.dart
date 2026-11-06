import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/feedback.dart';
import '../../widgets/page_app_bar.dart';
import '../donations/my_donations_screen.dart';

/// Lista de notificações (no futuro recebidas por push).
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = MockData.myNotifications;

    return Scaffold(
      appBar: const PageAppBar(title: 'Notificações', showNotifications: false),
      body: items.isEmpty
          ? const Center(child: Text('Sem notificações.', style: AppText.bodyMuted))
          : ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final n = items[i];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            leading: CircleAvatar(
              backgroundColor: n.unread ? AppColors.terracottaLight : AppColors.muted,
              child: Icon(n.icon, color: n.unread ? AppColors.terracotta : AppColors.textMuted),
            ),
            title: Text(
              n.title,
              style: AppText.cardTitle.copyWith(
                fontSize: 15,
                fontWeight: n.unread ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text('${n.body}\n${n.time}', style: AppText.small),
            ),
            isThreeLine: true,
            trailing: n.unread
                ? const Icon(Icons.circle, size: 10, color: AppColors.terracotta)
                : null,
            onTap: () {
              final id = n.donationId;
              if (id == null) {
                showInfo(context, n.body);
                return;
              }
              final matches = MockData.donations.where((d) => d.id == id);
              if (matches.isNotEmpty) {
                MyDonationsScreen.openDonation(context, matches.first);
              }
            },
          );
        },
      ),
    );
  }
}
