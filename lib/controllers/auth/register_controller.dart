import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> registerUser({
    required String name,
    required String email,
    required String userName,
    required String password,
    required String confirmPassword,
  }) async {
    if (name.isEmpty || email.isEmpty || userName.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      return 'Please fill in all fields.';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match.';
    }
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
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
      return 'An unexpected error occurred.';
    } on FirebaseAuthException catch (e) {
        return e.message;
    } catch (e) {
      return 'An unexpected error occurred.';
    }
  }
}