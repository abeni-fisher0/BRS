import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  static const Map<String, String> _headers = {
    "Content-Type": "application/json",
  };

  // =======================
  // GET
  // =======================
  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}$endpoint"),
      headers: _headers,
    );

    return _handleResponse(response);
  }

  // =======================
  // POST
  // =======================
  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}$endpoint"),
      headers: _headers,
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // =======================
  // PUT
  // =======================
  static Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final response = await http.put(
      Uri.parse("${ApiConfig.baseUrl}$endpoint"),
      headers: _headers,
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // =======================
  // DELETE
  // =======================
  static Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse("${ApiConfig.baseUrl}$endpoint"),
      headers: _headers,
    );

    return _handleResponse(response);
  }

  // =======================
  // RESPONSE HANDLER
  // =======================
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        "API Error ${response.statusCode}: ${response.body}",
      );
    }

    if (response.body.isEmpty) return null;

    try {
      return jsonDecode(response.body);
    } catch (_) {
      throw Exception("Invalid JSON response: ${response.body}");
    }
  }
}
