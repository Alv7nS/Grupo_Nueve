/// Utilizador autenticado (dados fictícios nesta fase).
class AppUser {
  final String name;
  final String email;
  final String role; // Doador / Cliente | Gestor
  final int points;
  final int donations;
  final double kgRecovered;

  const AppUser({
    required this.name,
    required this.email,
    required this.role,
    required this.points,
    required this.donations,
    required this.kgRecovered,
  });

  AppUser copyWith({int? points, int? donations, double? kgRecovered}) {
    return AppUser(
      name: name,
      email: email,
      role: role,
      points: points ?? this.points,
      donations: donations ?? this.donations,
      kgRecovered: kgRecovered ?? this.kgRecovered,
    );
  }

  String get firstName => name.split(' ').first;

  String get initials {
    final parts = name.split(' ');
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
