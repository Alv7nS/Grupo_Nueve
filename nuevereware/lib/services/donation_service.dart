import 'package:flutter/foundation.dart';

import '../data/mock_data.dart';
import '../models/donation.dart';
import 'api_client.dart';
import 'api_config.dart';

/// Pedidos de doação (GET/POST /doacoes, PATCH /doacoes/:id/estado).
class DonationService {
  DonationService._();

  static int _requireUserId() {
    final id = MockData.currentUser.id;
    if (id == null) {
      throw const ApiException('Sessão de demonstração: utilizador sem conta no servidor.');
    }
    return id;
  }

  /// Carrega as doações do utilizador atual e atualiza a cache.
  static Future<List<Donation>> fetchMine() async {
    final userId = _requireUserId();
    final data = await ApiClient.get('/doacoes', query: {'utilizador': '$userId'});
    final user = MockData.currentUser;
    final list = ApiClient.listFrom(data, 'doacoes')
        .map(Donation.fromJson)
        // garante que a doação fica associada a quem tem sessão iniciada
        .map((d) => d.copyWith(
              donorEmail: d.donorEmail.isEmpty ? user.email : d.donorEmail,
              donorName: d.donorName.isEmpty ? user.name : d.donorName,
            ))
        .toList();
    MockData.replaceMyDonations(list);
    return list;
  }

  /// Submete uma nova doação. Devolve-a com o id atribuído pelo servidor.
  static Future<Donation> create(Donation draft) async {
    final userId = _requireUserId();
    final data = await ApiClient.post('/doacoes', draft.toCreateJson(userId));
    final created = Donation.fromJson(ApiClient.objectFrom(data, 'doacao'));
    final result = created.copyWith(
      photos: created.photos.isEmpty ? draft.photos : created.photos,
      donorName: draft.donorName,
      donorEmail: draft.donorEmail,
    );
    MockData.donations.insert(0, result);
    MockData.pendingReview.insert(0, result);
    MockData.notifyChanged();
    return result;
  }

  /// Envia a alteração de estado para o servidor (sem bloquear o ecrã).
  /// Se falhar, a alteração fica apenas local e o erro é registado na consola.
  static Future<void> pushStatus(Donation d) async {
    if (d.dbId == null || ApiConfig.offlineMode) return;
    try {
      await ApiClient.patch('/doacoes/${d.dbId}/estado', {
        'estado': d.status.apiValue,
        'mensagem_estado': d.statusMessage,
      });
    } on ApiException catch (e) {
      debugPrint('Falha ao atualizar estado de ${d.id}: $e');
    }
  }
}
