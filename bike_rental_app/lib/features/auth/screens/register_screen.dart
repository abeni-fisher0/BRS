import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(title: Text("Create Account")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: auth.isLoading
                  ? null
                  : () async {
                      await auth.register(
                        nameCtrl.text,
                        emailCtrl.text,
                        passwordCtrl.text,
                      );
                      Navigator.pop(context); // back to login
                    },
              child: auth.isLoading
                  ? CircularProgressIndicator()
                  : Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
