import 'package:flutter/material.dart';
import 'email_verificaiton_page.dart';
import 'package:mobileproject/controllers//auth/email_verificaiton_controller.dart';
import 'package:mobileproject/controllers//auth/register_controller.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final EmailVerificaitonController _emailVerificaitonController = EmailVerificaitonController();
  final RegisterController _registerController = RegisterController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _errorMessage;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: const TextStyle(color: Colors.black38),
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
                    prefixIcon: const Icon(Icons.person, color: Colors.black38),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.black38),
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
                    prefixIcon: const Icon(Icons.email, color: Colors.black38),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    labelStyle: const TextStyle(color: Colors.black38),
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
                    prefixIcon: const Icon(Icons.person, color: Colors.black38),
                  ),
                ),
                const SizedBox(height: 15),

                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.black38),
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
                    prefixIcon: const Icon(Icons.lock, color: Colors.black38),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 15),

                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: const TextStyle(color: Colors.black38),
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
                    prefixIcon: const Icon(Icons.lock, color: Colors.black38),
                  ),
                  obscureText: true,
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isProcessing ? null : _registerUser,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 44),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // İstediğiniz yuvarlaklık değerini burada belirleyebilirsiniz
                    ),
                  ),
                  child: Text(_isProcessing ? 'Processing...' : 'Register' ,
                    style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),),
                ),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
      ),
    );
  }

  Future<void> _registerUser() async {
    setState(() {
      _errorMessage = null;
      _isProcessing = true;
    });

    String? errorMessage = await _registerController.registerUser(
      name: _nameController.text,
      email: _emailController.text,
      userName: _userNameController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    if (errorMessage != null) {
      setState(() {
        _errorMessage = errorMessage;
        _isProcessing = false;
      });
    } else {
      // Kullanıcı başarıyla kaydedildiğinde e-posta doğrulama başlat
      try {
        await _emailVerificaitonController.sendEmailVerification();
        // Eğer her şey başarılıysa, başka bir sayfaya yönlendirme yapabilirsiniz
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const EmailVerificationPage()),
        );
      } catch (e) {
        setState(() {
          _errorMessage = 'Error sending email verification: $e';
          _isProcessing = false;
        });
      }
    }
  }

}
