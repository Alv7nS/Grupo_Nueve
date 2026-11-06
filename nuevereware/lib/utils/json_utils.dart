/// Conversões tolerantes para JSON vindo da API.
/// Ex.: o MySQL (mysql2) devolve DECIMAL como texto ("42.00").
double asDouble(dynamic v, [double fallback = 0]) {
  if (v is num) return v.toDouble();
  return double.tryParse('${v ?? ''}'.replaceAll(',', '.')) ?? fallback;
}

int asInt(dynamic v, [int fallback = 0]) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse('${v ?? ''}') ?? fallback;
}

int? asIntOrNull(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse('$v');
}

String asString(dynamic v, [String fallback = '']) => v == null ? fallback : '$v';

const _months = [
  'jan.', 'fev.', 'mar.', 'abr.', 'mai.', 'jun.',
  'jul.', 'ago.', 'set.', 'out.', 'nov.', 'dez.',
];

/// "2026-11-06T14:20:00.000Z" → "06 nov., 14:20". Se não for uma data, devolve o texto.
String asDateLabel(dynamic v) {
  final text = asString(v);
  final date = DateTime.tryParse(text)?.toLocal();
  if (date == null) return text;
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(date.day)} ${_months[date.month - 1]}, ${two(date.hour)}:${two(date.minute)}';
}
