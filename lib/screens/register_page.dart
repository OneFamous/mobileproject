// pages/register_page.dart

import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController _authController = AuthController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _errorMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _userNameController,
              decoration: const InputDecoration(labelText: 'User Name'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {

                // Hata mesajını al ve setState ile ekranı yeniden çiz
                setState(() {
                  _errorMessage = null; // Her tıklamada eski hatayı temizle
                });

                String? errorMessage = await _authController.registerUser(
                  name: _nameController.text,
                  email: _emailController.text,
                  userName: _userNameController.text,
                  password: _passwordController.text,
                  confirmPassword: _confirmPasswordController.text,
                );
                if (errorMessage != null) {
                  setState(() {
                    _errorMessage = errorMessage;
                  });
                }
              },
              child: const Text('Register'),
            ),

            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),

          ],
        ),
      ),
    );
  }
}
