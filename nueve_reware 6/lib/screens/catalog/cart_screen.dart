import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/misc_models.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/address_shipping_form.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/garment_placeholder.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/page_app_bar.dart';
import '../../widgets/segmented_tabs.dart';

/// Carrinho e checkout simulado (sem pagamento real nesta fase).
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _usePoints = false;
  int _delivery = 0; // 0 = domicílio, 1 = levantar em loja
  int _payment = 0;

  // Morada de entrega escrita pelo utilizador + portes calculados.
  ShippingResult? _shipping;

  bool get _canCheckout => _delivery == 1 || _shipping != null;

  static const _paymentMethods = [
    (Icons.phone_iphone, 'MB WAY'),
    (Icons.credit_card, 'Cartão de crédito / débito'),
    (Icons.receipt_long_outlined, 'Referência Multibanco'),
  ];

  String _eur(double v) => '${v.toStringAsFixed(2).replaceAll('.', ',')} €';

  static const int _pointsCost = 250;

  bool get _hasEnoughPoints => MockData.currentUser.points >= _pointsCost;

  void _checkout() {
    final orderId = MockData.addOrder();
    if (_usePoints && _hasEnoughPoints) {
      MockData.addPoints(
        MockData.currentUser.email,
        -_pointsCost,
        'Desconto usado · Encomenda $orderId',
      );
    }
    MockData.cart.clear();
    MockData.notifyChanged();
    Navigator.pushReplacementNamed(context, AppRoutes.orderConfirmed, arguments: orderId);
  }

  @override
  Widget build(BuildContext context) {
    final items = MockData.cart;
    final subtotal = items.fold<double>(0, (sum, p) => sum + p.price);
    final double shipping =
        items.isEmpty || _delivery == 1 ? 0.0 : (_shipping?.quote.price ?? 0.0);
    final discount = _usePoints && _hasEnoughPoints && items.isNotEmpty ? 5.0 : 0.0;
    final total = subtotal + shipping - discount;

    return Scaffold(
      appBar: const PageAppBar(title: 'Carrinho', showNotifications: false),
      body: items.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.textMuted),
                  const SizedBox(height: 12),
                  const Text('O seu carrinho está vazio', style: AppText.section),
                  const SizedBox(height: 6),
                  const Text(
                    'Explore peças únicas feitas com tecidos recuperados.',
                    style: AppText.bodyMuted,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    label: 'Explorar o catálogo',
                    onPressed: () => AppRoutes.goToTab(context, 2),
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              children: [
                Text('${items.length} peça(s) única(s)', style: AppText.small),
                const SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final p = items[i];
                    return AppCard(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 72,
                            child: GarmentPlaceholder(icon: p.icon, image: p.image, height: 72),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.name, style: AppText.cardTitle),
                                Text('${p.gender} · Tam. ${p.size}', style: AppText.small),
                                const SizedBox(height: 4),
                                Text(p.priceLabel, style: AppText.price),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Remover',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              setState(() => MockData.cart.removeAt(i));
                              MockData.notifyChanged();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text('Entrega', style: AppText.section),
                const SizedBox(height: 10),
                SegmentedTabs(
                  options: const ['Ao domicílio', 'Levantar na loja'],
                  selectedIndex: _delivery,
                  onChanged: (i) => setState(() {
                    _delivery = i;
                    _shipping = null; // nova escolha obriga a novo cálculo
                  }),
                ),
                const SizedBox(height: 14),
                if (_delivery == 0)
                  AddressShippingForm(
                    title: 'Morada de entrega',
                    subtitle: 'Onde quer receber a encomenda?',
                    resultPrefix: 'Entregar em',
                    onChanged: (r) => setState(() => _shipping = r),
                  )
                else
                  _storePickup(),
                const SizedBox(height: 20),
                const Text('Pagamento', style: AppText.section),
                const SizedBox(height: 10),
                for (var i = 0; i < _paymentMethods.length; i++) ...[
                  SelectableCard(
                    selected: _payment == i,
                    onTap: () => setState(() => _payment = i),
                    child: Row(
                      children: [
                        Icon(_paymentMethods[i].$1, size: 20, color: AppColors.textMuted),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_paymentMethods[i].$2, style: AppText.body)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 8),
                AppCard(
                  padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _usePoints && _hasEnoughPoints,
                    activeColor: AppColors.green,
                    onChanged: _hasEnoughPoints ? (v) => setState(() => _usePoints = v) : null,
                    title: const Text('Usar 250 pontos', style: AppText.cardTitle),
                    subtitle: Text(
                      _hasEnoughPoints
                          ? 'Tem ${MockData.currentUser.points} pontos · desconto de 5,00 €'
                          : 'Tem ${MockData.currentUser.points} pontos · precisa de $_pointsCost',
                      style: AppText.small,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AppCard.muted(
                  child: Column(
                    children: [
                      _SummaryRow('Subtotal', _eur(subtotal)),
                      _SummaryRow(
                        'Portes',
                        _delivery == 1
                            ? 'Grátis'
                            : (_shipping == null ? 'Por calcular' : _eur(shipping)),
                      ),
                      if (discount > 0) _SummaryRow('Desconto (pontos)', '− ${_eur(discount)}'),
                      const Divider(height: 20),
                      _SummaryRow('Total', _eur(total), bold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Finalizar compra · ${_eur(total)}',
                  variant: AppButtonVariant.accent,
                  onPressed: _canCheckout ? _checkout : null,
                ),
                if (!_canCheckout) ...[
                  const SizedBox(height: 6),
                  const Text(
                    'Indique a morada de entrega e calcule os portes para finalizar.',
                    style: AppText.small,
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 8),
                const Text(
                  'Pagamento simulado: nenhum valor é cobrado neste protótipo.',
                  style: AppText.small,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
    );
  }

  Widget _storePickup() {
    final store = MockData.collectionPoints.last;
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.storefront_outlined, color: AppColors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(store.name, style: AppText.cardTitle),
                Text('${store.address}, ${store.postalCode}', style: AppText.body),
                Text(store.hours, style: AppText.small),
                const SizedBox(height: 4),
                const Text('Sem portes · pronto em 24 h', style: AppText.label),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = bold ? AppText.section : AppText.body;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}
