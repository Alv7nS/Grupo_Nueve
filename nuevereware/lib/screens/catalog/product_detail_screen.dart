import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/misc_models.dart';
import '../../models/product.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/feedback.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/garment_placeholder.dart';
import '../../widgets/info_row.dart';
import '../../widgets/page_app_bar.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/timeline_step.dart';

/// Detalhe de uma peça: informação, compra e história do tecido.
class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  void _addToCart(BuildContext context) {
    if (MockData.cart.any((p) => p.id == product.id)) {
      showInfo(context, 'Esta peça única já está no seu carrinho.');
      return;
    }
    MockData.cart.add(product);
    MockData.notifyChanged();
    final navigator = Navigator.of(context);
    showInfo(
      context,
      '«${product.name}» adicionada ao carrinho.',
      action: SnackBarAction(
        label: 'Ver carrinho',
        textColor: AppColors.terracottaLight,
        onPressed: () => navigator.pushNamed(AppRoutes.cart),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = [
      for (final step in product.history) TimelineItem(step, '', TimelineState.done),
    ];

    return Scaffold(
      appBar: const PageAppBar(title: 'Detalhe da peça'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          GarmentPlaceholder(
            icon: product.icon,
            image: product.image,
            caption: 'Imagem ilustrativa · Peça única',
            height: 320,
          ),
          const SizedBox(height: 14),
          const Align(
            alignment: Alignment.centerLeft,
            child: StatusBadge(
              label: 'Peça única · Disponível',
              background: AppColors.greenLight,
              foreground: AppColors.green,
            ),
          ),
          const SizedBox(height: 10),
          Text(product.name, style: AppText.title),
          const SizedBox(height: 6),
          Text(product.priceLabel, style: AppText.price.copyWith(fontSize: 26)),
          const SizedBox(height: 4),
          Text('Produto e preço de exemplo · Ref. ${product.id}', style: AppText.small),
          const SizedBox(height: 14),
          Text(product.description, style: AppText.body),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              children: [
                InfoRow(label: 'Vestuário', value: '${product.gender} · ${product.category}'),
                InfoRow(label: 'Tamanho', value: '${product.size} · Consultar medidas'),
                InfoRow(label: 'Composição', value: product.composition),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<int>(
            valueListenable: MockData.changes,
            builder: (context, _, __) {
              final inCart = MockData.cart.any((p) => p.id == product.id);
              return AppButton(
                label: inCart ? 'Já está no carrinho' : 'Comprar esta peça',
                icon: inCart ? Icons.check : Icons.shopping_bag_outlined,
                variant: AppButtonVariant.accent,
                onPressed: inCart
                    ? () => Navigator.pushNamed(context, AppRoutes.cart)
                    : () => _addToCart(context),
              );
            },
          ),
          const SizedBox(height: 8),
          const Text(
            'Entrega, pagamento e eventuais descontos são apresentados antes de '
            'confirmar a compra.',
            style: AppText.small,
          ),
          const SizedBox(height: 22),
          const Text('De onde vem este tecido?', style: AppText.section),
          const SizedBox(height: 12),
          AppCard.muted(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('História do tecido · Lote ${product.lot}', style: AppText.cardTitle),
                const SizedBox(height: 4),
                const Text(
                  'Percurso ilustrativo. A identidade do doador não é divulgada.',
                  style: AppText.small,
                ),
                const SizedBox(height: 14),
                TimelineList(items: history),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text('Cuidados de lavagem e conservação', style: AppText.cardTitle),
              childrenPadding: EdgeInsets.only(bottom: 12),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• Lavar a 30 °C, do avesso.\n'
                  '• Não usar máquina de secar.\n'
                  '• Engomar a temperatura média.\n'
                  '• Reparações gratuitas no primeiro ano (exemplo).',
                  style: AppText.body,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
