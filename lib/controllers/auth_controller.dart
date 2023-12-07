// controllers/auth_controller.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthController {
  Future<void> registerUser({
    required String name,
    required String email,
    required String userName,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      print('Passwords do not match.');
      return;
    }

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Auth işlemi başarılıysa Firestore'a kullanıcı bilgilerini kaydet
      if (credential.user != null) {
        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
          'name': name,
          'email': email,
          'userName': userName,
          // Diğer kullanıcı bilgilerini ekleyebilirsiniz.
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Auth işlemi başarılıysa kullanıcı bilgilerini alabilirsiniz
      if (credential.user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).get();
        UserModel loggedInUser = UserModel.fromFirestore(userDoc);
        print('User logged in: ${loggedInUser.email}');
        // İsterseniz bu kullanıcı bilgilerini bir state yönetim aracı ile saklayabilirsiniz.
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
  }
}
