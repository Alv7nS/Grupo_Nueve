import 'api_client.dart';
import 'catalog_service.dart';
import 'donation_service.dart';

/// Carrega do servidor os dados principais ao entrar na app.
/// Devolve null se correu bem, ou uma mensagem de erro (a app continua
/// a funcionar com os dados de exemplo).
class DataSync {
  DataSync._();

  static Future<String?> refreshAll() async {
    final errors = <String>[];

    Future<void> attempt(Future<void> Function() task) async {
      try {
        await task();
      } on ApiException catch (e) {
        if (!errors.contains(e.message)) errors.add(e.message);
      }
    }

    await attempt(CatalogService.fetchProducts);
    await attempt(CatalogService.fetchCollectionPoints);
    await attempt(DonationService.fetchMine);

    return errors.isEmpty ? null : errors.first;
  }

  static Future<String?> refreshDonations() async {
    try {
      await DonationService.fetchMine();
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }

  static Future<String?> refreshProducts() async {
    try {
      await CatalogService.fetchProducts();
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }
}
