import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}$endpoint"),
      headers: { "Content-Type": "application/json" },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 400) {
      throw data["message"] ?? "Something went wrong";
    }

    return data;
  }
}
