import '../utils/json_utils.dart';

/// Utilizador autenticado.
class AppUser {
  final int? id; // id na base de dados (null nos dados de exemplo)
  final String name;
  final String email;
  final String role; // Doador / Cliente | Gestor
  final int points;
  final int donations;
  final double kgRecovered;

  const AppUser({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.points,
    required this.donations,
    required this.kgRecovered,
  });

  AppUser copyWith({int? points, int? donations, double? kgRecovered}) {
    return AppUser(
      id: id,
      name: name,
      email: email,
      role: role,
      points: points ?? this.points,
      donations: donations ?? this.donations,
      kgRecovered: kgRecovered ?? this.kgRecovered,
    );
  }

  /// Converte o JSON da API (ver API_CONTRATO.md) num AppUser.
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: asIntOrNull(json['id']),
      name: asString(json['nome']),
      email: asString(json['email']),
      role: json['tipo'] == 'gestor' ? 'Gestor' : 'Doador / Cliente',
      points: asInt(json['pontos']),
      donations: asInt(json['total_doacoes']),
      kgRecovered: asDouble(json['kg_recuperados']),
    );
  }

  String get firstName => name.split(' ').first;

  String get initials {
    final parts = name.split(' ');
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
