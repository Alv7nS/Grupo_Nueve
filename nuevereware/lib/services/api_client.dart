import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

/// Erro devolvido pela API ou por falta de ligação.
/// [statusCode] é null quando o servidor não foi alcançado.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  /// true quando o problema é de ligação (servidor desligado, timeout...).
  bool get isConnectionError => statusCode == null;

  @override
  String toString() => message;
}

/// Cliente HTTP genérico: envia e recebe JSON e trata os erros num só sítio.
class ApiClient {
  ApiClient._();

  static final http.Client _http = http.Client();

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json',
  };

  static Uri _uri(String path, [Map<String, String>? query]) {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    return query == null ? uri : uri.replace(queryParameters: query);
  }

  static Future<dynamic> get(String path, {Map<String, String>? query}) =>
      _send(() => _http.get(_uri(path, query), headers: _headers));

  static Future<dynamic> post(String path, Map<String, dynamic> body) =>
      _send(() => _http.post(_uri(path), headers: _headers, body: jsonEncode(body)));

  static Future<dynamic> patch(String path, Map<String, dynamic> body) =>
      _send(() => _http.patch(_uri(path), headers: _headers, body: jsonEncode(body)));

  static Future<dynamic> _send(Future<http.Response> Function() request) async {
    if (ApiConfig.offlineMode) {
      throw const ApiException('Modo offline ativo (dados de exemplo).');
    }

    late http.Response res;
    try {
      res = await request().timeout(ApiConfig.timeout);
    } on TimeoutException {
      throw const ApiException('O servidor não respondeu a tempo.');
    } catch (_) {
      throw ApiException('Sem ligação ao servidor (${ApiConfig.baseUrl}).');
    }

    dynamic body;
    if (res.bodyBytes.isNotEmpty) {
      try {
        body = jsonDecode(utf8.decode(res.bodyBytes));
      } on FormatException {
        body = null;
      }
    }

    if (res.statusCode >= 200 && res.statusCode < 300) return body;

    final message = body is Map && body['erro'] != null
        ? body['erro'].toString()
        : 'Erro ${res.statusCode} do servidor.';
    throw ApiException(message, res.statusCode);
  }

  /// Aceita respostas no formato `{ "chave": {...} }` ou diretamente `{...}`.
  static Map<String, dynamic> objectFrom(dynamic data, String key) {
    if (data is Map && data[key] is Map) {
      return Map<String, dynamic>.from(data[key] as Map);
    }
    if (data is Map) return Map<String, dynamic>.from(data);
    throw const ApiException('Resposta inesperada do servidor.', 500);
  }

  /// Aceita respostas no formato `{ "chave": [...] }` ou diretamente `[...]`.
  static List<Map<String, dynamic>> listFrom(dynamic data, String key) {
    final raw = data is Map ? data[key] : data;
    if (raw is! List) throw const ApiException('Resposta inesperada do servidor.', 500);
    return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
