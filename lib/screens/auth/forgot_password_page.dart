import 'dart:io';

import 'package:flutter/material.dart';
import '../../controllers/auth/login_controller.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final LoginController _loginController = LoginController();
  final TextEditingController _emailController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
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
            title: const Text('Log out of the application'),
            content: const Text('Are you sure you want to log out of the application?'),
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back , color: Colors.deepOrange),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 40.0),
                child:
                    Text(
                    'Forgot Password',
                    style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold ,color: Colors.deepOrange),
                  ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20.0 ,left: 5,right: 5),
                child: Text(
                  'Enter the email address associated with your account and we will send you a link to reset your password.',
                  style: TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic , color: Colors.grey[600]),
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.black38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0), // Yuvarlaklık değeri
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
                  prefixIcon: const Icon(Icons.email ,color: Colors.black38),
                ),
              ),
              const SizedBox(height: 10),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  String email = _emailController.text.trim();
                  String? response = await _loginController.resetPassword(email);
                  if(response == null){

                    // Şifre sıfırlama e-postası gönderildiğinde kullanıcıyı bilgilendir.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('A password reset email has been sent.'),
                      ),
                    );
                  } else {
                    // Hata durumunda kullanıcıyı bilgilendir.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$response'),
                      ),
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
                child: const Text('Send' ,style: TextStyle(color: Colors.white),),
              ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
