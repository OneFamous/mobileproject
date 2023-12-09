

import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificaitonController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      throw e;
    }
  }

  Future<bool> checkEmailVerification(String email) async {
    try {
      // E-posta adresine ait kullanıcıyı al
      User? user = await _auth.fetchSignInMethodsForEmail(email).then((methods) {
        if (methods.isNotEmpty) {
          return _auth.currentUser;
        }
        return null;
      });
      if (user != null && !user.emailVerified) {
        return false;
      }
      return true;
    } catch (e) {
      print('Error checking email verification: $e');
      return false;
    }
  }
}

