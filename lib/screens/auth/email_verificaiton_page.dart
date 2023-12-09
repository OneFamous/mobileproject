import 'package:flutter/material.dart';
import 'package:mobileproject/controllers//auth/email_verificaiton_controller.dart';


class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final EmailVerificaitonController _emailVerificaitonController = EmailVerificaitonController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.email,
                size: 90,
                color: Colors.deepOrange,
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
                style: TextStyle(fontSize: 14, color: Colors.deepOrange , fontStyle: FontStyle.italic),
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
                  onPressed: () async {
                    await _emailVerificaitonController.sendEmailVerification();
                  },
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

            ],
          ),
        ),
      ),
    );
  }
}
