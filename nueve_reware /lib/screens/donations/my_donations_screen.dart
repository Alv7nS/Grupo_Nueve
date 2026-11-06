import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/donation.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/donation_card.dart';
import '../../widgets/page_app_bar.dart';
import '../../widgets/segmented_tabs.dart';

/// Separador «Doações»: lista de pedidos com filtro por estado.
class MyDonationsScreen extends StatefulWidget {
  const MyDonationsScreen({super.key});

  /// Abre o ecrã adequado ao estado do pedido.
  static void openDonation(BuildContext context, Donation d) {
    final route = switch (d.status) {
      DonationStatus.inReview => AppRoutes.donationTracking,
      DonationStatus.rejected => AppRoutes.donationTracking,
      DonationStatus.approved => AppRoutes.donationApproved,
      DonationStatus.delivered => AppRoutes.deliveryConfirmed,
    };
    Navigator.pushNamed(context, route, arguments: d);
  }

  @override
  State<MyDonationsScreen> createState() => _MyDonationsScreenState();
}

class _MyDonationsScreenState extends State<MyDonationsScreen> {
  int _filter = 0; // 0 todas, 1 em curso, 2 concluídas

  List<Donation> get _filtered {
    final all = MockData.myDonations;
    switch (_filter) {
      case 1:
        return all.where((d) => d.status.isOngoing).toList();
      case 2:
        return all.where((d) => !d.status.isOngoing).toList();
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageAppBar(title: 'Minhas doações'),
      body: ValueListenableBuilder<int>(
        valueListenable: MockData.changes,
        builder: (context, _, __) {
          final items = _filtered;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppButton(
                      label: 'Nova doação',
                      icon: Icons.add,
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.newDonation),
                    ),
                    const SizedBox(height: 16),
                    SegmentedTabs(
                      options: const ['Todas', 'Em curso', 'Concluídas'],
                      selectedIndex: _filter,
                      onChanged: (i) => setState(() => _filter = i),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '${items.length} pedidos · Mais recentes primeiro',
                      style: AppText.small,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            MockData.myDonations.isEmpty
                                ? 'Ainda não fez nenhuma doação.\nToque em «Nova doação» para começar.'
                                : 'Sem pedidos neste filtro.',
                            style: AppText.bodyMuted,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        itemCount: items.length + 1,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          if (i == items.length) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                'Os estados são atualizados pela equipa. Ative as '
                                'notificações no seu perfil para receber novidades.',
                                style: AppText.small,
                              ),
                            );
                          }
                          final d = items[i];
                          return DonationCard(
                            donation: d,
                            onTap: () => MyDonationsScreen.openDonation(context, d),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
