import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobileproject/screens/auth/forgot_password_page.dart';
import '../../controllers/auth/login_controller.dart';
import 'package:mobileproject/main.dart';
import 'package:mobileproject/screens/auth/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _loginController = LoginController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Geri tuşuna basıldığında uygulamadan çıkış yap
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Log out of the application?'),
            content: const Text(
                'Are you sure you want to log out of the application?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  // Uygulamadan çıkış yap
                  exit(0);
                },
                child: const Text('Yes'),
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
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(5.0), // Yuvarlaklık değeri
                    borderSide: const BorderSide(color: Colors.deepOrange),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(color: Colors.deepOrange),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  prefixIcon: Icon(Icons.email,
                      color: Theme.of(context).colorScheme.tertiary),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(color: Colors.deepOrange),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(color: Colors.deepOrange),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  prefixIcon: Icon(Icons.lock,
                      color: Theme.of(context).colorScheme.tertiary),
                ),
                obscureText: true,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage(),
                    ),
                  );
                },
                child: Container(
                  alignment: Alignment.centerLeft, // Butonu sola hizala
                  child: const Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                      color: Colors.deepOrange,
                    ),
                    textAlign: TextAlign
                        .left, // Metni sola hizala (opsiyonel, eğer metni sola hizalı istiyorsanız)
                  ),
                ),
              ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  // Hata mesajını al ve setState ile ekranı yeniden çiz
                  setState(() {
                    _errorMessage = null; // Her tıklamada eski hatayı temizle
                  });

                  String? errorMessage = await _loginController.loginUser(
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
                        builder: (context) => const MyApp(),
                      ),
                      (route) => false, // Tüm önceki sayfaları kaldır
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 44),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Register here",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
