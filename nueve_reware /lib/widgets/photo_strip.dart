import 'package:flutter/material.dart';

import '../theme/app_text.dart';
import 'garment_placeholder.dart';

/// Faixa horizontal de fotografias de uma doação. Tocar numa fotografia
/// abre-a ampliada (útil para o gestor avaliar os danos).
class PhotoStrip extends StatelessWidget {
  final List<String> photos;
  final double size;

  const PhotoStrip({super.key, required this.photos, this.size = 120});

  static void openViewer(BuildContext context, String asset) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            InteractiveViewer(
              maxScale: 4,
              child: Image.asset(asset, fit: BoxFit.contain),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton.filledTonal(
                tooltip: 'Fechar',
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(ctx),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return const GarmentPlaceholder(caption: 'Sem fotografias', height: 110);
    }
    return SizedBox(
      height: size,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) => SizedBox(
          width: size,
          child: GestureDetector(
            onTap: () => openViewer(context, photos[i]),
            child: GarmentPlaceholder(
              image: photos[i],
              caption: 'Foto ${i + 1} · ampliar',
              height: size,
            ),
          ),
        ),
      ),
    );
  }
}

/// Texto auxiliar para indicar quantas fotografias existem.
class PhotoCountLabel extends StatelessWidget {
  final int count;

  const PhotoCountLabel(this.count, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      count == 1 ? '1 fotografia' : '$count fotografias',
      style: AppText.small,
    );
  }
}
