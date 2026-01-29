import 'package:flutter/material.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/map/screens/map_screen.dart';
import '../features/ride/screens/scan_qr_screen.dart';
import '../features/ride/screens/payment_screen.dart';

class AppRoutes {
  static const login = "/login";
  static const register = "/register";
  static const map = "/map";
  static const scanQr = "/scan-qr";
  static const payment = "/payment";


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());

      case map:
        return MaterialPageRoute(builder: (_) => MapScreen());

      case scanQr:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ScanQrScreen(
            userId: args["userId"],
            startStation: args["startStation"],
            endStation: args["endStation"],
          ),
        );

      case payment:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => PaymentScreen(
            userId: args["userId"],
            dockId: args["dockId"],
            startStation: args["startStation"],
            endStation: args["endStation"],
          ),
        );


      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text("Route not found")),
          ),
        );
    }
  }
}
