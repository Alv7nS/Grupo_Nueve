import '../data/mock_data.dart';
import '../models/app_user.dart';
import 'api_client.dart';

/// Autenticação e registo (POST /auth/login, POST /utilizadores).
class AuthService {
  AuthService._();

  static Future<AppUser> login(String email, String password) async {
    final data = await ApiClient.post('/auth/login', {
      'email': email.trim(),
      'password': password,
    });
    final user = AppUser.fromJson(ApiClient.objectFrom(data, 'utilizador'));
    MockData.setSession(user);
    return user;
  }

  static Future<AppUser> register(String name, String email, String password) async {
    final data = await ApiClient.post('/utilizadores', {
      'nome': name.trim(),
      'email': email.trim(),
      'password': password,
      'consentimento_rgpd': true,
    });
    final user = AppUser.fromJson(ApiClient.objectFrom(data, 'utilizador'));
    MockData.setSession(user);
    return user;
  }
}
