import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobileproject/controllers//auth/email_verificaiton_controller.dart';


class LoginController {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EmailVerificaitonController _emailVerificaitonController = EmailVerificaitonController();
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return 'Email and password cannot be empty.';
      }
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        bool isEmailVerified = await _emailVerificaitonController.checkEmailVerification(email);
        if (!isEmailVerified) {
          await _auth.signOut();
          return 'E-posta adresinizi doğrulayın.';
        }
        DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).get();
        //UserModel loggedInUser = UserModel.fromFirestore(userDoc);
        return null;
      }
      return 'An unexpected error occurred.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.code == 'invalid-email') {
        return 'Please check your information.';
      } else {
        return 'An unexpected error occurred.';
      }
    } catch (e) {
      return 'An unexpected error occurred.';
    }
  }

  Future<User?> getCurrentUser() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      if (currentUser.emailVerified) {
        return _auth.currentUser;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      // E-posta adresiyle ilişkilendirilmiş hesaplar
      List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);

      if (signInMethods.isNotEmpty) {
        await _auth.sendPasswordResetEmail(email: email);
        return null; // Şifre sıfırlama başarılı
      } else {
        return 'No user found with this email address.';
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred.';
    }
  }

  Future<String?> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return null;
    } catch (e) {
      return 'An unexpected error occurred while logging out.';
    }
  }
}
