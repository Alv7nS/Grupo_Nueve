import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/donation.dart';
import '../../models/misc_models.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../utils/feedback.dart';
import '../../widgets/app_button.dart';
import '../../widgets/form_fields.dart';
import '../../widgets/garment_placeholder.dart';
import '../../widgets/misc_widgets.dart';
import '../../widgets/page_app_bar.dart';
import '../../widgets/photo_strip.dart';
import '../../widgets/status_badge.dart';

/// Passo 1 do fluxo de doação: fotografias e descrição da peça.
///
/// A câmara é SIMULADA: o botão abre uma «galeria» com fotografias de
/// exemplo de roupa danificada. A primeira fotografia escolhida pré-preenche
/// o formulário, como faria no futuro o reconhecimento de imagem.
class NewDonationScreen extends StatefulWidget {
  const NewDonationScreen({super.key});

  @override
  State<NewDonationScreen> createState() => _NewDonationScreenState();
}

class _NewDonationScreenState extends State<NewDonationScreen> {
  static const int _maxPhotos = 4;

  final List<SamplePhoto> _photos = [];
  bool _prefilled = false;

  String _category = MockData.categories.first;
  String _condition = MockData.conditions[2];
  String _fabric = MockData.fabrics.first;
  final _composition = TextEditingController();
  final _notes = TextEditingController();

  @override
  void dispose() {
    _composition.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _addPhoto(SamplePhoto photo) {
    if (_photos.length >= _maxPhotos) {
      showInfo(context, 'Máximo de $_maxPhotos fotografias por peça.');
      return;
    }
    if (_photos.any((p) => p.asset == photo.asset)) {
      showInfo(context, 'Essa fotografia já foi adicionada.');
      return;
    }
    setState(() {
      _photos.add(photo);
      // Pré-preenchimento a partir da primeira fotografia «principal».
      if (!_prefilled && photo.category != null) {
        _prefilled = true;
        _category = photo.category!;
        _condition = photo.condition ?? _condition;
        _fabric = photo.fabric ?? _fabric;
        _composition.text = photo.composition ?? '';
        _notes.text = photo.notes ?? '';
      } else if (_composition.text.isEmpty && photo.composition != null) {
        _composition.text = photo.composition!;
      }
    });
  }

  Future<void> _openCamera() async {
    final picked = await showModalBottomSheet<SamplePhoto>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.cream,
      builder: (ctx) => const _SampleGallerySheet(),
    );
    if (picked != null && mounted) {
      _addPhoto(picked);
      showInfo(context, 'Fotografia «${picked.label}» adicionada (câmara simulada).');
    }
  }

  void _continue() {
    if (_photos.isEmpty) {
      showInfo(context, 'Adicione pelo menos uma fotografia da peça.');
      return;
    }
    final draft = Donation(
      id: MockData.nextDonationId(),
      garment: '$_category de ${_fabric.toLowerCase()}',
      category: _category,
      condition: _condition,
      fabric: _fabric,
      composition: _composition.text.trim().isEmpty ? 'Não indicada' : _composition.text.trim(),
      notes: _notes.text.trim().isEmpty ? 'Sem observações.' : _notes.text.trim(),
      submittedAt: 'Hoje',
      donorName: MockData.currentUser.name,
      donorEmail: MockData.currentUser.email,
      status: DonationStatus.inReview,
      statusMessage: 'A equipa está a analisar as fotografias.',
      photos: _photos.map((p) => p.asset).toList(),
    );
    Navigator.pushNamed(context, AppRoutes.reviewDonation, arguments: draft);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PageAppBar(title: 'Nova doação'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          const FlowStepLabel('Doação · 1 / 6 · Preparar'),
          const Text(
            'Mostre a peça e descreva o tecido. A avaliação é feita pela nossa equipa.',
            style: AppText.bodyMuted,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(child: Text('Fotografias da peça', style: AppText.section)),
              StatusBadge(label: '${_photos.length} / $_maxPhotos adicionadas'),
            ],
          ),
          const SizedBox(height: 12),
          if (_photos.isEmpty)
            InkWell(
              onTap: _openCamera,
              borderRadius: BorderRadius.circular(12),
              child: const GarmentPlaceholder(
                icon: Icons.add_a_photo_outlined,
                caption: 'Ainda sem fotografias.\nToque para tirar a primeira.',
                height: 150,
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _photos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, i) => GestureDetector(
                onTap: () => PhotoStrip.openViewer(context, _photos[i].asset),
                child: GarmentPlaceholder(
                  image: _photos[i].asset,
                  caption: _photos[i].label,
                  height: double.infinity,
                  onRemove: () => setState(() => _photos.removeAt(i)),
                ),
              ),
            ),
          const SizedBox(height: 12),
          AppButton.secondary(
            label: 'Tirar ou adicionar fotografias',
            icon: Icons.photo_camera_outlined,
            onPressed: _openCamera,
          ),
          const SizedBox(height: 8),
          const Text(
            'Inclua frente, verso, etiqueta e eventuais danos (rasgos, manchas, '
            'desgaste). Evite pessoas ou dados pessoais nas imagens.',
            style: AppText.small,
          ),
          const SizedBox(height: 20),
          AppDropdown(
            label: 'Peça / categoria *',
            value: _category,
            items: MockData.categories,
            onChanged: (v) => setState(() => _category = v),
          ),
          const SizedBox(height: 16),
          AppDropdown(
            label: 'Estado da peça *',
            value: _condition,
            items: MockData.conditions,
            onChanged: (v) => setState(() => _condition = v),
          ),
          const SizedBox(height: 16),
          AppDropdown(
            label: 'Tipo de tecido *',
            value: _fabric,
            items: MockData.fabrics,
            onChanged: (v) => setState(() => _fabric = v),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Composição indicada na etiqueta',
            hint: 'Ex.: 100% algodão',
            controller: _composition,
          ),
          const SizedBox(height: 6),
          const Text('Não sabe a composição? Selecione «Não sei» no tipo de tecido.',
              style: AppText.small),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Danos e observações',
            hint: 'Descreva rasgos, manchas ou desgaste',
            controller: _notes,
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          const Text(
            '* Campos obrigatórios. As fotografias são exemplos ilustrativos de uma '
            'submissão.',
            style: AppText.small,
          ),
          const SizedBox(height: 20),
          AppButton(
            label: 'Continuar para revisão',
            icon: Icons.arrow_forward,
            onPressed: _continue,
          ),
          const SizedBox(height: 8),
          Center(
            child: AppButton.text(
              label: 'Guardar rascunho',
              onPressed: () => showSimulated(context, 'Guardar rascunho'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Folha inferior que simula a câmara/galeria do telemóvel.
class _SampleGallerySheet extends StatelessWidget {
  const _SampleGallerySheet();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.75;
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Câmara (simulada)', style: AppText.section),
            const SizedBox(height: 4),
            const Text(
              'Escolha uma fotografia de exemplo para simular a captura. '
              'Na versão final abre a câmara do dispositivo.',
              style: AppText.small,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: MockData.samplePhotos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, i) {
                  final photo = MockData.samplePhotos[i];
                  return InkWell(
                    onTap: () => Navigator.pop(context, photo),
                    borderRadius: BorderRadius.circular(12),
                    child: GarmentPlaceholder(
                      image: photo.asset,
                      caption: photo.label,
                      height: double.infinity,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
