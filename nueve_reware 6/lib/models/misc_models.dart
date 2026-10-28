import 'package:flutter/material.dart';

import 'donation.dart';

/// Notificação mostrada ao utilizador (no futuro: notificação push).
class AppNotification {
  final String title;
  final String body;
  final String time;
  final IconData icon;
  final bool unread;
  final String? donationId; // abre o acompanhamento, se existir

  const AppNotification({
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    this.unread = false,
    this.donationId,
  });
}

/// Ponto de recolha parceiro.
class CollectionPoint {
  final String name;
  final String address;
  final String postalCode;
  final String hours;
  final String distance;
  final double lat;
  final double lng;
  final String directions; // como chegar (transportes)
  final String contact;

  const CollectionPoint({
    required this.name,
    required this.address,
    required this.postalCode,
    required this.hours,
    required this.distance,
    required this.lat,
    required this.lng,
    required this.directions,
    required this.contact,
  });
}

/// Resultado do cálculo de portes (zona, preço e prazo).
typedef ShippingQuote = ({double price, String zone, String eta});

/// Morada escrita pelo utilizador + portes calculados para essa morada.
class ShippingResult {
  final String address;
  final String postalCode;
  final String city;
  final ShippingQuote quote;

  const ShippingResult({
    required this.address,
    required this.postalCode,
    required this.city,
    required this.quote,
  });

  String get fullAddress => '$address, $postalCode $city';
}

/// Argumentos do fluxo de entrega: o pedido e o local escolhido.
class DeliveryArgs {
  final Donation donation;
  final CollectionPoint point;
  final bool byMail;
  final bool fromQr; // true quando as instruções são abertas a partir do QR Code
  final ShippingResult? shipping; // morada do doador + portes (envio por correio)

  const DeliveryArgs({
    required this.donation,
    required this.point,
    this.byMail = false,
    this.fromQr = false,
    this.shipping,
  });

  DeliveryArgs openedFromQr() => DeliveryArgs(
        donation: donation,
        point: point,
        byMail: byMail,
        fromQr: true,
        shipping: shipping,
      );
}

/// Fotografia de exemplo usada para simular a câmara/galeria.
/// Os campos opcionais servem para pré-preencher o formulário da doação.
class SamplePhoto {
  final String asset;
  final String label;
  final String? category;
  final String? condition;
  final String? fabric;
  final String? composition;
  final String? notes;

  const SamplePhoto({
    required this.asset,
    required this.label,
    this.category,
    this.condition,
    this.fabric,
    this.composition,
    this.notes,
  });
}

/// Movimento de pontos (doações validadas, descontos usados).
class PointsEntry {
  final String description;
  final String date;
  final int amount; // positivo = ganho, negativo = usado

  const PointsEntry({
    required this.description,
    required this.date,
    required this.amount,
  });
}

/// Recompensa que pode ser trocada por pontos.
class Reward {
  final String title;
  final String subtitle;
  final int cost;

  const Reward({required this.title, required this.subtitle, required this.cost});
}

/// Lote de tecido recebido e em transformação (área do gestor).
class FabricLot {
  final String id;
  final String fabric;
  final String origin;
  final double kg;
  final String stage;
  final double progress; // 0..1

  const FabricLot({
    required this.id,
    required this.fabric,
    required this.origin,
    required this.kg,
    required this.stage,
    required this.progress,
  });
}

/// Passo de um percurso/linha temporal.
enum TimelineState { done, current, pending }

class TimelineItem {
  final String title;
  final String subtitle;
  final TimelineState state;

  const TimelineItem(this.title, this.subtitle, this.state);
}
