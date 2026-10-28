import 'package:flutter/material.dart';

/// Peça nova criada a partir de tecidos recuperados (catálogo da loja).
class Product {
  final String id;
  final String name;
  final String gender; // Feminino | Masculino
  final String category; // Camisas | Calças | Casacos | Coletes
  final String fabric;
  final String size;
  final double price;
  final String description;
  final String composition;
  final String lot; // lote de tecido de origem
  final List<String> history; // percurso do tecido
  final String image; // imagem ilustrativa (assets/images/products)
  final IconData icon;

  const Product({
    required this.id,
    required this.name,
    required this.gender,
    required this.category,
    required this.fabric,
    required this.size,
    required this.price,
    required this.description,
    required this.composition,
    required this.lot,
    required this.history,
    required this.image,
    this.icon = Icons.checkroom_outlined,
  });

  String get priceLabel => '${price.toStringAsFixed(2).replaceAll('.', ',')} €';
}
