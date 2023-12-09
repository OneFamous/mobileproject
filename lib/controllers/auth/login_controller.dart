import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import 'package:mobileproject/controllers//auth/email_verificaiton_controller.dart';


class LoginController {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EmailVerificaitonController _emailVerificaitonController = EmailVerificaitonController();

  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Kullanıcının e-posta adresini doğrulamış mı kontrol et
      bool isEmailVerified = await _emailVerificaitonController.checkEmailVerification(email);

      if (!isEmailVerified) {  //TODO: Her durumda buraya düşüyor kontrol et.
        return 'E-posta adresinizi doğrulayın.';
      }

      // Eğer doğrulama yapılmışsa, kullanıcıyı oturum açmaya çalış
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).get();
        //UserModel loggedInUser = UserModel.fromFirestore(userDoc);
        print('User logged in: ${isEmailVerified}');
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred.';
    }
    return 'An unexpected error occurred.';
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
  Future<String?> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return null;
    } catch (e) {
      return 'An unexpected error occurred while logging out.';
    }
  }
}
