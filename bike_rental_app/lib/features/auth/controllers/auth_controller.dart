import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  bool isLoading = false;
  bool isAuthenticated = false;

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      await AuthService.login(email, password);

      isAuthenticated = true;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      await AuthService.register(name, email, password);

      isAuthenticated = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    isAuthenticated = false;
    notifyListeners();
  }
}
