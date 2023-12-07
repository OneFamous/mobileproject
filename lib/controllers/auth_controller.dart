// controllers/auth_controller.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthController {
  Future<String?> registerUser({
    required String name,
    required String email,
    required String userName,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      return 'Passwords do not match.';
    }

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
          'name': name,
          'email': email,
          'userName': userName,
        });
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred.';
    }
    return 'An unexpected error occurred.';
  }

  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).get();
        UserModel loggedInUser = UserModel.fromFirestore(userDoc);
        print('User logged in: ${loggedInUser.email}');
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
  Future<String?> logout() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {  //TODO:Auth check => tüm scrennlerde kullanmak için providers konusunu araştır!
        await FirebaseAuth.instance.signOut();
        return null;
      } else {
        return 'No user is currently signed in.';
      }
    } catch (e) {
      return 'An unexpected error occurred while logging out.';
    }
  }
}