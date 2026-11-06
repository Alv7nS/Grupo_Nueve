import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/product.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/feedback.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/form_fields.dart';
import '../../widgets/page_app_bar.dart';
import '../../widgets/product_card.dart';
import '../../widgets/segmented_tabs.dart';

/// Separador «Catálogo»: pesquisa, filtros e grelha de peças.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  static const _genders = ['Todos', 'Feminino', 'Masculino'];

  String _query = '';
  int _gender = 0;
  bool _showFilters = false;
  String _size = MockData.sizes.first;
  String _category = MockData.productCategories.first;
  String _price = MockData.priceRanges.first;

  bool _matchesPrice(Product p) {
    switch (_price) {
      case 'Até 40 €':
        return p.price <= 40;
      case '40 € — 60 €':
        return p.price > 40 && p.price <= 60;
      case 'Mais de 60 €':
        return p.price > 60;
      default:
        return true;
    }
  }

  List<Product> get _results {
    final q = _query.toLowerCase();
    return MockData.products.where((p) {
      final text = '${p.name} ${p.fabric} ${p.category}'.toLowerCase();
      return (q.isEmpty || text.contains(q)) &&
          (_gender == 0 || p.gender == _genders[_gender]) &&
          (_size == 'Todos' || p.size == _size) &&
          (_category == 'Todas' || p.category == _category) &&
          _matchesPrice(p);
    }).toList();
  }

  void _clearFilters() {
    setState(() {
      _size = MockData.sizes.first;
      _category = MockData.productCategories.first;
      _price = MockData.priceRanges.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      appBar: PageAppBar(
        title: 'Catálogo',
        extraActions: [
          ValueListenableBuilder<int>(
            valueListenable: MockData.changes,
            builder: (context, _, __) => IconButton(
              tooltip: 'Carrinho',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
              icon: Badge(
                isLabelVisible: MockData.cart.isNotEmpty,
                label: Text('${MockData.cart.length}'),
                backgroundColor: AppColors.terracotta,
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const Text(
            'Peças únicas, uma nova história. Produtos e preços ilustrativos.',
            style: AppText.bodyMuted,
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Pesquisar peças',
            hint: 'Nome, tecido ou categoria',
            suffixIcon: Icons.search,
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: 14),
          SegmentedTabs(
            options: _genders,
            selectedIndex: _gender,
            onChanged: (i) => setState(() => _gender = i),
          ),
          const SizedBox(height: 14),
          AppCard(
            padding: const EdgeInsets.fromLTRB(16, 6, 8, 6),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: Text('Filtros', style: AppText.cardTitle)),
                    IconButton(
                      tooltip: _showFilters ? 'Esconder filtros' : 'Mostrar filtros',
                      icon: Icon(_showFilters ? Icons.expand_less : Icons.tune),
                      onPressed: () => setState(() => _showFilters = !_showFilters),
                    ),
                  ],
                ),
                if (_showFilters)
                  Padding(
                    padding: const EdgeInsets.only(right: 8, bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: AppDropdown(
                                label: 'Tamanho',
                                value: _size,
                                items: MockData.sizes,
                                onChanged: (v) => setState(() => _size = v),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AppDropdown(
                                label: 'Categoria',
                                value: _category,
                                items: MockData.productCategories,
                                onChanged: (v) => setState(() => _category = v),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        AppDropdown(
                          label: 'Intervalo de preço',
                          value: _price,
                          items: MockData.priceRanges,
                          onChanged: (v) => setState(() => _price = v),
                        ),
                        const SizedBox(height: 12),
                        AppButton.secondary(
                          label: 'Limpar filtros',
                          onPressed: _clearFilters,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: Text('${results.length} peças · Exemplo', style: AppText.small)),
              InkWell(
                onTap: () => showSimulated(context, 'Ordenação'),
                child: const Row(
                  children: [
                    Text('Mais recentes', style: AppText.small),
                    Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textMuted),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (results.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text('Nenhuma peça corresponde aos filtros.', style: AppText.bodyMuted),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemBuilder: (context, i) {
                final p = results[i];
                return ProductCard(
                  product: p,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.productDetail,
                    arguments: p,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
