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
import 'package:shared_preferences/shared_preferences.dart';

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

  // Hive package initialization
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(NoteModelAdapter());
  await Hive.openBox<NoteModel>("notes");

  // Load theme preference from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final themePreference = prefs.getString('theme_preference');
  ThemeData initialTheme = themePreference == 'dark' ? darkMode : lightMode;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ThemeProvider(initialTheme)),
        FutureProvider<User?>(
          create: (context) => LoginController().getCurrentUser(),
          initialData: null,
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return MaterialApp(
      title: 'Flutter Demo',
      home: user != null ? const homePage() : const LoginPage(),
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
