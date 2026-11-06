import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/misc_models.dart';
import '../theme/app_text.dart';
import '../utils/feedback.dart';
import 'app_button.dart';
import 'form_fields.dart';
import 'notice_box.dart';

/// Formulário reutilizável: 1.º o utilizador escreve a morada,
/// 2.º calcula os portes (frete) a partir do código postal.
/// Usado no carrinho (entrega ao domicílio) e na doação (envio por correio).
class AddressShippingForm extends StatefulWidget {
  final String title;
  final String subtitle;
  final String resultPrefix; // ex.: «Entregar em» / «Recolher em»
  final ValueChanged<ShippingResult?> onChanged;

  const AddressShippingForm({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onChanged,
    this.resultPrefix = 'Morada',
  });

  @override
  State<AddressShippingForm> createState() => _AddressShippingFormState();
}

class _AddressShippingFormState extends State<AddressShippingForm> {
  final _address = TextEditingController();
  final _postalCode = TextEditingController();
  final _city = TextEditingController();
  ShippingResult? _result;

  @override
  void dispose() {
    _address.dispose();
    _postalCode.dispose();
    _city.dispose();
    super.dispose();
  }

  String _eur(double v) => '${v.toStringAsFixed(2).replaceAll('.', ',')} €';

  /// Qualquer alteração à morada obriga a recalcular os portes.
  void _invalidate(String _) {
    if (_result != null) {
      setState(() => _result = null);
      widget.onChanged(null);
    }
  }

  void _calculate() {
    FocusScope.of(context).unfocus();
    if (_address.text.trim().isEmpty || _city.text.trim().isEmpty) {
      showInfo(context, 'Preencha a morada e a localidade.');
      return;
    }
    final quote = MockData.shippingFor(_postalCode.text);
    if (quote == null) {
      showInfo(context, 'Código postal inválido. Use o formato 0000-000.');
      return;
    }
    final result = ShippingResult(
      address: _address.text.trim(),
      postalCode: _postalCode.text.trim(),
      city: _city.text.trim(),
      quote: quote,
    );
    setState(() => _result = result);
    widget.onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final r = _result;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: AppText.label),
        const SizedBox(height: 4),
        Text(widget.subtitle, style: AppText.small),
        const SizedBox(height: 10),
        AppTextField(
          label: 'Rua, número e andar',
          hint: 'Ex.: Rua das Flores, 12, 3.º Esq.',
          controller: _address,
          onChanged: _invalidate,
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 130,
              child: AppTextField(
                label: 'Código postal',
                hint: '0000-000',
                controller: _postalCode,
                keyboardType: TextInputType.datetime,
                onChanged: _invalidate,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AppTextField(
                label: 'Localidade',
                hint: 'Ex.: Lisboa',
                controller: _city,
                onChanged: _invalidate,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AppButton.secondary(
          label: r == null ? 'Calcular portes' : 'Recalcular portes',
          icon: Icons.local_shipping_outlined,
          onPressed: _calculate,
        ),
        if (r != null) ...[
          const SizedBox(height: 10),
          NoticeBox(
            tone: NoticeTone.success,
            icon: Icons.local_shipping_outlined,
            title: 'Portes: ${_eur(r.quote.price)}',
            message: '${r.quote.zone} · ${r.quote.eta}.\n'
                '${widget.resultPrefix}: ${r.fullAddress}.',
          ),
        ],
        const SizedBox(height: 4),
        const Text(
          'Tabela ilustrativa: Lisboa 2,90 € · Continente 4,90 € · Ilhas 7,90 €.',
          style: AppText.small,
        ),
      ],
    );
  }
}
