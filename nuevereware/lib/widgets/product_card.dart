import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'garment_placeholder.dart';

/// Cartão de peça para grelhas e listas horizontais do catálogo.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GarmentPlaceholder(
                  icon: product.icon,
                  image: product.image,
                  height: double.infinity,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.name,
                style: AppText.cardTitle.copyWith(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text('${product.gender} · ${product.fabric}', style: AppText.small),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text('${product.size} · ', style: AppText.label),
                  Text(product.priceLabel, style: AppText.price.copyWith(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
