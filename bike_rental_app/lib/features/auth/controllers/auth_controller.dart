import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../../../core/services/storage_service.dart';

class AuthController extends ChangeNotifier {
  bool isLoading = false;

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      final token = await AuthService.login(email, password);
      await StorageService.saveToken(token);
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
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
