import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Mostra uma imagem local (assets/...) ou remota (http...), com alternativa
/// se a imagem não existir. Assim a API pode devolver qualquer um dos dois.
Widget appImage(String src, {BoxFit fit = BoxFit.cover, Widget? fallback}) {
  final Widget error = fallback ?? const Icon(Icons.broken_image_outlined);
  if (src.startsWith('http://') || src.startsWith('https://')) {
    return Image.network(src, fit: fit, errorBuilder: (_, __, ___) => error);
  }
  if (src.isEmpty) return error;
  return Image.asset(src, fit: fit, errorBuilder: (_, __, ___) => error);
}

/// Imagem de uma peça. Se [image] (asset) existir, mostra a fotografia
/// ilustrativa; caso contrário mostra um espaço reservado com ícone.
class GarmentPlaceholder extends StatelessWidget {
  final IconData icon;
  final String? image;
  final String? caption;
  final double height;
  final VoidCallback? onRemove;
  final BoxFit fit;

  const GarmentPlaceholder({
    super.key,
    this.icon = Icons.checkroom_outlined,
    this.image,
    this.caption,
    this.height = 120,
    this.onRemove,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final available =
            constraints.maxHeight.isFinite ? constraints.maxHeight : 120.0;
        final iconSize = (available * 0.38).clamp(24.0, 90.0).toDouble();
        return Stack(
          fit: StackFit.expand,
          children: [
            if (image != null)
              appImage(
                image!,
                fit: fit,
                fallback: _iconContent(iconSize),
              )
            else
              _iconContent(iconSize),
            if (image != null && caption != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 14, 8, 6),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x00000000), Color(0x99000000)],
                    ),
                  ),
                  child: Text(
                    caption!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            if (onRemove != null)
              Positioned(
                top: 4,
                right: 4,
                child: Material(
                  color: const Color(0xCCFFFFFF),
                  shape: const CircleBorder(),
                  child: IconButton(
                    tooltip: 'Remover',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: onRemove,
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _iconContent(double iconSize) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: AppColors.textMuted),
          if (caption != null) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                caption!,
                style: AppText.small,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
