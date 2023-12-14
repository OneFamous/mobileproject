

import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificaitonController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
      return true;
    } catch (e) {
      print("Error in sendEmailVerification: $e");
      return false;
    }
  }

  Future<bool> checkEmailVerification(String email) async {
    try {
      User? user = await _auth.currentUser;
      if (user != null && !user.emailVerified) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

}

