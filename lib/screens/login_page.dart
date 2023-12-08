import 'dart:io';

import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'package:mobileproject/main.dart';
import 'package:mobileproject/screens/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _authController = AuthController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Geri tuşuna basıldığında uygulamadan çıkış yap
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Uygulamadan Çıkış Yap'),
            content: const Text('Uygulamadan çıkış yapmak istediğinize emin misiniz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hayır'),
              ),
              TextButton(
                onPressed: () {
                  // Uygulamadan çıkış yap
                  exit(0);
                },
                child: const Text('Evet'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Hata mesajını al ve setState ile ekranı yeniden çiz
                  setState(() {
                    _errorMessage = null; // Her tıklamada eski hatayı temizle
                  });

                  String? errorMessage = await _authController.loginUser(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );

                  if (errorMessage != null) {
                    setState(() {
                      _errorMessage = errorMessage;
                    });
                  } else {
                    // Giriş başarılıysa
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyApp(),
                      ),
                          (route) => false, // Tüm önceki sayfaları kaldır
                    );
                  }
                },
                child: const Text('Login'),
              ),

              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
