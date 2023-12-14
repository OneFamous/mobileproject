import 'package:flutter/material.dart';
import 'package:mobileproject/controllers//auth/email_verificaiton_controller.dart';

import 'login_page.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage>
    with TickerProviderStateMixin {
  final EmailVerificaitonController _emailVerificaitonController =
  EmailVerificaitonController();
  bool _isButtonEnabled = true;
  String? _errorMessage;
  Color? _errorMessageColor;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 10, // İstediğiniz yukarı hareket mesafesini burada belirleyebilirsiniz
    ).animate(_animationController);

    _animationController.repeat(reverse: true); // Animasyonu sürekli tekrarla
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _animation.value),
                    child: const Icon(
                      Icons.email,
                      size: 90,
                      color: Colors.deepOrange,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Please verify your email address',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'After verifying your email, ',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const Text(
                'please restart the app.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.deepOrange,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                "If you haven't received the email, click the button below:",
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isButtonEnabled ? _handleButtonPress : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepOrange,
                  side: const BorderSide(width: 2, color: Colors.deepOrange),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Resend Verification Email'),
              ),
              const SizedBox(height: 10),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: _errorMessageColor),
                ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Buraya login ekranına git işlemini ekleyin
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text(
                  'Go to Login',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleButtonPress() async {
    setState(() {
      _errorMessage = null;
      _isButtonEnabled = false;
    });
    bool isEmailSent = await _emailVerificaitonController.sendEmailVerification();
    print("Is Email Sent: $isEmailSent");
    if (isEmailSent) {
      setState(() {
        _errorMessage = "Email Sent!";
        _errorMessageColor = Colors.green;
      });
    } else {
      setState(() {
        _errorMessage = "Email can't be sent!";
        _errorMessageColor = Colors.red;
      });
    }
    await Future.delayed(const Duration(seconds: 30));
    setState(() {
      _isButtonEnabled = true;
    });
  }

}