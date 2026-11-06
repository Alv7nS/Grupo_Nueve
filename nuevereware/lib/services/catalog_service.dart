import '../data/mock_data.dart';
import '../models/misc_models.dart';
import '../models/product.dart';
import 'api_client.dart';

/// Catálogo de peças (GET /produtos) e pontos de recolha (GET /pontos-recolha).
class CatalogService {
  CatalogService._();

  static Future<List<Product>> fetchProducts() async {
    final data = await ApiClient.get('/produtos');
    final list = ApiClient.listFrom(data, 'produtos').map(Product.fromJson).toList();
    MockData.replaceProducts(list);
    return list;
  }

  static Future<List<CollectionPoint>> fetchCollectionPoints() async {
    final data = await ApiClient.get('/pontos-recolha');
    final list =
        ApiClient.listFrom(data, 'pontos_recolha').map(CollectionPoint.fromJson).toList();
    MockData.replaceCollectionPoints(list);
    return list;
  }
}
