import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_service.dart';

class AuthService {
  /// REGISTER
  static Future<String> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await ApiService.post("/auth/register", {
      "name": name,
      "email": email,
      "password": password,
    });

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("token", response["token"]);
    await prefs.setString("userId", response["user"]["_id"]);
    await prefs.setString("userName", response["user"]["name"]);
    await prefs.setString("userEmail", response["user"]["email"]);

    return response["token"]; // ✅ IMPORTANT
  }

  /// LOGIN
  static Future<String> login(
    String email,
    String password,
  ) async {
    final response = await ApiService.post("/auth/login", {
      "email": email,
      "password": password,
    });

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("token", response["token"]);
    await prefs.setString("userId", response["user"]["_id"]);
    await prefs.setString("userName", response["user"]["name"]);
    await prefs.setString("userEmail", response["user"]["email"]);

    return response["token"]; // ✅ IMPORTANT
  }

  /// GETTERS
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId");
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
