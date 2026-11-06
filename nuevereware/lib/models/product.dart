import 'package:flutter/material.dart';

import '../utils/json_utils.dart';

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

  /// Converte o JSON da API (ver API_CONTRATO.md) num Product.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: 'P-${(json['id'] ?? 0).toString().padLeft(3, '0')}',
      name: asString(json['nome'], ''),
      gender: asString(json['genero'], ''),
      category: asString(json['categoria'], ''),
      fabric: asString(json['tecido'], ''),
      size: asString(json['tamanho'], ''),
      price: asDouble(json['preco']),
      description: asString(json['descricao'], ''),
      composition: asString(json['composicao'], ''),
      lot: 'T-${(json['lote_id'] ?? 0).toString().padLeft(3, '0')}',
      history: ((json['historia'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      image: asString(json['imagem'], ''),
    );
  }

  String get priceLabel => '${price.toStringAsFixed(2).replaceAll('.', ',')} €';
}
