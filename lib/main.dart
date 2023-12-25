import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mobileproject/controllers/notification_controller.dart';
import 'package:mobileproject/screens/auth/login_page.dart';
import 'package:mobileproject/screens/home_page.dart';
import 'package:mobileproject/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'controllers/auth/login_controller.dart';
import 'firebase_options.dart';
import 'models/note_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationController.initializeNotification();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
    // Hata durumunda nasıl bir işlem yapılacağını belirleyebilirsiniz.
  }

  //Hive package initialization
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(NoteModelAdapter());
  await Hive.openBox<NoteModel>("notes");

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: LoginController().getCurrentUser(),
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
