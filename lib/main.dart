import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'controllers/auth_controller.dart';
import 'firebase_options.dart';
import 'package:mobileproject/screens/login_page.dart';
import 'package:mobileproject/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
    // Hata durumunda nasıl bir işlem yapılacağını belirleyebilirsiniz.
  }

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: AuthController().getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Eğer beklenen bir sonuç varsa, bir yükleniyor göster
          return CircularProgressIndicator();
        } else {
          // Beklenen sonuç geldiyse
          User? currentUser = snapshot.data;

          return MaterialApp(
            title: 'Flutter Demo',
            home: currentUser != null ? const homePage() : const LoginPage(),
            debugShowCheckedModeBanner: false,
          );
        }
      },
    );
  }
}
