import 'package:flutter/foundation.dart';

/// Configuração da ligação ao servidor REST (Node.js + MySQL).
///
/// Endereço por defeito:
///  - Web / Windows / macOS: http://localhost:3000
///  - Emulador Android:      http://10.0.2.2:3000  (10.0.2.2 = o PC visto pelo emulador)
///  - Telemóvel físico: correr com
///      flutter run --dart-define=API_URL=http://<IP-do-PC>:3000
///    (o telemóvel e o PC têm de estar na mesma rede Wi-Fi)
class ApiConfig {
  ApiConfig._();

  static const String _override = String.fromEnvironment('API_URL');

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    if (kIsWeb) return 'http://localhost:3000';
    if (defaultTargetPlatform == TargetPlatform.android) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000';
  }

  /// Tempo máximo de espera por uma resposta.
  static const Duration timeout = Duration(seconds: 8);

  /// true = não contacta o servidor e usa só os dados de exemplo (MockData).
  /// Útil para apresentar a app sem o servidor ligado.
  static bool offlineMode = false;
}
