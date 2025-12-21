import '../../../core/services/api_service.dart';

class AuthService {
  static Future<void> register(String name, String email, String password) async {
    await ApiService.post("/auth/register", {
      "name": name,
      "email": email,
      "password": password
    });
  }

  static Future<String> login(String email, String password) async {
    final response = await ApiService.post("/auth/login", {
      "email": email,
      "password": password
    });

    return response["token"];
  }
}
